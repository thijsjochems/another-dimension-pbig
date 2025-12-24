# Database Schema - Power BI Murder Mystery

## Overzicht
Dit schema is ontworpen voor Supabase (PostgreSQL) en ondersteunt:
- Vooraf aangemaakte scenario's
- Actieve game state tracking
- Agent chat via n8n
- Leaderboard functionaliteit

---

## Tabellen

### 1. `personen` (Verdachten)
Bevat alle mogelijke verdachten.

```sql
CREATE TABLE personen (
    id SERIAL PRIMARY KEY,
    naam VARCHAR(100) NOT NULL,
    nfc_code VARCHAR(50) UNIQUE NOT NULL,
    beschrijving TEXT,
    avatar_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW()
);
```

**Velden:**
- `id`: Unieke identifier
- `naam`: Naam van de persoon (bijv. "Power BI Developer")
- `nfc_code`: De code die de RFID reader teruggeeft
- `beschrijving`: Achtergrond info
- `avatar_url`: Pad naar foto (voor later)
- `created_at`: Wanneer toegevoegd

**Waarom:** Alle personen op één plek, makkelijk uit te breiden

---

### 2. `wapens` (Power BI Horrors)
Bevat alle mogelijke "moordwapens".

```sql
CREATE TABLE wapens (
    id SERIAL PRIMARY KEY,
    naam VARCHAR(100) NOT NULL,
    nfc_code VARCHAR(50) UNIQUE NOT NULL,
    beschrijving TEXT,
    technische_uitleg TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);
```

**Velden:**
- `id`: Unieke identifier
- `naam`: Naam wapen (bijv. "Many-to-Many Relatie")
- `nfc_code`: De code die de RFID reader teruggeeft
- `beschrijving`: Wat het is
- `technische_uitleg`: Hoe dit het dashboard "vermoordde"
- `created_at`: Wanneer toegevoegd

**Waarom:** Wapens zijn herbruikbaar in verschillende scenario's

---

### 3. `locaties` (Crime Scenes)
Bevat alle mogelijke locaties.

```sql
CREATE TABLE locaties (
    id SERIAL PRIMARY KEY,
    naam VARCHAR(100) NOT NULL,
    nfc_code VARCHAR(50) UNIQUE NOT NULL,
    beschrijving TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);
```

**Velden:**
- `id`: Unieke identifier
- `naam`: Naam locatie (bijv. "Power Query Editor")
- `nfc_code`: De code die de RFID reader teruggeeft
- `beschrijving`: Wat deze locatie is
- `created_at`: Wanneer toegevoegd

**Waarom:** Locaties zijn herbruikbaar in verschillende scenario's

---

### 4. `agents` (Hint Characters)
Bevat de hint-personages.

```sql
CREATE TABLE agents (
    id SERIAL PRIMARY KEY,
    naam VARCHAR(100) NOT NULL,
    nfc_code VARCHAR(50) UNIQUE NOT NULL,
    achtergrond TEXT,
    tone_of_voice TEXT,
    avatar_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW()
);
```

**Velden:**
- `id`: Unieke identifier
- `naam`: Naam agent (bijv. "De Schoonmaker")
- `nfc_code`: De code die de RFID reader teruggeeft
- `achtergrond`: Achtergrond verhaal
- `tone_of_voice`: Hoe deze agent praat (voor AI prompt)
- `avatar_url`: Pad naar foto
- `created_at`: Wanneer toegevoegd

**Waarom:** Agents hebben vaste karakteristieken die herbruikt worden

---

### 5. `scenarios` (Vooraf aangemaakte mysteries)
Bevat alle vooraf gecreëerde scenario's.

```sql
CREATE TABLE scenarios (
    id SERIAL PRIMARY KEY,
    dader_id INTEGER NOT NULL REFERENCES personen(id),
    wapen_id INTEGER NOT NULL REFERENCES wapens(id),
    locatie_id INTEGER NOT NULL REFERENCES locaties(id),
    verhaal TEXT,
    active BOOLEAN DEFAULT FALSE,
    started_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW()
);
```

