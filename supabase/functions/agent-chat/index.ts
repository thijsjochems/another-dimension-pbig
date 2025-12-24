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
      .select(`
        *,
        scenarios (
          id,
          verhaal,
          personen:persoon_id (naam, beschrijving),
          wapens:wapen_id (naam, beschrijving),
          locaties:locatie_id (naam, beschrijving)
        )
      `)
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

    // 4. Build AI prompt based on agent character
    const systemPrompt = buildAgentPrompt(agent, game.scenarios, hint)

    // 5. Call OpenAI API
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
        messages: [
          { role: 'system', content: systemPrompt },
          { role: 'user', content: message }
        ],
        temperature: 0.7,
        max_tokens: 300,
      }),
    })

    const aiData = await openaiResponse.json()
    const aiResponse = aiData.choices[0]?.message?.content || 'Sorry, ik kon geen antwoord geven.'

    // 6. Save chat message to database (optional, for analytics)
    await supabaseClient.from('chat_messages').insert({
      game_id,
      agent_id,
      user_message: message,
      agent_response: aiResponse,
      created_at: new Date().toISOString()
    })

    // 7. Update game state (track visited agents)
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
function buildAgentPrompt(agent: any, scenario: any, hint: any): string {
  const baseContext = `
Je bent ${agent.naam}, ${agent.rol}.
${agent.beschrijving}

SCENARIO CONTEXT:
Een Power BI Dashboard is stuk gegaan. De feiten zijn:
- Dader: ${scenario.personen.naam}
- Wapen: ${scenario.wapens.naam}
- Locatie: ${scenario.locaties.naam}
${scenario.verhaal ? `\nVerhaal: ${scenario.verhaal}` : ''}

${hint ? `\nJOUW SPECIFIEKE KENNIS:\n${hint.hint_context}` : ''}

INSTRUCTIES:
- Geef concrete, tijdspecifieke informatie
- Gebruik exacte tijden (bijv. "om 14:30")
- Noem namen van personen die je gezien hebt
- Beschrijf locaties en activiteiten
- Geef hints die helpen met eliminatie
- Blijf in character
- Antwoord in het Nederlands
- Houd antwoorden kort (max 3-4 zinnen)
`

  return baseContext
}
