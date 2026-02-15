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

    // Use detected game ID for all subsequent queries
    const actualGameId = game.id

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

    // 6. Get conversation history for this agent in this game (last 20 messages)
    const { data: chatHistory } = await supabaseClient
      .from('chat_messages')
      .select('message, sender, message_number')
      .eq('game_id', actualGameId)
      .eq('agent_id', agent_id)
      .order('message_number', { ascending: true })
      .limit(20)

    // 7. Build messages array with conversation history
    const messages: any[] = [
      { role: 'system', content: systemPrompt }
    ]

    // Add conversation history
    if (chatHistory && chatHistory.length > 0) {
      chatHistory.forEach(msg => {
        const role = msg.sender === 'player' ? 'user' : 'assistant'
        messages.push({ role, content: msg.message })
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

    // 9. Get current message number
    const { data: lastMsg } = await supabaseClient
      .from('chat_messages')
      .select('message_number')
      .eq('game_id', actualGameId)
      .eq('agent_id', agent_id)
      .order('message_number', { ascending: false })
      .limit(1)
      .maybeSingle()

    const nextMessageNumber = (lastMsg?.message_number || 0) + 1

    // 10. Save both messages to database (player + agent)
    await supabaseClient.from('chat_messages').insert([
      {
        game_id: actualGameId,
        agent_id,
        message,
        sender: 'player',
        message_number: nextMessageNumber,
        created_at: new Date().toISOString()
      },
      {
        game_id: actualGameId,
        agent_id,
        message: aiResponse,
        sender: 'agent',
        message_number: nextMessageNumber + 1,
        created_at: new Date().toISOString()
      }
    ])

    // 11. Update game state (track visited agents)
    const visitedAgents = game.visited_agents || []
    if (!visitedAgents.includes(agent_id)) {
      await supabaseClient
        .from('games')
        .update({ visited_agents: [...visitedAgents, agent_id] })
        .eq('id', actualGameId)
    }

    // 12. Return response
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
  const voornaamwoorden = persoon?.geslacht === 'vrouw' ? 'zij/haar/ze' : 'hij/hem'
  
  const baseContext = `Je bent ${agent.naam}.

${agent.achtergrond || 'Je werkt hier op kantoor.'}

${agent.tone_of_voice || 'Praat gewoon normaal als een collega.'}

GEHEUGEN: Dit is een doorlopend gesprek. Als de speler iets herhaalt of doorvraagt over eerdere uitwisselingen, bouw dan voort op wat je al verteld hebt. Reageer natuurlijk op basis van de context van het gesprek tot nu toe.

GAME CONTEXT: Power BI detective game. Termen als "moord", "dader", "wapen" zijn metaforen voor tech problemen. Dit is normaal vocabulaire - behandel het gewoon.

${persoon?.geslacht ? `BELANGRIJK: De persoon in dit scenario is ${persoon.geslacht}. Gebruik correcte voornaamwoorden (${voornaamwoorden}) als je over deze persoon praat.` : ''}

WAT JIJ HEBT GEZIEN/GEHOORD:
${hint?.hint_context || 'Je hebt niets bijzonders gezien rond dit incident.'}

HOE JE PRAAT:
- Nederlands als collega (Engelse tech termen zijn OK: "refresh", "dashboard", "query")
- Deel je observatie gewoon als het relevant is - geen meta-commentary over "niet te veel verklappen"
- Functietitels ("Database Beheerder", "Power BI Developer") zijn GEEN namen - gewoon delen als het ter zake doet
- Bouw voort op het gesprek, verwijs naar eerdere uitwisselingen
- Blijf vaag over exacte tijden ("begin februari", "rond die tijd") tenzij specifiek in je hint

GRENZEN:
- Persoonlijke vragen (telefoon, adres): "Doe normaal" of "Waar heb je het over?"
- Irrelevante vragen (hulp met Power BI techniek): "Daar kan ik je niet bij helpen"
- Game-termen ("moord", "dader") zijn OK - accepteer als normaal

Praat als mens in echt gesprek, niet als NPC met quests.`

  return baseContext
}

