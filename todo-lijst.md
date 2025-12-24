# TODO Lijst - Interactieve Beurs Stand

## Status Legend
- ⬜ Nog niet gestart
- 🔄 In progress
- ✅ Afgerond

---

## Fase 1: Planning & Architectuur

### 1.1 Technische Architectuur ✅
- [x] Tech stack bepalen: Python Flask + Vanilla JS + Supabase
- [x] Beslissen: Supabase met lokale fallback
- [x] Input methode: USB RFID Reader (keyboard emulation)
- [x] NFC-ID mapping systeem ontwerpen
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

### 1.3 Game Logic Specificatie 🔄
- [x] Win-conditie: Correcte combinatie WIE + WAARMEE + WAAR
- [x] Volgorde validatie: Alle 3 antwoorden invullen, dan pas validatie
- [x] Foutafhandeling: 
  - Verkeerde combinatie = +15 sec straftijd + reset alle 3 boxen
- [x] Timer start: Bij START pasje scan
- [x] Timer stop: Bij correcte combinatie (eindtijd = speeltijd + straftijd)
- [ ] Hint-systeem logica uitwerken (scenario-specifiek via n8n chatbot)
- [ ] Alibi/uitsluit mechanisme ontwerpen
- [ ] **PRODUCTIE: Scenario text verbergen (toont nu antwoord!) - Add ?dev=true URL param voor development**

---

## Fase 2: Content Creatie
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
### 2.5 Hints & Alibi's Uitwerken 🔄
- [x] 3 hint-agents bedenken
- [x] Agent karakters uitgewerkt (Schoonmaker, Receptionist, Stagiair)
- [ ] Per hint: dynamische content per scenario (voorbeelden maken)
- [ ] Alibi's die personen uitsluiten
- [ ] Test of hints voldoende aanknopingspunten geven
- [ ] Per hint: dynamische content per scenario
- [ ] Alibi's die personen uitsluiten
- [ ] Test of hints voldoende aanknopingspunten geven

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
- [ ] Portfolio video/content integratie
- [ ] Training overzicht pagina
- [ ] AI Automation pagina
- [ ] Terug naar home functionaliteit
- [ ] Blokkering tijdens actief Murder Mystery spel

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

## Fase 6: Deployment & Beurs Voorbereiding

### 6.1 Deployment ⬜
- [ ] Applicatie op laptop installeren
- [ ] RFID reader aansluiten en testen
- [ ] Internetverbinding/hotspot testen
- [ ] Backup plan bij tech issues

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
- [ ] "Beschuldig" knop in plaats van automatische check
- [ ] Penalty tijd bij foute gok (+30 sec)
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

**Laatste update:** 24 december 2025

## Beslissingen Genomen
- **Tech Stack:** Python Flask + Vanilla JS + Supabase
- **RFID Input:** USB Reader met keyboard emulation (cijfer + Enter)
- **Scenario Generatie:** Vooraf aangemaakte scenarios (20 stuks met realistische context)
- **Straftijd:** +15 seconden per foute combinatie (zichtbaar op scherm)
- **Volgorde:** WIE → WAARMEE → WAAR (strict enforced)
- **Content:** 3 personen, 5 wapens, 4 locaties, 3 agents
- **Post-game:** QR code + n8n form voor leadgeneratieijfer + Enter)
- **Scenario Generatie:** Webhook naar Supabase Edge Function bij START
- **Straftijd:** +15 seconden per foute combinatie (zichtbaar op scherm)
- **Volgorde:** WIE → WAARMEE → WAAR (strict enforced)
**Fase:** Planning & Architectuur  
**Volgende actie:** Technische architectuur uitwerken  
**Laatste update:** 23 december 2025
