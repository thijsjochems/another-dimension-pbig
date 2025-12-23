# Interactieve Beurs Stand Concept - Power BI
**Datum:** 23 december 2025  
**Standformaat:** 2m x 2m

## Hardware Setup
- Laptop met scherm
- RFID Reader (plug and play)
- Houten attributen met NFC chips

## Functionaliteit

### 1. Portfolio Presentatie
**Trigger:** Houten plaat met "Portfolio" scannen  
**Actie:** Video afspelen met voorbeelden van Power BI rapportages

### 2. Training Overzicht
**Trigger:** Houten plaat met "Training" scannen  
**Actie:** Presentatie van trainingsaanbod

### 3. AI Automation
**Trigger:** Houten plaat met "AI Automation" scannen  
**Actie:** Overzicht van AI en automation diensten

### 4. Murder Mystery Game: "Who killed the Power BI Dashboard?"
**Trigger:** Houten plaat met "Murder Mystery" scannen  
**Actie:** Interactief spel starten

#### Game Mechanic
Bezoekers krijgen verschillende houten stukjes met NFC tags:
- **Personen** (verdachten)
- **Locaties** (waar het "misdrijf" plaatsvond)
- **Attributen** (moordwapens/tools/bewijs)

**Spelverloop:**
- Bezoekers scannen START pasje om spel te beginnen
- Timer start en scenario wordt gegenereerd
- Bezoekers scannen in volgorde: WIE → WAARMEE → WAAR
- Verkeerde categorie = foutmelding
- Verkeerde combinatie = +15 seconden straftijd (zichtbaar op scherm)
- Het systeem controleert of de gescande combinatie correct is
- Doel: De juiste combinatie vinden die het Power BI Dashboard heeft "vermoord"

**Scenario Management:**
- Bij START: webhook trigger naar Supabase Edge Function
- Edge Function genereert/selecteert uniek scenario
- Elk spel heeft een **willekeurig gegenereerd scenario**
- Dit voorkomt dat bezoekers antwoorden aan elkaar doorgeven
- De oplossing (persoon + locatie + attribuut) verschilt per spel
- Scenario bevat: dader, wapen, locatie + bijbehorende hints

**Tijdregistratie:**
- Systeem houdt bij: tijd vanaf start tot juiste oplossing
- Mogelijk voor competitie-element (snelste tijd van de dag/beurs)

**Hint Systeem:**
- Op de stand zijn NFC tags verspreid met **agents** (getuigen/informanten)
- Bezoekers kunnen deze scannen om agents te "bevragen"
- Agents geven hints die **specifiek zijn voor het actieve scenario**
- Cruciale vereiste: agent-antwoorden moeten dynamisch aansluiten bij het scenario

**Standhouder Controle:**
- Speciaal **reset-pasje** voor standhouder
## Technische Architectuur

### Stack
- **Frontend:** HTML/CSS/JavaScript (vanilla)
- **Backend:** Python + Flask (lokaal draaiend op laptop)
- **Database:** Supabase (PostgreSQL + Edge Functions)
- **Input:** USB RFID Reader (keyboard emulation: cijfer + Enter)

### Data Flow
```
[RFID Reader] → [Python Flask] → [Supabase Edge Function] → [Database]
                       ↓
                 [Frontend HTML/JS]
```

### Scenario Generatie
- START scan → Webhook naar Supabase Edge Function
- Edge Function genereert scenario + hints
- Scenario-ID terug naar applicatie
- Hints gekoppeld aan scenario-ID

## Technische Uitdagingen
1. **Scenario Consistentie:** Agent-antwoorden moeten dynamisch gegenereerd worden op basis van actief scenario
2. **Willekeurige Scenario Generatie:** Elk spel moet uniek zijn
3. **State Management:** Systeem moet bijhouden: actief scenario, gescande items, verstreken tijd, straftijd, bezochte agents
4. **Reset Functionaliteit:** Soepele overgang tussen bezoekers
5. **Test vs Productie:** Knoppen voor testen, NFC cijfers voor productie
6. **Webhook Timing:** Edge Function moet snel reageren bij START gegenereerd worden op basis van actief scenario
2. **Willekeurige Scenario Generatie:** Elk spel moet uniek zijn
3. **State Management:** Systeem moet bijhouden: actief scenario, gescande items, verstreken tijd, bezochte agents
4. **Reset Functionaliteit:** Soepele overgang tussen bezoekers

## Voordelen van dit concept
- **Interactief en tactiel:** Bezoekers raken fysiek betrokken
- **Memorabel:** Unieke ervaring blijft hangen
- **Aandachttrekkend:** Trekt publiek naar de stand
- **Gespreksopener:** Natuurlijke manier om in gesprek te komen
- **Herhaalbaarheid:** Door variërende scenario's blijft het spel interessant
