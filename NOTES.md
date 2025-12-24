# Development Notes - Power BI Murder Mystery

## Datum: 24 december 2025

### Cluedo Mechaniek Analyse

**Wat maakt Cluedo Cluedo?**
- Systematisch uitsluiten van opties
- Deductie door informatie combineren
- Logisch redeneren
- Fysieke interactie (kaarten, attributen)
- Spanning tussen gokken en zeker weten

**Hoe passen we dit toe op ons spel?**

#### 1. Deductie-element toevoegen
- Agents geven **concrete** alibi's met tijd/locatie/persoon
- Bezoekers kunnen opties elimineren
- Hints moeten logische conclusies mogelijk maken

#### 2. Hint Kwaliteit is Cruciaal

**Slechte hints (vermijden):**
- "Er gebeurde iets verdachts"
- "Iemand was ergens"
- Vage omschrijvingen

**Goede hints (nastreven):**
- "Ik zag de Data Analist om 14:00 in de kantine" → sluit uit voor 14:30 Meeting Room incident
- "De Receptionist vertelde dat Excel file om 15:00 nog intact was" → wapen pas later gebruikt
- "Om 16:00 was de Lakehouse leeg, niemand daar gezien" → locatie uitsluiten

#### 3. Tijdscomponent in Scenarios

**Scenario structuur moet bevatten:**
- Tijdstip van incident (bijv. 14:30)
- Tijdstip van belangrijke events
- Agent observaties op specifieke momenten
- Alibi's die tijdslots blokkeren

**Voorbeeld scenario:**
```
Incident: 14:30 - Dashboard corrupted in Meeting Room
- 14:00: Data Analist in kantine (gezien door Schoonmaker)
- 14:15: Power BI Developer bij printer (gezien door Receptionist)
- 14:30: Business Analist alleen in Meeting Room (geen alibi)
- 14:45: Excel file missing (ontdekt door Stagiair)
```

### Locaties Dilemma

**Optie A: Data-opslag (huidige keuze)**
- Lakehouse
- Datawarehouse  
- Excel Hell
- Power BI Service

**Voor:**
- Technisch relevant voor Power BI
- Uniek concept
- Educatief element

**Tegen:**
- Minder herkenbaar voor bezoekers
- Abstract concept
- Moeilijker voor Cluedo-feel

**Optie B: Fysieke kantoorlocaties**
- Meeting Room
- Server Room
- Kantine
- Werkplek/Bureau

**Voor:**
- Direct herkenbaar
- Past beter bij Cluedo
- Makkelijker hints te bedenken
- Fysieke locaties zijn intuïtiever

**Tegen:**
- Minder technisch uniek
- Standaard Cluedo-achtig

**Aanbeveling:** Mix overwegen? Bijvoorbeeld:
- Meeting Room (fysiek)
- Server Room (fysiek)
- Power BI Service (data)
- Excel Hell (data)

### n8n Agent Chat Systeem

## ✅ CORRECTE ARCHITECTUUR (na verduidelijking):

**NFC Tags op Vaste Locaties:**
- NFC tags zitten vastgeplakt op items (achterwand, statafel, etc.)
- Tag bevat URL naar chat webinterface
- Bezoeker scant met eigen mobiel
- Chat opent op mobiel van bezoeker

**Workflow architectuur met Supabase Edge Functions:**
```
1. Bezoeker scant Agent NFC tag met mobiel
   └─> NFC tag bevat URL: https://jouwproject.supabase.co/functions/v1/agent-chat?agent=1&game=ABC123

2. Chat interface opent op mobiel
   └─> Simpele HTML pagina (gehost op Supabase Storage of GitHub Pages)
   └─> Haalt actief scenario_id op via game_id parameter
   └─> Toont agent character (Schoonmaker/Receptionist/Stagiair)

3. Bezoeker typt vraag in chat
   └─> POST request naar Supabase Edge Function: /agent-chat

4. Supabase Edge Function (Deno/TypeScript):
   - Ontvangt: game_id, agent_id, user_message
   - Haalt scenario context uit Supabase database
   - Haalt scenario_hints voor deze agent/scenario combinatie
   - Bouwt AI prompt met character + context
   - Call naar OpenAI API (of Anthropic)
   - Genereert contextual antwoord met alibi/hint
   - Slaat chat message op in database (optioneel)
   - Return antwoord naar chat interface

5. Bezoeker leest antwoord op mobiel
   └─> Kan meerdere vragen stellen
   └─> Hints helpen bij eliminatie van verdachten
   └─> Chat history blijft bewaard tijdens gesprek

6. Game state update in Supabase:
   - Track welke agents bezocht zijn (agent_visited array in games table)
   - Log alle chat messages in chat_messages table voor analytics
```

