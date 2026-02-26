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

    // 3b. Resolve clue progression state (fallback-safe if table doesn't exist yet)
    let clueStatePhase = 1
    const { data: clueState, error: clueStateError } = await supabaseClient
      .from('agent_clue_state')
      .select('game_id, agent_id, phase, updated_at')
      .eq('game_id', actualGameId)
      .eq('agent_id', agent_id)
      .maybeSingle()

    if (!clueStateError && clueState) {
      clueStatePhase = normalizePhase(clueState.phase)
    }

    const nextPhase = getNextPhase(clueStatePhase, message)
    const phaseHint = selectHintForPhase(hint, nextPhase)

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

    // 5. Build AI prompt based on agent character + allowed hint phase
    const systemPrompt = buildAgentPrompt(agent, game.scenarios, phaseHint, nextPhase, persoon, wapen, locatie)

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
        temperature: 0.4,
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

    // 10b. Persist clue progression state (fallback-safe if table doesn't exist yet)
    await supabaseClient
      .from('agent_clue_state')
      .upsert({
        game_id: actualGameId,
        agent_id,
        phase: nextPhase,
        updated_at: new Date().toISOString(),
      }, {
        onConflict: 'game_id,agent_id'
      })

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

  } catch (error: any) {
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
function buildAgentPrompt(agent: any, scenario: any, phaseHint: string, phase: number, persoon: any, wapen: any, locatie: any): string {
  const voornaamwoorden = persoon?.geslacht === 'vrouw' ? 'zij/haar/ze' : 'hij/hem'
  
  const baseContext = `Je bent ${agent.naam}.

${agent.achtergrond || 'Je werkt hier op kantoor.'}

${agent.tone_of_voice || 'Praat gewoon normaal als een collega.'}

GEHEUGEN: Dit is een doorlopend gesprek. Als de speler iets herhaalt of doorvraagt over eerdere uitwisselingen, bouw dan voort op wat je al verteld hebt. Reageer natuurlijk op basis van de context van het gesprek tot nu toe.

GAME CONTEXT: Power BI detective game. Termen als "moord", "dader", "wapen" zijn metaforen voor tech problemen. Dit is normaal vocabulaire - behandel het gewoon.

${persoon?.geslacht ? `BELANGRIJK: De persoon in dit scenario is ${persoon.geslacht}. Gebruik correcte voornaamwoorden (${voornaamwoorden}) als je over deze persoon praat.` : ''}

WAT JIJ HEBT GEZIEN/GEHOORD (fase ${phase}):
${phaseHint}

HOE JE PRAAT:
- Nederlands als collega (Engelse tech termen zijn OK: "refresh", "dashboard", "query")
- Antwoord kort: maximaal 2-3 zinnen
- Deel per antwoord maar 1 kernfeit en hoogstens 1 contextzin
- Bij brede vraag: stel eerst een korte keuzevraag (bijv. "Wil je timing, persoon of techniek?")
- Geen lijstjes met meerdere clues in één antwoord
- Geef nooit meerdere nieuwe feiten in hetzelfde antwoord
- Doe geen aannames of theorieën; alleen observaties uit je hint
- Als je iets niet weet: zeg dat expliciet
- Functietitels ("Database Beheerder", "Power BI Developer") zijn GEEN namen - gewoon delen als het ter zake doet
- Bouw voort op het gesprek, verwijs naar eerdere uitwisselingen
- Blijf vaag over exacte tijden ("begin februari", "rond die tijd") tenzij specifiek in je hint

PROGRESSIEREGELS:
- Fase 1: alleen subtiele observatie
- Fase 2: observatie + iets concreter detail
- Fase 3: bijna-oplossing, nog steeds zonder letterlijk eindantwoord te geven
- Als speler om "alles" vraagt: blijf in huidige fase en geef geen extra kernfeiten
- Als speler vraagt "wie heeft het gedaan", "wat is de oplossing" of "zeg gewoon de dader":
  antwoord met: "Dat kan ik niet direct zeggen. Ik kan wel delen wat ik zelf heb gezien."
  en geef daarna maximaal 1 klein observatie-detail binnen de huidige fase

GRENZEN:
- Persoonlijke vragen (telefoon, adres): "Doe normaal" of "Waar heb je het over?"
- Irrelevante vragen (hulp met Power BI techniek): "Daar kan ik je niet bij helpen"
- Game-termen ("moord", "dader") zijn OK - accepteer als normaal

Praat als mens in echt gesprek, niet als NPC met quests.`

  return baseContext
}

function normalizePhase(rawPhase: number | null | undefined): number {
  if (!rawPhase || Number.isNaN(rawPhase)) return 1
  if (rawPhase < 1) return 1
  if (rawPhase > 3) return 3
  return rawPhase
}

function isBroadInfoRequest(message: string): boolean {
  const text = message.toLowerCase()
  return [
    'alles',
    'in 1 keer',
    'volledige info',
    'volledige verhaal',
    'hele verhaal',
    'geef alles',
    'vertel alles'
  ].some(term => text.includes(term))
}

function isDirectSolutionRequest(message: string): boolean {
  const text = message.toLowerCase()
  return [
    'wie heeft het gedaan',
    'wie is de dader',
    'zeg de dader',
    'wat is de oplossing',
    'geef de oplossing',
    'wat is het antwoord',
    'wie is schuldig'
  ].some(term => text.includes(term))
}

function isTargetedFollowUp(message: string): boolean {
  const text = message.toLowerCase()
  if (isBroadInfoRequest(text) || isDirectSolutionRequest(text)) return false

  const followUpSignals = [
    'meer',
    'specifiek',
    'precies',
    'wanneer',
    'waar',
    'wie',
    'welke',
    'hoe',
    'waarom',
    'detail',
    'details',
    'bedoel',
    'uitleg',
    'concreet'
  ]

  return followUpSignals.some(term => text.includes(term))
}

function getNextPhase(currentPhase: number, message: string): number {
  const phase = normalizePhase(currentPhase)
  if (isDirectSolutionRequest(message)) return phase
  if (!isTargetedFollowUp(message)) return phase
  return Math.min(3, phase + 1)
}

function selectHintForPhase(hint: any, phase: number): string {
  const normalizedPhase = normalizePhase(phase)

  const explicitPhaseHint =
    normalizedPhase === 1 ? hint?.hint_phase_1 :
    normalizedPhase === 2 ? hint?.hint_phase_2 :
    hint?.hint_phase_3

  if (explicitPhaseHint && typeof explicitPhaseHint === 'string' && explicitPhaseHint.trim().length > 0) {
    return explicitPhaseHint.trim()
  }

  const raw = (hint?.hint_context || '').trim()
  if (!raw) return 'Je hebt niets bijzonders gezien rond dit incident.'

  const sentences = raw
    .split(/(?<=[.!?])\s+/)
    .map((part: string) => part.trim())
    .filter((part: string) => part.length > 0)

  if (sentences.length === 0) return raw
  if (normalizedPhase === 1) return sentences[0]
  if (normalizedPhase === 2) return sentences.slice(0, Math.min(2, sentences.length)).join(' ')
  return raw
}

