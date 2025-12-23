# TODO Lijst - Interactieve Beurs Stand

## Status Legend
- ⬜ Nog niet gestart
- 🔄 In progress
- ✅ Afgerond

---

## Fase 1: Planning & Architectuur

### 1.1 Technische Architectuur 🔄
- [x] Tech stack bepalen: Python Flask + Vanilla JS + Supabase
- [x] Beslissen: Supabase met lokale fallback
- [x] Input methode: USB RFID Reader (keyboard emulation)
- [ ] NFC-ID mapping systeem ontwerpen
- [x] Scenario generatie: Webhook naar Supabase Edge Function bij START
- [x] State management bepalen:
  - Actief scenario-ID
  - Timer start tijd
  - Gescande items (WIE/WAARMEE/WAAR)
  - Straftijd (+15 sec per foute combinatie)
  - Bezochte hints
- [x] Reset functionaliteit: Standhouder pasje → reset naar homepage
- [x] Test vs Productie: Knoppen (test) / NFC cijfers (productie)

### 1.2 Data Structuur Ontwerp ⬜
- [ ] Database schema/JSON structuur maken voor:
  - Personen (verdachten)
  - Attributen (moordwapens)
  - Locaties (crime scenes)
  - Hints/Alibi's
  - Scenario's
  - Game states
  - Leaderboard/Tijden
- [ ] NFC-ID mapping tabel ontwerpen
- [ ] Relaties tussen entities definiëren

### 1.3 Game Logic Specificatie 🔄
- [x] Win-conditie: Correcte combinatie WIE + WAARMEE + WAAR
- [x] Volgorde validatie: Moet in volgorde WIE → WAARMEE → WAAR
- [x] Foutafhandeling: 
  - Verkeerde categorie = foutmelding + geen scan registratie
  - Verkeerde combinatie = +15 sec straftijd (zichtbaar op scherm)
- [ ] Hint-systeem logica uitwerken (scenario-specifiek via Edge Function)
- [ ] Alibi/uitsluit mechanisme ontwerpen
- [x] Timer start: Bij START pasje scan
- [x] Timer stop: Bij correcte combinatie (eindtijd = speeltijd + straftijd)

---

## Fase 2: Content Creatie

### 2.1 Personen Brainstorm ⬜
- [ ] 5-6 verdachten bedenken (Power BI persona's)
- [ ] Karakterbeschrijvingen schrijven
- [ ] Alibi's/achtergrond verhalen

### 2.2 Attributen (Moordwapens) Brainstorm ⬜
- [ ] 4-5 Power BI horror scenarios bedenken
- [ ] Beschrijvingen per attribuut
- [ ] Hoe deze het dashboard "vermoorden"

### 2.3 Locaties Brainstorm ⬜
- [ ] 4-5 herkenbare Power BI locaties
- [ ] Beschrijvingen per locatie

### 2.4 Scenario Matrix ⬜
- [ ] Alle mogelijke combinaties in kaart brengen
- [ ] Per scenario: logische samenhang checken
- [ ] Scenario randomisatie logica

### 2.5 Hints & Alibi's Uitwerken ⬜
- [ ] ~5 hint-agents bedenken
- [ ] Per hint: dynamische content per scenario
- [ ] Alibi's die personen uitsluiten
- [ ] Test of hints voldoende aanknopingspunten geven

---

## Fase 3: Development

### 3.1 Basis Setup ⬜
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

### 3.7 Murder Mystery - Win/Loss ⬜
- [ ] Win-conditie check
- [ ] Win-scherm met eindtijd
- [ ] Leaderboard update
- [ ] Optie: email voor leadgeneratie
- [ ] Restart/nieuwe game optie

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

### Marketing ⬜
- [ ] Email capture bij win
- [ ] Social media share functie
- [ ] Foto van winnaar met tijd
- [ ] QR code naar company website
## Huidige Status
**Fase:** Planning & Architectuur (Fase 1.1 grotendeels afgerond)  
**Volgende actie:** Data structuur ontwerpen (Fase 1.2)  
**Laatste update:** 23 december 2025

## Beslissingen Genomen
- **Tech Stack:** Python Flask + Vanilla JS + Supabase
- **RFID Input:** USB Reader met keyboard emulation (cijfer + Enter)
- **Scenario Generatie:** Webhook naar Supabase Edge Function bij START
- **Straftijd:** +15 seconden per foute combinatie (zichtbaar op scherm)
- **Volgorde:** WIE → WAARMEE → WAAR (strict enforced)
**Fase:** Planning & Architectuur  
**Volgende actie:** Technische architectuur uitwerken  
**Laatste update:** 23 december 2025