**Waarom Supabase Edge Functions perfect is:**
- ✅ **Directe database toegang** - geen extra API calls nodig
- ✅ **Serverless** - geen server onderhoud
- ✅ **CORS vooraf geconfigureerd** - werkt direct met web requests
- ✅ **AI integratie mogelijk** - OpenAI/Anthropic SDK's werken in Deno
- ✅ **Gratis tier ruim genoeg** - 500K requests/maand
- ✅ **1 platform** - database + functions + auth alles in Supabase
- ✅ **TypeScript/Deno** - modern, veilig, snel

**Voordelen van deze setup:**
- ✅ Meerdere bezoekers kunnen tegelijk verschillende agents bevragen
- ✅ Chat is privé (niet op groot scherm voor iedereen zichtbaar)
- ✅ Bezoekers gebruiken eigen device (vertrouwd)
- ✅ Tags blijven op vaste locaties (simpel)
- ✅ Schaalbaarder (niet alles via 1 laptop)
- ✅ Geen extra diensten nodig (alles in Supabase)

**AI Prompt Engineering per Agent:**

**Schoonmaker (observeert maar begrijpt niet alles):**
```
Je bent een schoonmaker op kantoor. Je zag vandaag rond {tijd} 
iemand {actie} bij {locatie}. Geef een gedetailleerde observatie 
met exacte tijd. Je begrijpt de technische aspecten niet, maar 
je onthoudt wat je zag.

Scenario context: {scenario_details}
```

**Receptionist (weet wie waar ging):**
```
Je bent de receptionist. Je houdt bij wie wanneer door de deur kwam 
en waar naartoe ging. Geef concrete tijden en locaties. Je hebt 
bezoekers registratie en weet wie wanneer op locatie was.

Scenario context: {scenario_details}
```

**Stagiair (technisch bewust maar onzeker):**
```
Je bent IT stagiair. Je werkte aan {technical_task} en merkte 
rond {tijd} dat {observation}. Geef technische details over 
systemen en bestanden die je zag. Je bent onzeker maar precies.

Scenario context: {scenario_details}
```

### Gameplay Beslissingen

**Automatische validatie behouden:**
- Bij 3e scan wordt direct gevalideerd
- Geen aparte "beschuldig" knop (Nice-to-have)
- Direct +15 sec penalty bij fout
- Alle 3 boxes resetten bij fout

**Rationale:**
- Simpeler UX
- Minder handelingen voor bezoeker
- Sneller spel
- Duidelijkere flow

### Game Start: Situatie Uitleg (Cluedo-stijl)

**Bij START van het spel:**

Net als bij Cluedo moet de situatie uitgelegd worden voordat spelers beginnen.

**Template:**
```
### Open Vragen

- [ ] Fysieke vs data-locaties besluit
- [ ] Hoeveel tijd moet tussen events zitten? (15 min? 30 min?)
- [ ] Moeten alle agents altijd beschikbaar zijn, of scenario-specifiek?
- [ ] Limiet op aantal hints per spel?
- [ ] Tonen we welke hints al gescand zijn?
- [ ] Chat interface: n8n vs Supabase Edge Functions?
- [ ] NFC URL structuur: hoe koppelen we session aan scenario?
- [ ] Moeten chat messages opgeslagen worden in database?
- [ ] Mogen bezoekers onbeperkt vragen stellen aan agents?

---

## 🎯 PRIORITEIT: Eerst Technisch Werkend Krijgen

**Focus voor nu:**
1. ✅ Basis game flow werkt (WIE/WAARMEE/WAAR) - DONE
2. ⬜ Chat interface prototype maken
3. ⬜ AI agent responses werkend krijgen
4. ⬜ Session koppeling tussen laptop game en mobiele chat
5. ⬜ Scenario START melding implementeren

**Later verfijnen:**
- Scenario content (tijdlijnen, details)
- Locaties hermixen
- Meer personen/wapens
- Hint kwaliteit optimaliserenig stuk.

Ik zag dat [specifiek detail dat richting geeft, bijv. "de 
Financial Controller rond lunchtijd iets aan het uploaden was"].

Ook hoorde ik dat [tweede hint/detail].

We moeten SNEL weten: WIE heeft WAT gedaan en WAAR is het misgegaan?"

Praat met getuigen (scan de NFC tags) en los de moord op!
```