**Velden:**
- `id`: Unieke scenario identifier
- `dader_id`: Foreign key naar personen tabel
- `wapen_id`: Foreign key naar wapens tabel
- `locatie_id`: Foreign key naar locaties tabel
- `verhaal`: Kort verhaal van dit scenario (optioneel)
- `active`: Is dit scenario momenteel actief? (alleen 1 mag true zijn)
- `started_at`: Wanneer het scenario gestart is
- `created_at`: Wanneer scenario aangemaakt is

**Waarom:** 
- Vooraf gemaakte scenarios = consistent en getest
- `active` flag voorkomt dubbele spellen (slechts 1 tegelijk)
- Foreign keys garanderen data integriteit

---

### 6. `scenario_hints` (Agent antwoorden per scenario)
Bevat de AI prompt context per agent per scenario.

```sql
CREATE TABLE scenario_hints (
    id SERIAL PRIMARY KEY,
    scenario_id INTEGER NOT NULL REFERENCES scenarios(id) ON DELETE CASCADE,
    agent_id INTEGER NOT NULL REFERENCES agents(id),
    hint_context TEXT NOT NULL,
    alibi_info TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(scenario_id, agent_id)
);
```

**Velden:**
- `id`: Unieke identifier
- `scenario_id`: Foreign key naar scenarios
- `agent_id`: Foreign key naar agents
- `hint_context`: De context die de AI krijgt voor deze agent in dit scenario
- `alibi_info`: Eventuele alibi informatie (bijv. "Was met Financial Controller")
- `UNIQUE(scenario_id, agent_id)`: Elke agent heeft per scenario max 1 hint definitie

**Waarom:**
- Koppelt scenario's aan agents
- `hint_context` wordt gebruikt als AI prompt context
- n8n kan deze ophalen bij chat sessie start
- `ON DELETE CASCADE`: Als scenario verwijderd wordt, verdwijnen hints ook

---

### 7. `games` (Spel sessies & leaderboard)
Houdt elke game sessie bij.

```sql
CREATE TABLE games (
    id SERIAL PRIMARY KEY,
    session_code VARCHAR(10) UNIQUE NOT NULL,
    scenario_id INTEGER NOT NULL REFERENCES scenarios(id),
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP,
    penalty_seconds INTEGER DEFAULT 0,
    total_time_seconds INTEGER,
    completed BOOLEAN DEFAULT FALSE,
    aborted BOOLEAN DEFAULT FALSE,
    player_name VARCHAR(100),
    player_email VARCHAR(255),
    player_submitted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW()
);
```

**Velden:**
- `id`: Unieke game identifier
- `session_code`: Korte code (bijv. "A7B3") voor speler om in te vullen via telefoon
- `scenario_id`: Welk scenario werd gespeeld
- `start_time`: Wanneer START pasje gescand
- `end_time`: Wanneer correcte combinatie gescand OF EXIT gescand
- `penalty_seconds`: Totale straftijd (+15 sec per fout)
- `total_time_seconds`: Eindtijd in seconden (end_time - start_time + penalty)
- `completed`: TRUE als correcte combinatie gevonden
- `aborted`: TRUE als standhouder EXIT heeft gescand
- `player_name`: Ingevuld via n8n form (na QR scan)
- `player_email`: Ingevuld via n8n form (na QR scan)
- `player_submitted_at`: Wanneer speler gegevens heeft ingevuld
- `created_at`: Record aanmaakdatum

**Game end condities:**
1. **WIN**: Correcte combinatie gescand → `completed = TRUE`, `end_time` = nu
2. **EXIT**: Standhouder EXIT pasje → `aborted = TRUE`, `end_time` = nu
3. **Test button**: Testknop voor EXIT tijdens development

