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

**Workflow architectuur:**
```
1. Bezoeker scant Agent NFC tag
2. Flask detecteert agent_id + haalt actief scenario_id op
3. Webhook call naar n8n workflow
4. n8n workflow:
   - Ontvangt: scenario_id, agent_id, game_state
   - Haalt scenario data uit Supabase
   - Kiest juiste AI prompt template voor agent
   - Genereert contextual hint/alibi
   - Return JSON met hint text
5. Flask toont hint op scherm
6. Game state update: agent_visited
```

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

### Volgende Stappen

1. **Locaties finaliseren** - brainstorm met team
2. **Scenario's uitbreiden met tijdslijn** per scenario
3. **n8n workflow bouwen** voor agent chat
4. **AI prompts testen** met verschillende scenarios
5. **Hints kwaliteit valideren** - kunnen bezoekers echt elimineren?

### Open Vragen

- [ ] Fysieke vs data-locaties besluit
- [ ] Hoeveel tijd moet tussen events zitten? (15 min? 30 min?)
- [ ] Moeten alle agents altijd beschikbaar zijn, of scenario-specifiek?
- [ ] Limiet op aantal hints per spel?
- [ ] Tonen we welke hints al gescand zijn?
