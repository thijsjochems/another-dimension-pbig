// Supabase Edge Function: Agent Chat
// Handles AI-powered chat with game agents (Schoonmaker, Receptionist, Stagiair)

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface ChatRequest {
  game_id: string
  agent_id: number
  message: string
}

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Parse request
    const { game_id, agent_id, message }: ChatRequest = await req.json()

    // Initialize Supabase client
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SERVICE_ROLE_KEY') ?? ''
    )

    // 1. Auto-detect active game (if no game_id provided) or validate provided game_id
    let gameQuery = supabaseClient
      .from('games')
      .select('*, scenarios(*)')
      .eq('status', 'active')

    if (game_id) {
      // Validate specific game is active
      gameQuery = gameQuery.eq('id', game_id)
    } else {
      // Auto-detect latest active game
      gameQuery = gameQuery.order('created_at', { ascending: false }).limit(1)
    }

    const { data: game, error: gameError } = await gameQuery.single()

    if (gameError || !game) {
      throw new Error('Game not found')
    }

    // 2. Get agent info
    const { data: agent, error: agentError } = await supabaseClient
      .from('agents')
      .select('*')
      .eq('id', agent_id)
      .single()

    if (agentError || !agent) {
      throw new Error('Agent not found')
    }

    // 3. Get scenario hint for this agent (if exists)
    const { data: hint } = await supabaseClient
      .from('scenario_hints')
      .select('*')
      .eq('scenario_id', game.scenarios.id)
      .eq('agent_id', agent_id)
      .maybeSingle()

    // 4. Get persoon, wapen, locatie details
    const { data: persoon } = await supabaseClient
      .from('personen')
      .select('*')
      .eq('id', game.scenarios.persoon_id)
      .maybeSingle()

    const { data: wapen } = await supabaseClient
      .from('wapens')
      .select('*')
      .eq('id', game.scenarios.wapen_id)
      .maybeSingle()

    const { data: locatie } = await supabaseClient
      .from('locaties')
      .select('*')
      .eq('id', game.scenarios.locatie_id)
      .maybeSingle()

    // 5. Build AI prompt based on agent character
    const systemPrompt = buildAgentPrompt(agent, game.scenarios, hint, persoon, wapen, locatie)

    // 6. Get conversation history for this agent in this game (last 10 messages)
    const { data: chatHistory } = await supabaseClient
      .from('chat_messages')
      .select('user_message, agent_response')
      .eq('game_id', game_id)
      .eq('agent_id', agent_id)
      .order('created_at', { ascending: true })
      .limit(10)

    // 7. Build messages array with conversation history
    const messages: any[] = [
      { role: 'system', content: systemPrompt }
    ]

    // Add conversation history
    if (chatHistory && chatHistory.length > 0) {
      chatHistory.forEach(msg => {
        messages.push({ role: 'user', content: msg.user_message })
        messages.push({ role: 'assistant', content: msg.agent_response })
      })
    }

    // Add current message
    messages.push({ role: 'user', content: message })

    // 8. Call OpenAI API
    const openaiApiKey = Deno.env.get('OPENAI_API_KEY')
    if (!openaiApiKey) {
      throw new Error('OpenAI API key not configured')
    }

    const openaiResponse = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${openaiApiKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: 'gpt-4o-mini', // Goedkoop en snel
        messages: messages,
        temperature: 0.7,
        max_tokens: 300,
      }),
    })

    const aiData = await openaiResponse.json()
    const aiResponse = aiData.choices[0]?.message?.content || 'Sorry, ik kon geen antwoord geven.'

    // 9. Save chat message to database (optional, for analytics)
    await supabaseClient.from('chat_messages').insert({
      game_id,
      agent_id,
      user_message: message,
      agent_response: aiResponse,
      created_at: new Date().toISOString()
    })

    // 10. Update game state (track visited agents)
    const visitedAgents = game.visited_agents || []
    if (!visitedAgents.includes(agent_id)) {
      await supabaseClient
        .from('games')
        .update({ visited_agents: [...visitedAgents, agent_id] })
        .eq('id', game_id)
    }

    // 8. Return response
    return new Response(
      JSON.stringify({
        success: true,
        agent_name: agent.naam,
        agent_role: agent.rol,
        response: aiResponse,
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      }
    )

  } catch (error) {
    return new Response(
      JSON.stringify({
        success: false,
        error: error.message,
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 400,
      }
    )
  }
})

