# TODO Lijst - Interactieve Beurs Stand

## Status Legend
- ⬜ Nog niet gestart
- 🔄 In progress
- ✅ Afgerond

---

## 🔥🔥🔥 KRITIEKE PRIORITEIT: Scenario Herziening

### 0.1 Scenario Kwaliteitscontrole & Herschrijven ✅ **AFGEROND**
**PROBLEEM**: Huidige scenarios zijn niet logisch genoeg. Combinaties kloppen niet altijd qua realisme.

**📋 VOLLEDIGE CRITERIA**: Zie **[SCENARIO_CRITERIA.md](SCENARIO_CRITERIA.md)** voor alle kwaliteitseisen, testcriteria, anti-patronen en templates.

**ACTIES:**
- [x] **Audit bestaande scenarios uitgevoerd** - Zie **[SCENARIO_AUDIT_REPORT.md](SCENARIO_AUDIT_REPORT.md)**
  - 21 scenarios gescored op 5 criteria (Realisme, Logica, Techniek, Speelbaarheid, Storytelling)
  - 4 scenarios zijn goed (≥4.0 sterren), 17 moeten herschreven worden
- [x] **🔥 PRIORITEIT: Fixes doorvoeren uit SCENARIO_AUDIT_REPORT.md**
  - Doorloop rapport en implementeer alle aanbevolen wijzigingen
  - Focus op Quick Wins (8 scenarios op 3.6-3.8): alleen storytelling toevoegen
  - Major Rewrites (2 scenarios): persoon/wapen logica fixen
  - Voeg menselijk gedrag toe: vergat, haast, miscommunicatie, deadline
- [x] **🔥 PRIORITEIT: Scenario Storytelling voor Beursbezoeker**
  - **Situatiebeschrijving toevoegen per scenario**: WAT is de fout/error?
  - Bezoeker moet begrijpen: "Dit dashboard is stuk. Welke error zien we?"
  - Voorbeelden:
    - "Alle verkoopcijfers zijn verdubbeld - dashboard toont €2M i.p.v. €1M"
    - "Error: Kan bestand niet vinden - refresh faalt"
    - "Data lijkt te kloppen maar is van vorige week - niet gerefreshed"
    - "Rapport toont alleen Q2 data, rest ontbreekt zonder melding"
  - Voeg toe aan scenario beschrijving in database: `situatie_beschrijving` kolom
  - Dit helpt agents + beursbezoeker te begrijpen WAT er mis is
- [x] **🔥 PRIORITEIT: Eenvoudige 'murder' omschrijving voor spelscherm**
  - **Korte probleembeschrijving toevoegen aan elk scenario**
  - Moet op spelscherm getoond worden zodat speler weet wat het probleem is
  - Bijvoorbeeld: "Dashboard toont dubbele verkoopcijfers" of "Rapport toont verouderde data"
  - Speler moet direct zien WELK probleem ze moeten oplossen
  - Implementeren in UI: toon probleem bij scenario start
- [x] **Goede scenarios markeren** (4-5 sterren): Behouden als benchmark
- [x] **Nieuwe scenarios schrijven** volgens template indien nodig
- [x] **Validatie**: Elk scenario testen met "Zou een Power BI pro dit herkennen?"

**OUTPUT**: 12-15 solide, geloofwaardige, speelbare scenarios (minimaal 4/5 sterren) met duidelijke situatiebeschrijving voordat we verder gaan met agent hints.

---

## 🔥 KRITIEKE PRIORITEIT: Scenario Hints Schrijven

### 0.2 Scenario Hints voor Alle Scenarios 🔥 **PRIORITEIT**
**DOEL**: Alle 20+ scenarios voorzien van 3 agent hints (Schoonmaker, Receptionist, Stagiair) met INDIRECTE observaties.

**REGELS:**
- Agents geven OBSERVATIES, geen conclusies ("Ik zag persoon X bij locatie Y om 10:15")
- Agents mogen NIET rechtstreeks zeggen "persoon X is de dader" of "het wapen is Y"
- Agents mogen doorverwijzen ("misschien moet je eens met persoon A of B praten")
- Hints moeten logische deductie mogelijk maken
- Speler moet zelf conclusies trekken