**Waarom dit belangrijk is:**
- ✅ Geeft context zoals Cluedo dat doet
- ✅ Eerste hints geven richting (niet volledig blind)
- ✅ Gevoel van urgentie
- ✅ Duidelijk "WHO did WHAT WHERE" mechaniek
- ✅ Moordenaarskaart concept uit Cluedo (mysterie)

**Implementatie:**
- Tekst tonen bij game start
- Per scenario unieke melding met 2-3 concrete details
- Details elimineren al 1-2 opties (niet alles)
- Melder kan verschillende rollen hebben (IT Manager, CEO, Teamlead, etc.)

### Volgende Stappen

1. **Chat interface prototype** - Supabase Edge Function vs n8n
2. **NFC URL structuur** - hoe koppelen we session aan scenario?
3. **Scenario's uitbreiden met tijdslijn** + START melding per scenario
4. **AI prompts testen** met verschillende scenarios
5. **Hints kwaliteit valideren** - kunnen bezoekers echt elimineren?
6. **Locaties finaliseren** - brainstorm fysiek vs digitaal

### Open Vragen

- [ ] Fysieke vs data-locaties besluit
- [ ] Hoeveel tijd moet tussen events zitten? (15 min? 30 min?)
- [ ] Moeten alle agents altijd beschikbaar zijn, of scenario-specifiek?
- [ ] Limiet op aantal hints per spel?
- [ ] Tonen we welke hints al gescand zijn?

---

## 🎯 Besluit: Auto-Detect Game met Status Check (24 dec 2024, 21:00)

### Probleem dat we oplossen
- NFC tags zitten vast in ruimte (niet bij laptop)
- Bezoeker moet geen code hoeven in te typen
- Oude browser sessies mogen nieuw spel niet verstoren
- 2x2m stand = altijd maar 1 actief spel tegelijk

### Gekozen Oplossing: Auto-Detect + Status Column

**Database aanpassing:**
```sql
ALTER TABLE games 
ADD COLUMN status TEXT DEFAULT 'active',
ADD COLUMN visited_agents INTEGER[] DEFAULT '{}';

-- Values: 'active', 'completed', 'abandoned'
```

**Workflow:**
1. **Game start** → status = 'active'
2. **Bezoeker scant NFC** → Edge Function haalt laatste actieve game op
3. **Game eindigt** → standhouder update status = 'completed'
4. **Oude browser refresh** → geen actieve game → error bericht

**Voordelen:**
✅ Zero friction voor bezoeker (geen code invullen)
✅ Standhouder heeft controle (expliciete status update)
✅ Oude sessies worden automatisch rejected
✅ Fail-safe (time-based check als backup: 60 min)
✅ Simpel te implementeren

**Edge Function logica:**
```javascript
// 1. Auto-detect laatste actieve game
const game = SELECT * FROM games 
             WHERE status='active' 
             ORDER BY created_at DESC LIMIT 1

// 2. Valideer game niet expired
if (!game || gameAge > 60min) {
  return error: "Geen actief spel"
}

// 3. Process chat message
```

**Chat Interface gedrag:**
- Bij laden: zoek actieve game
- Bij error: toon "Vraag standhouder om nieuw spel te starten"
- Bij refresh: opnieuw zoeken naar actieve game

### Te Implementeren
- [ ] SQL: ADD COLUMN status + visited_agents
- [ ] Edge Function: auto-detect + status check
- [ ] Chat Interface: error handling + auto-reload
- [ ] Flask app: status update bij game end

### Alternatieve oplossingen overwogen
❌ **Session tokens** - te complex
❌ **Manual code input** - bezoeker kan laptop niet zien bij NFC tags  
❌ **Pure time-based** - geen controle bij crashes
