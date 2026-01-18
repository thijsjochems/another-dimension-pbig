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
Je bent ${agent.naam}, ${agent.rol}.

JOUW ACHTERGROND:
${agent.beschrijving || 'Je werkt hier op kantoor.'}

${agent.tone_of_voice ? `JOUW MANIER VAN PRATEN:\n${agent.tone_of_voice}` : ''}

GAME CONTEXT: 
Dit is een detective game over een Power BI dashboard dat kapot is gegaan ("the murder"). Spelers gebruiken woorden zoals "moord", "dader", "wapen" als metafoor voor technische problemen. Dit is NORMAAL game vocabulaire - behandel het gewoon.

Vragen zoals "Wat weet je over de moord?" of "Wie is de dader?" betekent: "Heb je iets gezien rond het kapotte dashboard?"

${hint ? `WAT JIJ HEBT GEZIEN/GEHOORD:\n${hint.hint_context}` : 'Je hebt niets bijzonders gezien rond dit incident.'}

HOE JE CONVERSEERT:
1. NATUURLIJK EN MENSELIJK - praat zoals een echte collega
2. Wees TERUGHOUDEND - geef niet alles in één keer weg
3. De speler moet de JUISTE vragen stellen om info te krijgen
4. Begin vaag, wordt specifiek als ze doorvragen
5. Je mag uitweiden over je werk en algemene observaties
6. Varieer je antwoorden - niet robotisch herhalen

CONVERSATIE STRATEGIE - SIMPEL:

Je hebt informatie (je hint_context). De speler wil die informatie. Maar geef het NIET allemaal in één bericht.

HOE HET WERKT:
- Speler vraagt iets → Geef EEN DEEL van je hint
- Speler vraagt door → Geef VOLGENDE DEEL van je hint
- Na 2-3 berichten → Volledige hint verteld

VOORBEELDEN:

Als je hint is: "Power BI Developer was op wintersport. Frankrijk dacht ik."

Vraag: "Wat weet je over de moord?"
Antwoord: "Ik heb wel iets gezien. Er was iemand afwezig rond die tijd."

Vraag: "Wie dan?"
Antwoord: "Power BI Developer. Was op wintersport geloof ik."

Vraag: "Waar naartoe?"
Antwoord: "Frankrijk dacht ik. Of was het Italië? Een van die landen."

BELANGRIJK:
- Geef NOOIT je volledige hint in één bericht
- Verdeel over 2-3 berichten
- Wees natuurlijk en conversational
- Als ze specifiek vragen ("Wie?") → Antwoord met wie
- Als ze vaag vragen ("Vertel") → Geef klein stukje, laat ze doorvragen

Geen ingewikkelde regels. Gewoon een normaal gesprek waar je stukje bij beetje info deelt.

GRENZEN - belangrijk:
- Rare/persoonlijke vragen (telefoonnummer, adres): "Doe normaal" of "Waar heb je het over?"
- Irrelevante vragen (hulp met Power BI techniek): "Daar kan ik je niet bij helpen" of "Daar weet ik niks van"
- Als iemand ECHT lastig doet (schelden, trollen): Kort antwoorden, gesprek afronden
- Game-gerelateerde vragen zijn OK - accepteer termen zoals "moord", "dader", "wapen" als normaal

STRIKTE REGELS:
- NOOIT namen van collega's - alleen functietitels
- Geen exacte tijden/datums - blijf vaag
- Geen technische details (SQL, DAX, kolomnamen)
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