**ACTIES:**
- [ ] Alle 20+ scenarios doornemen
- [ ] Per scenario: 3 hints schrijven (1 per agent)
- [ ] Hints valideren: indirect genoeg? Speelbaar?
- [ ] Hints in database invoeren (scenario_hints tabel)
- [ ] Testen met echte gameplay: leidt het tot deductie?

**STATUS:** Te checken komende week

---

## Fase 1: Planning & Architectuur

### 1.1 Technische Architectuur ✅
- [x] Tech stack bepalen: Python Flask + Vanilla JS + Supabase
- [x] Beslissen: Supabase met lokale fallback
- [x] Input methode: USB RFID Reader (keyboard emulation)
- [x] NFC-ID mapping systeem ontwerpen
- [ ] **NFC tags koppelen aan special_nfc_codes tabel in Supabase** ⏳ **KOMENDE WEEK**
  - Fysieke NFC tag nummers scannen en documenteren
  - Tag nummers invoeren in special_nfc_codes tabel met correcte persoon/locatie/wapen mapping
  - Testen of tags correct worden herkend in game
- [x] Scenario generatie: Webhook naar Supabase Edge Function bij START
- [x] State management bepalen:
  - Actief scenario-ID
  - Timer start tijd
  - Gescande items (WIE/WAARMEE/WAAR)
  - Straftijd (+15 sec per foute combinatie)
  - Bezochte hints
- [x] Reset functionaliteit: Standhouder pasje → reset naar homepage
- [x] Test vs Productie: Knoppen (test) / NFC cijfers (productie)

### 1.2 Data Structuur Ontwerp ✅
- [x] Database schema/JSON structuur maken voor:
  - Personen (verdachten)
  - Attributen (moordwapens)
  - Locaties (crime scenes)
  - Hints/Alibi's
  - Scenario's
  - Game states
  - Leaderboard/Tijden
- [x] NFC-ID mapping tabel ontwerpen
- [x] Relaties tussen entities definiëren
- [x] SQL scripts gemaakt (supabase_setup.sql)
- [x] Naam van deelnemer moet worden gegenereerd? Moet uniek zijn en iets met Power BI te maken hebben. DAX Dandies, Power Query Pumas, Model Movers, Comment Crushers, Filter Fillers, of zoiets. Daar moeten we ook een mooie AI oplossing voor maken

### 1.3 Game Logic Specificatie 🔄
- [x] Win-conditie: Correcte combinatie WIE + WAARMEE + WAAR
- [x] Volgorde validatie: Alle 3 antwoorden invullen, dan pas validatie
- [x] Foutafhandeling: 
  - Verkeerde combinatie = +15 sec straftijd + reset alle 3 boxen
- [x] Timer start: Bij START pasje scan
- [x] Timer stop: Bij correcte combinatie (eindtijd = speeltijd + straftijd)
- [ ] Hint-systeem logica uitwerken (scenario-specifiek via chatbot)
- [ ] Alibi/uitsluit mechanisme ontwerpen
- [ ] **Na 2 x fout antwoord: Hint: "Zoek op de stand naar getuigen om mee te 'praten'"**
- [x] **PRODUCTIE: Scenario text verbergen (toont nu antwoord!) - Add ?dev=true URL param voor development**

---

## Fase 2: Content Creatie

### 2.0 Agent Karakterisering & System Prompt Refactoring ✅ **AFGEROND**
- [x] **ALTER TABLE agents**: Voeg `system_prompt` en `gedrag_regels` kolommen toe
- [x] **Agent karakters uitwerken met persoonlijkheid:**
  - **Schoonmaker**: Dienstbaar, bescheiden, niemand tot last willen zijn, vriendelijk, observeert 's avonds gesprekken, geen technische kennis
  - **Receptionist**: Professioneel, administratief sterk, weet wie waar was en wanneer, planning-georiënteerd, formeel maar behulpzaam
  - **Stagiair**: Bijdehand, vol zelfvertrouwen, technisch bewust, soms iets té enthousiast om kennis te delen, jonge energie