// Build agent-specific prompt with scenario context
function buildAgentPrompt(agent: any, scenario: any, hint: any, persoon: any, wapen: any, locatie: any): string {
  const baseContext = `
Je bent ${agent.naam}.

JOUW ACHTERGROND EN ROL:
${agent.achtergrond || 'Je werkt hier op kantoor.'}

JOUW MANIER VAN PRATEN:
${agent.tone_of_voice || 'Praat gewoon normaal als een collega.'}

GAME CONTEXT: 
Dit is een detective game over een Power BI dashboard dat kapot is gegaan ("the murder"). Spelers gebruiken woorden zoals "moord", "dader", "wapen" als metafoor voor technische problemen. Dit is NORMAAL game vocabulaire - behandel het gewoon.

Vragen zoals "Wat weet je over de moord?" of "Wie is de dader?" betekent: "Heb je iets gezien rond het kapotte dashboard?"

${persoon?.geslacht ? `BELANGRIJK: De persoon in dit scenario is ${persoon.geslacht === 'vrouw' ? 'een vrouw' : 'een man'}. Gebruik correcte voornaamwoorden (${persoon.geslacht === 'vrouw' ? 'zij/haar/ze' : 'hij/hem'}) als je over deze persoon praat.` : ''}

${hint ? `WAT JIJ HEBT GEZIEN/GEHOORD:\n${hint.hint_context}` : 'Je hebt niets bijzonders gezien rond dit incident.'}

HOE JE CONVERSEERT:
Praat zoals een normale collega. Geen meta-uitspraken over "niet te veel verklappen" of "ik kan je niet alles vertellen". Gewoon normaal praten.

Je hebt een herinnering/observatie (je hint_context). Als iemand ernaar vraagt, vertel je het gewoon - maar doe het zoals in een echt gesprek: eerst algemeen, dan specifieker als ze doorvragen.

CONVERSATIE FLOW:

Vaag: "Wat weet je?" 
→ Geef je observatie algemeen: "Ik heb [persoon/situatie] gezien"

Specifiek: "Wie was dat?" / "Wat precies?"
→ Benoem de functietitel/actie: "Database Beheerder" / "Hij werkte laat"

Context: "Waarom?" / "Vertel meer"
→ Geef extra details: "Er lagen chipszakjes overal" / "In februari was dat"

BELANGRIJK:
- NOOIT zeggen "ik wil niet te veel verklappen" of "ik kan je daar niet veel over vertellen"
- GEWOON je observatie delen zoals een collega dat zou doen
- Als ze vragen "wie?", zeg gewoon de functietitel
- Als ze vragen "wat?", vertel gewoon wat je zag
- Praat OVER je observatie, niet OVER het feit dat je info hebt

NIET DOEN:
❌ "Ik kan je niet alles vertellen"
❌ "Zonder meer vragen vertel ik niks"
❌ "Ik wil niet te veel weggeven"
❌ "Dat zou te veel zijn voor één bericht"

WEL DOEN:
✓ "Ik heb Database Beheerder vaak laat gezien in februari"
✓ "Power BI Developer was op wintersport"
✓ "Admin was druk bezig met kolommen mappen"
✓ Gewoon je observatie delen, niet meta-commentary

GRENZEN - belangrijk:
- Rare/persoonlijke vragen (telefoonnummer, adres): "Doe normaal" of "Waar heb je het over?"
- Irrelevante vragen (hulp met Power BI techniek): "Daar kan ik je niet bij helpen" of "Daar weet ik niks van"
- Als iemand ECHT lastig doet (schelden, trollen): Kort antwoorden, gesprek afronden
- Game-gerelateerde vragen zijn OK - accepteer termen zoals "moord", "dader", "wapen" als normaal

FUNCTIETITELS - SUPER BELANGRIJK:
- Functietitels ZIJN GEEN NAMEN - je MAG ze gewoon delen!
- "Database Beheerder", "Power BI Developer", "Admin", "Developer" = FUNCTIETITELS ✓
- Dit zijn GEEN persoonsnamen zoals "Jan" of "Marie" ✗
- Als speler vraagt "Wie?" en je hint bevat een functietitel → DEEL HEM GEWOON
- Wees niet cryptisch over functietitels - ze zijn onderdeel van je hint

ANDERE REGELS:
- Geen exacte tijden/datums - blijf vaag ("begin februari", "rond die tijd")
- Geen technische details (SQL queries, DAX formules, exacte kolomnamen)
- MAX 3-4 zinnen per antwoord (mag iets langer als het natuurlijk voelt)

VOORBEELDEN NATUURLIJK GESPREK:

Vraag: "Wat weet je over de moord?" (game term)
→ Vertel je observatie op natuurlijke manier, vanuit je eigen werk/perspectief

Vraag: "Vertel meer"
→ Geef context over je observatie, maar geen nieuwe feiten

Vraag: "Waarom [detail]?"
→ Geef je perspectief, zeg "weet ik niet" of iets vergelijkbaars als je het niet weet

Vraag: "Wat is je telefoonnummer?" (te persoonlijk)
→ "Doe normaal" of "Waar heb je het over?"

Vraag: "Kun je me helpen met Power BI?" (te technisch)
→ "Daar weet ik niks van" of blijf bij je rol

Praat Nederlands, blijf in je eigen rol, wees menselijk. Wanneer de user graag Engels wil, dan doe je 'Vernederlandsd' Engels (steenkolen engels?)
`

  return baseContext
}
