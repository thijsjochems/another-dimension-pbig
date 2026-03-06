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

    const { data: personenLijst } = await supabaseClient
      .from('personen')
      .select('naam')

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
        temperature: 0.2,
        max_tokens: 300,
      }),
    })

    const aiData = await openaiResponse.json()
    const aiRawResponse = aiData.choices[0]?.message?.content || ''
    const aiResponse = sanitizeAgentResponse({
      rawResponse: aiRawResponse,
      phaseHint,
      userMessage: message,
      agentName: (agent?.naam || '').toString(),
      agentRole: (agent?.rol || '').toString(),
      scenarioPersonName: (persoon?.naam || '').toString(),
      allPersonNames: (personenLijst || []).map((row: any) => (row?.naam || '').toString()).filter((name: string) => name.length > 0),
    })

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
  const isSchoonmaker = Number(agent?.id) === 1 || (agent?.naam || '').toLowerCase().includes('schoonmaker')
  const isReceptionist = Number(agent?.id) === 2 || (agent?.naam || '').toLowerCase().includes('receptionist')
  const isStagiair = Number(agent?.id) === 3 || (agent?.naam || '').toLowerCase().includes('stagiair')

  let rolSpecifiekePraatregels = ''

  if (isSchoonmaker) {
    rolSpecifiekePraatregels += `
- Jij bent de Schoonmaker: hou het bewust minder technisch en wat vager
- Gebruik liever gewone woorden dan vaktermen
- Voorbeeld: zeg "OneRide" of "dat wolkje waar bestanden staan" in plaats van "OneDrive"
- Voorbeeld: zeg "dat filterding" of "dat zijpaneel" in plaats van exacte technische schermnamen
- Laat technische details over aan anderen; jij deelt vooral wat je hebt gezien`
  }

  if (isReceptionist) {
    rolSpecifiekePraatregels += `
- Jij bent de Receptionist: wees warm, menselijk en niet-beschuldigend
- Zeg NOOIT direct dat iemand de dader is
- Benoem wél de functietitel van de betrokken persoon als dat helpt voor duidelijkheid (bijv. "Power BI Developer", "Financial Controller")
- Spreek in twijfelvorm: "Zou het dan toch ... zijn?", "Dat kan ik me bijna niet voorstellen"
- Koppel observaties aan gevoel en context, niet aan harde conclusies
- Beschuldig of adresseer de speler NOOIT als veroorzaker (dus niet: "jij was bezig met...")
- Formuleer incident-acties altijd in derde persoon met functietitel/naam van de betrokken persoon`
  }

  if (isStagiair) {
    rolSpecifiekePraatregels += `
- Jij bent de Stagiair: je bent slim maar onzeker, soms een beetje nerveus
- Vermijd te stellige eindconclusies; gebruik twijfel: "dat moet het toch zijn?"
- Houd het menselijk en voorzichtig, bijvoorbeeld: "zeg maar niet dat ik dit zei"`
  }
  
  const baseContext = `Je bent ${agent.naam}.

${agent.achtergrond || 'Je werkt hier op kantoor.'}

${agent.tone_of_voice || 'Praat gewoon normaal als een collega.'}

GEHEUGEN: Dit is een doorlopend gesprek. Als de speler iets herhaalt of doorvraagt over eerdere uitwisselingen, bouw dan voort op wat je al verteld hebt. Reageer natuurlijk op basis van de context van het gesprek tot nu toe.

GAME CONTEXT: Power BI detective game. Termen als "moord", "dader", "wapen" zijn metaforen voor tech problemen. Dit is normaal vocabulaire - behandel het gewoon.

BETROKKEN PERSOON IN DIT SCENARIO:
${persoon?.naam ? `- ${persoon.naam}` : '- onbekend'}

Gebruik deze functietitel/naam gerust om de speler te helpen begrijpen over wie je het hebt, maar zonder harde schuldclaim.

${persoon?.geslacht ? `BELANGRIJK: De persoon in dit scenario is ${persoon.geslacht}. Gebruik correcte voornaamwoorden (${voornaamwoorden}) als je over deze persoon praat.` : ''}

WAT JIJ HEBT GEZIEN/GEHOORD (fase ${phase}):
${phaseHint}

HOE JE PRAAT:
- Nederlands als collega (Engelse tech termen zijn OK: "refresh", "dashboard", "query")
- Antwoord kort: maximaal 2-3 zinnen
- Deel per antwoord maar 1 kernfeit en hoogstens 1 contextzin
- Bij brede vraag: stel eerst een korte keuzevraag (bijv. "Wil je timing, persoon of techniek?")
- Als de speler al een keuze geeft ("timing", "persoon", "techniek"), geef direct antwoord en stel GEEN nieuwe keuzevraag terug
- Vraag "wat heb je gezien" of "wat weet je" is een normale vraag: antwoord direct met 1 observatie uit de fasehint
- Gebruik de weigeringstekst NOOIT bij zulke normale informatievragen
- Geen lijstjes met meerdere clues in één antwoord
- Geef nooit meerdere nieuwe feiten in hetzelfde antwoord
- Doe geen aannames of theorieën; alleen observaties uit je hint
- Gebruik uitsluitend informatie die expliciet in "WAT JIJ HEBT GEZIEN/GEHOORD" staat; verzin NOOIT extra details
- Noem geen extra processtappen, oorzaken of objecten die niet in de fasehint staan
- Als gevraagd detail (timing/persoon/techniek) niet in de fasehint staat: zeg dat expliciet en geef 1 wél-bekend detail uit de fasehint
- Bij "vertel meer" of doorvragen: geef een korte herformulering of een iets concreter detail UIT DEZELFDE fasehint, maar voeg geen nieuwe feiten toe
- Als je in de huidige fase niets extra's kunt toevoegen: zeg dat eerlijk en herhaal 1 bestaand detail uit de fasehint
- Als je iets niet weet: zeg dat expliciet
- Functietitels ("Database Beheerder", "Power BI Developer") zijn GEEN namen - gewoon delen als het ter zake doet
- Verzin NOOIT nieuwe functietitels of personen; gebruik alleen de functietitel/persoon die in dit scenario is gegeven
- Bouw voort op het gesprek, verwijs naar eerdere uitwisselingen
- Blijf vaag over exacte tijden ("begin februari", "rond die tijd") tenzij specifiek in je hint
- De speler is de onderzoeker: spreek de speler NOOIT aan als dader/veroorzaker
- Gebruik voor incident-acties altijd derde persoon ("de betrokken persoon", functietitel of naam), niet "jij/je" richting speler
${rolSpecifiekePraatregels}

PROGRESSIEREGELS:
- Fase 1: alleen subtiele observatie
- Fase 2: observatie + iets concreter detail
- Fase 3: bijna-oplossing, nog steeds zonder letterlijk eindantwoord te geven
- Bij normale informatievragen of doorvragen (bijv. "wat heb je gezien", "vertel meer", "timing/persoon/techniek") mag je 1 fase opschuiven
- Als speler om "alles" vraagt: blijf in huidige fase en geef geen extra kernfeiten
- Gebruik de vaste weigeringstekst alleen bij directe oplossingsvraag; niet bij normale vragen als "wat weet je" of "vertel meer"
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

type MessageIntent = 'smalltalk' | 'info_request' | 'direct_solution_request'

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
  const text = normalizeInformalText(message)

  if (
    text.includes('wat heb je gezien') ||
    text.includes('wat zag je') ||
    text.includes('wat weet je') ||
    text.includes('vertel me wat je hebt gezien')
  ) {
    return false
  }

  const patterns = [
    /\bwie heeft het gedaan\b/,
    /\bwie is (de )?dader\b/,
    /\bzeg( gewoon)? (de )?dader\b/,
    /\bwat is (de )?oplossing\b/,
    /\bgeef (de )?oplossing\b/,
    /\bwat is het antwoord\b/,
    /\bgeef het antwoord\b/,
    /\bwie is schuldig\b/
  ]

  return patterns.some((pattern) => pattern.test(text))
}

function isTargetedFollowUp(message: string): boolean {
  const text = normalizeInformalText(message)
  if (isBroadInfoRequest(text) || isDirectSolutionRequest(text)) return false

  const followUpSignals = [
    'wat heb je gezien',
    'wat zag je',
    'wat weet je',
    'vertel',
    'timing',
    'persoon',
    'personen',
    'techniek',
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

  if (followUpSignals.some(term => text.includes(term))) return true

  // Vang ook korte, normale informatievragen op zodat hints sneller progressen.
  return text.endsWith('?')
}

function getNextPhase(currentPhase: number, message: string): number {
  const phase = normalizePhase(currentPhase)
  const intent = classifyMessageIntent(message)
  if (intent !== 'info_request') return phase
  if (isBroadInfoRequest(message)) return phase
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

function sanitizeAgentResponse(params: {
  rawResponse: string,
  phaseHint: string,
  userMessage: string,
  agentName: string,
  agentRole: string,
  scenarioPersonName: string,
  allPersonNames: string[],
}): string {
  const { rawResponse, phaseHint, userMessage, agentName, agentRole, scenarioPersonName, allPersonNames } = params

  const intent = classifyMessageIntent(userMessage)

  const fallback = buildSafeFallbackResponse(phaseHint, agentName, agentRole, intent)
  if (!rawResponse || !rawResponse.trim()) return fallback

  let response = rawResponse.trim()

  if (hasDisallowedPersonMention(response, scenarioPersonName, allPersonNames)) {
    return fallback
  }

  response = stripRepeatedChoiceQuestion(response, userMessage)

  const shouldEnforceHintGrounding = intent === 'info_request' && requiresStrictHintGrounding(userMessage)
  if (shouldEnforceHintGrounding && !hasSufficientHintOverlap(response, phaseHint)) {
    return fallback
  }

  return response
}

function buildSafeFallbackResponse(phaseHint: string, agentName: string, agentRole: string, intent: MessageIntent): string {
  if (intent === 'smalltalk') {
    return buildSmallTalkResponse(agentName, agentRole)
  }

  const safeDetail = extractPrimaryDetail(phaseHint)
  if (intent === 'direct_solution_request') {
    return `${pickVariant(getSolutionRefusalVariants(agentName, agentRole))} ${safeDetail}`
  }

  const personaPrefix = getPersonaFallbackPrefix(agentName, agentRole)
  return `${personaPrefix} ${safeDetail}`
}

function classifyMessageIntent(message: string): MessageIntent {
  if (isSmallTalkMessage(message)) return 'smalltalk'
  if (isDirectSolutionRequest(message)) return 'direct_solution_request'
  return 'info_request'
}

function requiresStrictHintGrounding(userMessage: string): boolean {
  const text = (userMessage || '').toLowerCase().trim()
  if (!text) return false

  if (isSmallTalkMessage(text)) return false

  const factSeekingSignals = [
    'wie', 'waar', 'wanneer', 'hoe', 'waarom', 'wat',
    'hint', 'clue', 'timing', 'persoon', 'personen', 'techniek',
    'vertel', 'meer', 'specifiek', 'detail', 'details', 'uitleg',
    'oplossing', 'dader'
  ]

  return factSeekingSignals.some((term) => text.includes(term))
}

function isSmallTalkMessage(message: string): boolean {
  const text = normalizeInformalText(message)
  if (!text) return true

  const smallTalkSignals = [
    'yo', 'hey', 'hoi', 'hallo', 'sup', 'alles goed', 'gaat ie',
    'hoe gaat', 'goedemorgen', 'goedenavond', 'goedemiddag'
  ]

  return smallTalkSignals.some((term) => text.includes(term))
}

function normalizeInformalText(input: string): string {
  return (input || '')
    .toLowerCase()
    .replace(/[^\p{L}\p{N}\s]/gu, ' ')
    .replace(/(.)\1{2,}/g, '$1$1')
    .replace(/\s+/g, ' ')
    .trim()
}

function buildSmallTalkResponse(agentName: string, agentRole: string): string {
  const raw = `${agentName || ''} ${agentRole || ''}`.toLowerCase()

  if (raw.includes('schoonmaker')) {
    return 'Ha, hoi! Ik loop hier gewoon m\'n rondje. Wil je dat ik vertel wat ik heb opgemerkt?'
  }

  if (raw.includes('receptionist')) {
    return 'Hoi! Fijn dat je er bent. Zullen we inzoomen op timing, persoon of techniek?'
  }

  if (raw.includes('stagiair')) {
    return 'Yo, hey! Ik heb wel iets gezien trouwens. Wil je timing, persoon of techniek?'
  }

  return 'Hoi! Zeg maar waar je op wilt inzoomen: timing, persoon of techniek.'
}

function getSolutionRefusalVariants(agentName: string, agentRole: string): string[] {
  const raw = `${agentName || ''} ${agentRole || ''}`.toLowerCase()

  if (raw.includes('schoonmaker')) {
    return [
      'Dat weet ik echt niet zeker, maar ik kan wel delen wat ik zag:',
      'Nee joh, dat kan ik niet zeggen. Wat ik wel zag was:',
      'Ik ga daar niet hard op gokken, maar ik heb dit wel gezien:'
    ]
  }

  if (raw.includes('receptionist')) {
    return [
      'Dat kan ik niet met zekerheid zeggen. Wat ik wél heb gezien is:',
      'Zo direct wil ik niemand aanwijzen. Wel heb ik dit gezien:',
      'Daar kan ik geen harde uitspraak over doen. Ik zag wel het volgende:'
    ]
  }

  if (raw.includes('stagiair')) {
    return [
      'Poeh, dat durf ik niet te zeggen. Ik zag wel dit:',
      'Dat weet ik niet honderd procent, maar ik heb dit gezien:',
      'Geen idee of dat zo is, maar dit viel me op:'
    ]
  }

  return [
    'Dat kan ik niet direct zeggen. Wat ik wel heb gezien is:',
    'Daar kan ik geen hard antwoord op geven. Ik zag wel dit:',
    'Ik kan de oplossing niet geven, maar ik kan wel dit delen:'
  ]
}

function pickVariant(options: string[]): string {
  if (!options || options.length === 0) return ''
  const idx = Math.floor(Math.random() * options.length)
  return options[idx]
}

function getPersonaFallbackPrefix(agentName: string, agentRole: string): string {
  const raw = `${agentName || ''} ${agentRole || ''}`.toLowerCase()

  if (raw.includes('schoonmaker')) {
    return 'Wat ik heb gezien is dit, denk ik:'
  }

  if (raw.includes('receptionist')) {
    return 'Voor zover ik weet:'
  }

  if (raw.includes('stagiair')) {
    return 'Eerlijk? Dit is wat ik zag:'
  }

  return 'Wat ik heb gezien:'
}

function extractPrimaryDetail(text: string): string {
  const raw = (text || '').trim()
  if (!raw) return 'ik heb hier op dit moment geen extra details over.'

  const sentence = raw
    .split(/(?<=[.!?])\s+/)
    .map((part: string) => part.trim())
    .find((part: string) => part.length > 0)

  return sentence || raw
}

function stripRepeatedChoiceQuestion(response: string, userMessage: string): string {
  const user = userMessage.toLowerCase()
  const isChoiceInput = ['timing', 'persoon', 'personen', 'techniek'].some((term) => user.includes(term))
  const isTellMore = ['vertel meer', 'meer', 'wat weet', 'wat zag', 'wat dan'].some((term) => user.includes(term))

  if (!isChoiceInput && !isTellMore) return response

  return response
    .replace(/\s*wil je meer weten over[^?.!]*\?/gi, '')
    .replace(/\s*wil je iets weten over[^?.!]*\?/gi, '')
    .trim()
}

function hasDisallowedPersonMention(response: string, scenarioPersonName: string, allPersonNames: string[]): boolean {
  const text = response.toLowerCase()
  const allowed = (scenarioPersonName || '').toLowerCase().trim()

  return allPersonNames.some((name) => {
    const n = name.toLowerCase().trim()
    if (!n) return false
    if (allowed && n === allowed) return false
    return text.includes(n)
  })
}

function hasSufficientHintOverlap(response: string, phaseHint: string): boolean {
  const hintTokens = tokenizeForComparison(phaseHint)
  if (hintTokens.size === 0) return true

  const responseTokens = tokenizeForComparison(response)
  if (responseTokens.size === 0) return false

  let overlap = 0
  responseTokens.forEach((token) => {
    if (hintTokens.has(token)) overlap += 1
  })

  if (responseTokens.size <= 8) {
    return overlap >= 1
  }

  const ratio = overlap / Math.max(1, responseTokens.size)
  return ratio >= 0.08 || overlap >= 2
}

function tokenizeForComparison(text: string): Set<string> {
  const stopwords = new Set([
    'de', 'het', 'een', 'en', 'of', 'dat', 'dit', 'dan', 'wel', 'niet', 'voor', 'met', 'van',
    'als', 'maar', 'zijn', 'was', 'werd', 'door', 'bij', 'nog', 'ook', 'die', 'ik', 'je', 'jij',
    'hij', 'zij', 'ze', 'we', 'op', 'in', 'te', 'om', 'er', 'aan', 'tot', 'naar', 'uit', 'kan',
  ])

  return new Set(
    (text || '')
      .toLowerCase()
      .replace(/[^a-z0-9_\-\s]/gi, ' ')
      .split(/\s+/)
      .map((token) => token.trim())
      .filter((token) => token.length >= 4 && !stopwords.has(token))
  )
}