- [x] **System prompts schrijven per agent met:**
  - Volledige karakterbeschrijving (persoonlijkheid, rol, achtergrond)
  - Gedragsregels (GEEN off-topic, blijf in karakter, GEEN directe antwoorden)
  - Tone of voice (formeel/informeel, woordkeuze, spreekstijl)
  - Kennisdomein (wat weet deze agent WEL/NIET)
  - Response stijl (observaties delen, doorverwijzen, alibi's geven)
- [x] **Bestaande hints refactoren**: Strip gedragsinstructies uit scenario_hints (die gaan naar agents tabel)
- [x] **Edge Function aanpassen**: Combineer `agents.system_prompt` + `scenario_hints.hint_context`
- [x] **Testen**: Valideer dat agents consistent gedrag tonen over alle scenarios

### 2.1 Personen Brainstorm ✅
- [x] 3 verdachten bedenken (Power BI persona's)
- [x] Karakterbeschrijvingen schrijven
- [x] In database toegevoegdjven
- [ ] Alibi's/achtergrond verhalen

### 2.2 Attributen (Moordwapens) Brainstorm ✅
- [x] 5 Power BI horror scenarios bedenken
- [x] Beschrijvingen per attribuut
- [x] Hoe deze het dashboard "vermoorden"
- [x] In database toegevoegd
### 2.3 Locaties Brainstorm ✅
- [x] 4 herkenbare Power BI locaties
- [x] Beschrijvingen per locatie
- [x] In database toegevoegdcaties
### 2.4 Scenario Matrix ✅
- [x] 20 logische scenario's uitgewerkt met realistische context
- [x] Per scenario: verhaal met timing/events (Q3, Heidag, etc.)
- [x] SQL script gemaakt (seed_scenarios.sql)
- [ ] Scenarios in database ladenn kaart brengen
### 2.5 Hints & Alibi's Uitwerken ✅
- [x] 3 hint-agents bedenken
- [x] Agent karakters uitgewerkt (Schoonmaker, IT Specialist, Receptionist)
- [x] scenario_hints tabel gevuld voor scenario 10 (Database Beheerder case)
- [x] **Agents mogen GEEN off-topic antwoorden geven (koekjesrecepten etc). System prompt moet strikt in-character houden - zie taak 2.0**
- [x] Per hint: dynamische content per scenario (voorbeelden maken voor andere 19 scenarios)
- [x] Alibi's die personen/wapens/locaties CONCREET uitsluiten
- [x] Hints met tijdsinformatie (wanneer gebeurde wat?) - ✅ voor scenario 10
- [x] Test of hints voldoende aanknopingspunten geven voor eliminatie
- [x] Kwaliteitscheck: hints moeten logische deductie mogelijk maken
- [x] Agents mogen GEEN feiten bedenken. Als ze iets niet weten, moeten ze daar gewoon duidelijk over zijn: ik weet het niet...
- **VERVOLG:** Zie **Fase 0.2 (Kritieke Prioriteit)** voor uitrol naar alle scenarios

### 2.6 Agent Chat Systeem ✅
- [x] ~~n8n herzien! Is dit nodig> nu gaat het via de supabase edge function?~~ **BESLUIT: n8n geskipt, werken via Supabase Edge Functions. Lijkt prima te werken!**
- [x] Edge Function opgezet voor agent chat (agent-chat)
- [x] OpenAI integratie in Edge Function
- [x] AI prompt engineering per agent (Schoonmaker/IT Specialist/Receptionist)
- [x] Prompt laadt scenario context in (beschrijving, persoon, wapen, locatie)
- [x] Chat interface deployed naar GitHub Pages
- [x] Testen met verschillende agents (alle 3 werken)
- [x] Hints geven CONCRETE info (tijd, locatie, persoon gezien)
- [x] **PROMPT TIGHTENING: Agents mogen ALLEEN in-character blijven. GEEN koekjesrecepten of off-topic antwoorden. Stricte system prompt met rol-enforcement toegevoegd - zie taak 2.0**
- [x] **KRITIEK: Agents geven nu INDIRECTE hints. Agents mogen NIET rechtstreeks zeggen "persoon X is de dader" of "het wapen is Y". Ze delen observaties ("ik zag persoon X bij locatie Y om 10:15") of geven alibi's ("ik ben onschuldig, ik was ergens anders"). Ze mogen doorverwijzen. Hints zijn indirect/observaties, geen conclusies. Speler moet zelf deduceren.**
- [x] **Chat Memory Fix: actualGameId bug opgelost, berichten worden correct opgeslagen in database**
- [x] **CASCADE DELETE: SQL constraint toegevoegd voor automatische cleanup**
- [x] **PROMPT SNAPSHOT bewaard vóór v2 tightening**: `PROMPT_BACKUP_2026-02-22.md`
- [ ] **PROMPT v2 evalueren in live chat** (spoiler-control, 1 clue per antwoord, rolconsistentie)
- **VERVOLG:** Zie **Fase 0.2 (Kritieke Prioriteit)** voor hints schrijven voor alle scenarios

### 2.7 Locaties Heroverwegen 🔄
- [ ] Brainstorm: fysieke locaties vs opslaglocaties
- [ ] Besluit: blijven we bij data-opslaglocaties of echte kantoorlocaties?
- [ ] Opties evalueren:
  - Data-opslag: Lakehouse, Datawarehouse, Excel Hell, Power BI Service
  - Fysiek: Meeting Room, Server Room, Kantine, Werkplek
- [ ] Scenarios aanpassen met tijdscomponent
- [ ] Database locaties updaten indien nodig

### 3.1 Basis Setup 🔄
- [x] Project initialiseren
- [ ] Dependencies installeren (Flask, Supabase client)
- [ ] Development environment opzetten
- [x] Git repository aangemaakt en gepusht naar GitHub
- [ ] Project initialiseren
- [ ] Dependencies installeren
- [ ] Development environment opzetten
- [ ] Git repository (optioneel)

### 3.2 Homepage ⬜
- [ ] 4 hoofdknoppen: Portfolio, Training, AI Automation, Murder Mystery
- [ ] Styling (hergebruik huidige codebase)
- [ ] Routing/navigatie

### 3.3 Portfolio/Training/AI Secties ⬜
- [ ] **Paginas voor AI Automation, AI Training, Power BI Portfolio en Power BI Training**
- [ ] Portfolio video/content integratie
- [ ] Training overzicht pagina
- [ ] AI Automation pagina
- [ ] Terug naar home functionaliteit
- [ ] Blokkering tijdens actief Murder Mystery spel

### 3.3.1 Contact Verzameling Systeem ✅
- [x] **NFC visitekaartje systeem opzetten**
  - [x] Houten visitekaartje scan → redirect naar LinkedIn pagina
  - [x] Contactformulier/lead capture mechanisme
  - [x] Database opslag voor contactgegevens (naam, email, bedrijf, interesse)
- [x] **n8n Automation workflow**
  - [x] Webhook trigger bij nieuwe contact registratie
  - [x] Welkomst email template in Another Dimension stijl
  - [x] Email verzending via n8n
  - [x] Optional: Follow-up sequentie
- [x] **Design & Content**
  - [x] Another Dimension styled email template (teal/green, Blender font)
  - [x] Persoonlijke boodschap van Thijs
  - [x] Links naar relevante diensten (gebaseerd op interesse)
  - [x] Privacy/GDPR compliance tekst

### 3.4 Murder Mystery - Start Flow ⬜
- [ ] "Murder Mystery" kaart scan detectie
- [ ] START pasje scan functionaliteit
- [ ] Scenario generatie triggeren
- [ ] Timer initialisatie
- [ ] Game state aanmaken

### 3.5 Murder Mystery - Gameplay ⬜
- [ ] 3 vakjes UI: WIE | WAARMEE | WAAR
- [ ] Timer display (real-time update)
- [ ] Scan input verwerking (met test knoppen)
- [ ] Categorie validatie (juiste volgorde afdwingen)
- [ ] Foutmeldingen bij verkeerde categorie
- [ ] Visuele feedback bij correcte scan

### 3.6 Murder Mystery - Hint Systeem ⬜
- [ ] Hint NFC scan detectie
- [ ] Scenario-specifieke hints ophalen
- [ ] Hint weergave op scherm
- [ ] Alibi/uitsluit logica implementeren
- [ ] (Nice-to-have: aantal gescande hints tonen)

### 3.7 Murder Mystery - Win/Loss/Exit ⬜
- [ ] Win-conditie check (correcte combinatie)
- [ ] EXIT pasje detectie (standhouder kan spel afbreken)
- [ ] Test EXIT knop (voor development)
- [ ] Win-scherm met eindtijd + session code
- [ ] QR code genereren met session code
- [ ] QR code weergave op scherm
- [ ] Leaderboard update (completed = TRUE, aborted = FALSE)
- [ ] Session code generator (unieke 4-6 character codes)

### 3.8 Reset Functionaliteit ⬜
- [ ] Standhouder reset-pasje detectie
- [ ] Game state reset
- [ ] Terug naar homepage
- [ ] Leaderboard behouden

### 3.9 Leaderboard ⬜
- [ ] Tijden opslaan (lokaal/Supabase)
- [ ] Top 3 weergave
- [ ] (Optioneel: dag/totaal filter)

---

## Fase 4: NFC Integratie

### 4.1 NFC ID Mapping ⬜
- [ ] Alle houten attributen NFC ID's registreren
- [ ] Mapping tabel invullen
- [ ] Test pasjes ID's registreren
- [ ] START pasje ID registreren
- [ ] Reset pasje ID registreren
- [ ] Hint locaties ID's registreren

### 4.2 Input Switch (Test → Productie) ⬜
- [ ] Test mode: knoppen met labels
- [ ] Productie mode: NFC nummer input
- [ ] Toggle tussen modes (config)
- [ ] Input parser implementeren

---

## Fase 5: Testing & Verfijning

### 5.1 Functionele Tests ⬜
- [ ] Homepage navigatie
- [ ] START flow
- [ ] Alle scan scenario's (correct/incorrect)
- [ ] Volgorde validatie
- [ ] Hint systeem
- [ ] Win-conditie
- [ ] Reset functionaliteit
- [ ] Leaderboard

### 5.2 RFID Reader Tests ⬜
- [ ] Alle NFC tags scannen en valideren
- [ ] Response tijd meten
- [ ] Foutafhandeling bij mislukte scans
- [ ] Edge cases (meerdere snelle scans, etc.)

### 5.3 Scenario Variatie Tests ⬜
- [ ] Verschillende scenario's genereren
- [ ] Controleren of hints kloppen per scenario
- [ ] Alibi's correct werken

### 5.4 User Experience ⬜
- [ ] Testpersonen laten spelen
- [ ] Feedback verzamelen
- [ ] Moeilijkheidsgraad aanpassen
- [ ] UI/UX verbeteringen

---

## Fase 7: UI/UX Verbeteringen & Polish

### 7.1 Agent Chat Interface 🔄
- [ ] **Agent emoji's toevoegen** die passen bij hun rol (Schoonmaker 🧹, IT Specialist 💻, Receptionist 📞)
- [ ] **Verstuur knop fix** - valt nu buiten beeld, moet altijd zichtbaar blijven
- [ ] **"Agent denkt na..." tekst aanpassen** naar "Even nadenken..." of iets natuurlijkers
- [ ] **Prompts aanpassen**: Agents zijn nu te letterlijk/direct. Ze moeten subtiele observaties delen en zich op de achtergrond houden (tenzij ze de dader zijn!)

### 7.2 Flask App Interface 🔄
- [ ] **Landingspagina opmaak** verbeteren
- [ ] **Another Dimension huisstijl** toevoegen (logo, kleuren, fonts)
- [ ] **Error message bij straftijd** stylen - moet stijlvoller en duidelijker
- [ ] **Scenario info verwijderen uit Leaderboard** (toont nu antwoord!)

### 7.3 Deelnemer Ervaring 🔄
- [x] **Automatische naam generator** voor deelnemers (Power BI themed: DAX Dandies, Power Query Pumas, Model Movers, Comment Crushers, Filter Fillers, etc.)
- [ ] **Instructie/uitleg pagina maken** voor spelers met verhaallijn: "Iemand heeft het Power BI Dashboard vermoord. Kun jij de Power BI Murder Mystery oplossen?" - inclusief spelregels, doel, en hoe het spel werkt
- [ ] **Hint reminder na x seconden**: Pop-up/melding in beeld: "Er zitten hints verstopt in de stand van Another Dimension. Gebruik je telefoon om de verborgen NFC tags te scannen"

---

## Fase 6: Deployment & Beurs Voorbereiding

### 6.1 Deployment ⬜
- [ ] Applicatie op laptop installeren
- [ ] RFID reader aansluiten en testen
- [ ] Internetverbinding/hotspot testen
- [ ] Backup plan bij tech issues
- [ ] **Uitzoeken: hoe deze app steady en standalone laten draaien** (production WSGI server, auto-restart, systemd/Windows service, of containerization)

### 6.2 Standmateriaal ⬜
- [ ] Houten attributen met NFC tags voorbereid
- [ ] Hint locaties op stand geplaatst
- [ ] Scherm/laptop positie optimaliseren
- [ ] Test complete setup op stand

### 6.3 Documentatie ⬜
- [ ] Gebruikershandleiding voor standhouder
- [ ] Troubleshooting guide
- [ ] NFC ID overzicht
- [ ] Reset procedures

---

## Optionele Verbeteringen (Nice-to-have)

### Spel Verbetering ⬜
- [ ] "Beschuldig" badge/chip in plaats van automatische check na 3e scan
- [ ] Hint tracking: visueel tonen welke hints al gescand zijn
- [ ] Database hints herstructureren naar uitsluit-logica
- [ ] Notitieblok systeem (digitaal) om opties af te vinken
- [ ] Animaties bij correcte scans
- [ ] Moeilijkheidsgraden (easy/hard mode)
- [ ] Geluid effecten

### Data & Analytics ⬜
- [ ] Speeldata opslaan voor analyse
- [ ] Gemiddelde speeltijd bijhouden
- [ ] Meest gescande hints
- [ ] Succes ratio

### Marketing & Leadgeneratie ⬜
- [ ] n8n workflow: Post-game form
  - [ ] Webhook endpoint maken
  - [ ] Form design (naam + email input)
  - [ ] Nieuwsbrief opt-in checkbox
  - [ ] Database update (games.player_name, player_email)
  - [ ] Bevestigingspagina
- [ ] QR code generator integratie in app
## Huidige Status
**Fase:** Fase 2 (Content) → Fase 3 (Development) transitie  
**Volgende actie:** 
1. Scenario hints voorbeelden maken (3-5 scenarios)
2. Database vullen met scenarios + hints
3. Flask applicatie opzetten en Supabase koppelen
4. Eerste interface maken

## Beslissingen Genomen
- **Tech Stack:** Python Flask + Vanilla JS + Supabase
- **RFID Input:** USB Reader met keyboard emulation (cijfer + Enter)
- **Scenario Generatie:** Vooraf aangemaakte scenarios (20 stuks met realistische context)
- **Straftijd:** +15 seconden per foute combinatie - DIRECT gestraft (geen voorwaarschappelijke pogingen)
- **Volgorde:** WIE → WAARMEE → WAAR (strict enforced)
- **Content:** 3 personen, 5 wapens, 4 locaties, 3 agents
- **Post-game:** QR code + n8n form voor leadgeneratie
- **Agent Systeem:** n8n chat workflow met AI voor scenario-specifieke hints
- **Hint Kwaliteit:** CONCRETE alibi's met tijd/locatie/persoon info voor eliminatie
- **Cluedo Mechaniek:** Focus op deductie en uitsluiten, niet gokken

## Design Notes

### Cluedo vs Huidig Spel
**Verschil met Cluedo:**
- Cluedo: systematisch uitsluiten via kaarten tonen
- Ons spel: hints via agents die alibi's geven

**Verbeterpunten voor Cluedo-gevoel:**
1. Agents geven concrete uitsluit-informatie
2. Tijdscomponent in scenarios en alibi's
3. Logische deductie mogelijk maken
4. Hints moeten personen/wapens/locaties elimineren

**Voorbeeld goede hint:**
- ✅ "Ik zag de Data Analist om 14:00 in de kantine, dus die kan niet om 14:30 in de Meeting Room zijn geweest"
- ❌ "Er gebeurde iets verdachts"

### Locaties Dilemma
**Twee opties:**
1. **Data-opslag locaties** (huidige): Lakehouse, Datawarehouse, Excel Hell, Power BI Service
2. **Fysieke locaties**: Meeting Room, Server Room, Kantine, Werkplek

**Te bespreken:** Welke geeft betere gameplay? Fysiek is herkenbaarder voor Cluedo-feel.

**Laatste update:** 24 december 2025
**Volgende actie:** Technische architectuur uitwerken  
**Laatste update:** 23 december 2025