**Na afloop:**
- QR code wordt getoond met `session_code`
- Speler scant QR → n8n form
- Speler vult `session_code` + naam + email in
- n8n update `games` record

**Waarom:**
- `session_code`: Unieke korte code om game te identificeren via telefoon
- `aborted`: Onderscheid tussen gewonnen en afgebroken games
- `player_submitted_at`: Track conversie (hoeveel mensen vullen gegevens in)
- Tracking van elke game
- Leaderboard data (sorteer op total_time_seconds WHERE completed = TRUE)
- Analytics (hoeveel games, gemiddelde tijd, conversie ratio, etc.)
- Penalty tracking

---

### 8. `chat_messages` (Chat history per game)
Slaat alle chat berichten op.

```sql
CREATE TABLE chat_messages (
    id SERIAL PRIMARY KEY,
    game_id INTEGER NOT NULL REFERENCES games(id) ON DELETE CASCADE,
    agent_id INTEGER NOT NULL REFERENCES agents(id),
    message TEXT NOT NULL,
    sender VARCHAR(20) NOT NULL CHECK (sender IN ('player', 'agent')),
    message_number INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);
```

**Velden:**
- `id`: Unieke message identifier
- `game_id`: Bij welke game hoort dit bericht
- `agent_id`: Met welke agent wordt gechat
- `message`: De tekst van het bericht
- `sender`: 'player' of 'agent'
- `message_number`: Volgorde nummer (1, 2, 3 voor max 3 berichten limiet)
- `created_at`: Wanneer verzonden

**Waarom:**
- Chat history bewaren
- Max 3 berichten per agent enforced in applicatie logica
- Mogelijk voor later: analytics over welke vragen gesteld worden
- `ON DELETE CASCADE`: Als game verwijderd wordt, verdwijnen berichten ook

---

### 9. `special_nfc_codes` (Speciale pasjes)
Bevat speciale NFC codes zoals START, RESET en EXIT.

```sql
CREATE TABLE special_nfc_codes (
    id SERIAL PRIMARY KEY,
    code_type VARCHAR(50) NOT NULL UNIQUE,
    nfc_code VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);
```

**Velden:**
- `id`: Unieke identifier
- `code_type`: Type code (bijv. 'START', 'RESET', 'EXIT', 'PORTFOLIO', 'TRAINING', 'AI_AUTOMATION')
- `nfc_code`: De NFC code
- `description`: Wat deze code doet
- `created_at`: Wanneer toegevoegd

**Speciale codes:**
- **START**: Start nieuw spel (selecteert scenario)
- **EXIT**: Standhouder pasje om spel af te breken
- **RESET**: Terug naar homepage
- **PORTFOLIO/TRAINING/AI_AUTOMATION**: Navigatie naar andere secties

**Waarom:**
- Centraal beheer van speciale codes
- Makkelijk nieuwe speciale codes toevoegen
- Duidelijk onderscheid met game-gerelateerde codes

---

## Relaties Diagram

```
personen ──┐
wapens ────┼──> scenarios ──> games ──> chat_messages
locaties ──┘         │           │
                     │           └──> (leaderboard view)
                     └──> scenario_hints <── agents
```

---

## Indexes (voor performance)

```sql
-- Scenario lookup
CREATE INDEX idx_scenarios_active ON scenarios(active);

-- Game lookups
CREATE INDEX idx_games_scenario ON games(scenario_id);
CREATE INDEX idx_games_completed ON games(completed);
CREATE INDEX idx_games_total_time ON games(total_time_seconds) WHERE completed = TRUE;

-- Chat lookups
### Leaderboard View
```sql
CREATE VIEW leaderboard AS
SELECT 
    id,
    session_code,
    player_name,
    total_time_seconds,
    penalty_seconds,
    (total_time_seconds - penalty_seconds) as actual_time_seconds,
    start_time,
    end_time,
    player_submitted_at
FROM games
WHERE completed = TRUE AND aborted = FALSE
ORDER BY total_time_seconds ASC;
```ctive scenario lookup gebeurt bij elke START

---

## Views (voor gemakkelijke queries)

### Leaderboard View
```sql
CREATE VIEW leaderboard AS
SELECT 
    id,
    player_name,
    total_time_seconds,
    penalty_seconds,
    (total_time_seconds - penalty_seconds) as actual_time_seconds,
    start_time,
    end_time
FROM games
WHERE completed = TRUE
ORDER BY total_time_seconds ASC;
```

### Active Scenario View
```sql
CREATE VIEW active_scenario AS
SELECT 
    s.id as scenario_id,
    p.naam as dader_naam,
    w.naam as wapen_naam,
    l.naam as locatie_naam,
    s.started_at
FROM scenarios s
LEFT JOIN personen p ON s.dader_id = p.id
LEFT JOIN wapens w ON s.wapen_id = w.id
LEFT JOIN locaties l ON s.locatie_id = l.id
WHERE s.active = TRUE;
```

---

## Waarom dit schema logisch is

### ✅ Normalisatie
- Geen duplicatie van data
- Personen/wapens/locaties zijn herbruikbaar
- Updates op één plek

### ✅ Vooraf aangemaakte scenarios
- Consistente gameplay
- Getest en gecontroleerd
- Hints perfect afgestemd
- Geen AI generatie tijdens beurs (betrouwbaar!)

### ✅ Single active game
- `active` flag in scenarios voorkomt conflicten
- Maar wel 60 scenarios beschikbaar voor variatie

### ✅ Chat integratie
- `scenario_hints` bevat AI prompt context
- n8n kan ophalen bij agent scan
- `chat_messages` bewaard alles voor analytics

### ✅ Leaderboard ready
- `games` tabel met alle timing data
- Penalty tracking ingebouwd
- Optionele player info voor competitie

### ✅ Uitbreidbaar
- Nieuwe personen/wapens/locaties = gewoon toevoegen
- Nieuwe scenarios = nieuwe combinaties
- Meer agents = meer hint-mogelijkheden

### ✅ NFC code mapping
- Alle NFC codes centraal in hun eigen tabellen
- `special_nfc_codes` voor speciale pasjes
- Foreign keys garanderen dat codes geldig zijn

## Post-Game Flow (Leadgeneratie)

### Stap 1: Game eindigt
- Correcte combinatie OF EXIT pasje gescand
- Scherm toont: **"Game voltooid! Scan QR code om op leaderboard te komen"**
- QR code wordt getoond met `session_code` (bijv. "A7B3")

### Stap 2: Speler scant QR
- QR code linkt naar: `https://n8n-webhook-url?session=A7B3`
- n8n toont form met:
  - Welkom tekst + game tijd
  - Input: Naam (required)
  - Input: Email (required voor leaderboard)
  - Checkbox: Nieuwsbrief opt-in (optioneel)
  - Submit knop

### Stap 3: n8n update database
```javascript
// n8n workflow
UPDATE games 
SET 
    player_name = $name,
    player_email = $email,
    player_submitted_at = NOW()
WHERE session_code = $session
```

### Stap 4: Bevestiging
- "Bedankt! Je staat nu op de leaderboard"
- Link naar leaderboard pagina (optioneel)

---

## Volgende stappen

1. **Supabase project aanmaken**
2. **Tables aanmaken** met bovenstaande SQL
3. **Seed data** invoeren (personen, wapens, locaties, agents)
4. **Scenarios genereren** (combinaties maken)
5. **Scenario hints** schrijven per agent per scenario
6. **NFC codes** toewijzen aan houten attributen
7. **n8n workflow** maken voor post-game form
8. **QR code generator** in applicatie

Klaar om te beginnen met Supabase setup?tributen

Klaar om te beginnen met Supabase setup?
