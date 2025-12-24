-- =============================================
-- Power BI Murder Mystery - Database Setup
-- Supabase PostgreSQL Schema
-- =============================================

-- =============================================
-- 1. PERSONEN (Verdachten)
-- =============================================

CREATE TABLE personen (
    id SERIAL PRIMARY KEY,
    naam VARCHAR(100) NOT NULL,
    nfc_code VARCHAR(50) UNIQUE NOT NULL,
    beschrijving TEXT,
    avatar_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW()
);

-- =============================================
-- 2. WAPENS (Power BI Horror Scenarios)
-- =============================================

CREATE TABLE wapens (
    id SERIAL PRIMARY KEY,
    naam VARCHAR(100) NOT NULL,
    nfc_code VARCHAR(50) UNIQUE NOT NULL,
    beschrijving TEXT,
    technische_uitleg TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- =============================================
-- 3. LOCATIES (Crime Scenes)
-- =============================================

CREATE TABLE locaties (
    id SERIAL PRIMARY KEY,
    naam VARCHAR(100) NOT NULL,
    nfc_code VARCHAR(50) UNIQUE NOT NULL,
    beschrijving TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- =============================================
-- 4. AGENTS (Hint Characters)
-- =============================================

CREATE TABLE agents (
    id SERIAL PRIMARY KEY,
    naam VARCHAR(100) NOT NULL,
    nfc_code VARCHAR(50) UNIQUE NOT NULL,
    achtergrond TEXT,
    tone_of_voice TEXT,
    avatar_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW()
);

-- =============================================
-- 5. SCENARIOS (Vooraf aangemaakte mysteries)
-- =============================================

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

-- =============================================
-- 6. SCENARIO_HINTS (Agent context per scenario)
-- =============================================

CREATE TABLE scenario_hints (
    id SERIAL PRIMARY KEY,
    scenario_id INTEGER NOT NULL REFERENCES scenarios(id) ON DELETE CASCADE,
    agent_id INTEGER NOT NULL REFERENCES agents(id),
    hint_context TEXT NOT NULL,
    alibi_info TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(scenario_id, agent_id)
);

-- =============================================
-- 7. GAMES (Spel sessies & leaderboard)
-- =============================================

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

-- =============================================
-- 8. CHAT_MESSAGES (Chat history per game)
-- =============================================

CREATE TABLE chat_messages (
    id SERIAL PRIMARY KEY,
    game_id INTEGER NOT NULL REFERENCES games(id) ON DELETE CASCADE,
    agent_id INTEGER NOT NULL REFERENCES agents(id),
    message TEXT NOT NULL,
    sender VARCHAR(20) NOT NULL CHECK (sender IN ('player', 'agent')),
    message_number INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- =============================================
-- 9. SPECIAL_NFC_CODES (Speciale pasjes)
-- =============================================

CREATE TABLE special_nfc_codes (
    id SERIAL PRIMARY KEY,
    code_type VARCHAR(50) NOT NULL UNIQUE,
    nfc_code VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- =============================================
-- INDEXES (Voor performance)
-- =============================================

-- Scenario lookups
CREATE INDEX idx_scenarios_active ON scenarios(active);

-- Game lookups
CREATE INDEX idx_games_scenario ON games(scenario_id);
CREATE INDEX idx_games_completed ON games(completed);
CREATE INDEX idx_games_total_time ON games(total_time_seconds) WHERE completed = TRUE;
CREATE INDEX idx_games_session_code ON games(session_code);

-- Chat lookups
CREATE INDEX idx_chat_game ON chat_messages(game_id);
CREATE INDEX idx_chat_agent ON chat_messages(agent_id);

-- NFC code lookups (meest gebruikt!)
CREATE INDEX idx_personen_nfc ON personen(nfc_code);
CREATE INDEX idx_wapens_nfc ON wapens(nfc_code);
CREATE INDEX idx_locaties_nfc ON locaties(nfc_code);
CREATE INDEX idx_agents_nfc ON agents(nfc_code);
CREATE INDEX idx_special_nfc ON special_nfc_codes(nfc_code);

-- =============================================
-- VIEWS (Voor gemakkelijke queries)
-- =============================================

-- Leaderboard View
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

-- Active Scenario View
CREATE VIEW active_scenario AS
SELECT 
    s.id as scenario_id,
    s.dader_id,
    s.wapen_id,
    s.locatie_id,
    p.naam as dader_naam,
    p.nfc_code as dader_nfc,
    w.naam as wapen_naam,
    w.nfc_code as wapen_nfc,
    l.naam as locatie_naam,
    l.nfc_code as locatie_nfc,
    s.verhaal,
    s.started_at
FROM scenarios s
LEFT JOIN personen p ON s.dader_id = p.id
LEFT JOIN wapens w ON s.wapen_id = w.id
LEFT JOIN locaties l ON s.locatie_id = l.id
WHERE s.active = TRUE;

-- =============================================
-- SEED DATA - PERSONEN
-- =============================================

INSERT INTO personen (naam, nfc_code, beschrijving) VALUES
(
    'Power BI Developer',
    'TEMP_NFC_PERSON_1',
    'Ontwikkelt en onderhoudt Power BI rapportages. Heeft volledige toegang tot PBIX files, kan DAX measures schrijven en datamodellen opzetten. Verantwoordelijk voor refresh instellingen en slicers.'
),
(
    'Financial Controller',
    'TEMP_NFC_PERSON_2',
    'Beheert budgetten en financiële rapportages. Levert budgetcijfers aan via Excel bestanden. Verantwoordelijk voor de juistheid van financiële analyses en budget updates.'
),
(
    'Database Beheerder',
    'TEMP_NFC_PERSON_3',
    'Beheert databases en toegangsrechten. Verantwoordelijk voor database onderhoud, gebruikersrechten, data integriteit en performance optimalisatie. Kan toegang intrekken waardoor refreshes falen.'
);

-- =============================================
-- SEED DATA - WAPENS
-- =============================================

INSERT INTO wapens (naam, nfc_code, beschrijving, technische_uitleg) VALUES
(
    'Many-to-Many Relatie',
    'TEMP_NFC_WEAPON_1',
    'Een relatie tussen twee tabellen waarbij meerdere rijen in tabel A corresponderen met meerdere rijen in tabel B.',
    'Leidt tot verkeerde berekeningen en dubbeltelling. Totalen kloppen niet, measures geven verkeerde resultaten en filtering werkt niet zoals verwacht.'
),
(
    'Hidden Slicer',
    'TEMP_NFC_WEAPON_2',
    'Een slicer die per ongeluk verborgen is in het rapport, maar nog steeds actief filtert.',
    'Gebruikers zien niet dat er gefilterd wordt. Data lijkt te ontbreken en cijfers kloppen niet met verwachtingen. Selection Pane toont de verborgen slicer.'
),
(
    'Dubbele Records in DIM Table',
    'TEMP_NFC_WEAPON_3',
    'Dimensietabellen bevatten duplicate entries, wat zorgt voor meervoudige koppelingen.',
    'Totalen zijn verdubbeld of vermenigvuldigd. Measures tellen records meerdere keren en relaties werken niet correct.'
),
(
    'Hardcoded Excel Pad',
    'TEMP_NFC_WEAPON_4',
    'Power Query bevat een vast pad naar een Excel bestand op een specifieke locatie (bijv. C:\Users\Jan\Documents\budget.xlsx).',
    'Werkt niet op andere computers of als bestand verplaatst wordt. "Bestand niet gevonden" error bij refresh. Data blijft verouderd.'
),
(
    'Budgetten Niet Geüpdatet',
    'TEMP_NFC_WEAPON_5',
    'De brondata met budgetcijfers is niet bijgewerkt met de laatste cijfers.',
    'Dit kan komen doordat Excel bestand niet is aangepast, refresh niet is ingeschakeld in semantisch model, of verkeerde versie van budget wordt gebruikt. Actuals vs Budget klopt niet.'
);

-- =============================================
-- SEED DATA - LOCATIES
-- =============================================

INSERT INTO locaties (naam, nfc_code, beschrijving) VALUES
(
    'OneDrive',
    'TEMP_NFC_LOCATION_1',
    'Cloud storage van Microsoft waar gebruikers bestanden opslaan. Vaak gebruikt voor Excel bronbestanden. Bestanden kunnen verplaatst worden en paden veranderen bij synchronisatie.'
),
(
    'Power Query Editor',
    'TEMP_NFC_LOCATION_2',
    'De interface waar data transformaties worden uitgevoerd voordat data in het model komt. Hier worden bronnen gekoppeld en transformatiestappen gedefinieerd.'
),
(
    'Semantisch Model',
    'TEMP_NFC_LOCATION_3',
    'Het datamodel binnen Power BI, inclusief tabellen, relaties, measures en instellingen. Refresh instellingen en gateway configuratie staan hier.'
),
(
    'Report View - Selection Pane',
    'TEMP_NFC_LOCATION_4',
    'Het paneel in Report View waar alle objecten op de pagina zichtbaar zijn, inclusief hun zichtbaarheid. Hier kunnen slicers verborgen zijn terwijl ze actief blijven filteren.'
);

-- =============================================
-- SEED DATA - AGENTS
-- =============================================

INSERT INTO agents (naam, nfc_code, achtergrond, tone_of_voice) VALUES
(
    'De Schoonmaker',
    'TEMP_NFC_AGENT_1',
    'Werkt s avonds en s nachts in het kantoor. Ziet en hoort alles, maar wordt vaak genegeerd. Observant en oplettend. Heeft sleutels tot alle ruimtes.',
    'Rustig, bedachtzaam, weet meer dan je denkt. Praat niet uit zichzelf maar geeft waardevolle informatie als je doorvraagt.'
),
(
    'De Receptionist',
    'TEMP_NFC_AGENT_2',
    'Zit aan de balie, ziet iedereen komen en gaan. Houdt agenda''s bij en weet welke meetings plaatsvinden. Sociaal en communicatief. Kent de routines van iedereen.',
    'Vriendelijk, professioneel, discreet. Weet wie waar afspraken mee heeft en wie gestrest of gehaast was.'
),
(
    'De Stagiair',
    'TEMP_NFC_AGENT_3',
    'Jong en nieuw in het bedrijf. Enthousiast maar nerveus. Heeft toegang gekregen tot systemen en weet van shortcuts die het team gebruikt. Eerlijk en open.',
    'Jong, enthousiast, soms onzeker, eerlijk. Durft geheimpjes te delen: "Eigenlijk moet dit niet zo, maar hier doen we dit wel..."'
);

-- =============================================
-- SEED DATA - SPECIAL NFC CODES
-- =============================================

INSERT INTO special_nfc_codes (code_type, nfc_code, description) VALUES
('START', 'TEMP_NFC_START', 'Start een nieuw Murder Mystery spel'),
('EXIT', 'TEMP_NFC_EXIT', 'Standhouder pasje om actief spel af te breken'),
('RESET', 'TEMP_NFC_RESET', 'Reset applicatie naar homepage'),
('PORTFOLIO', 'TEMP_NFC_PORTFOLIO', 'Navigeer naar Portfolio sectie'),
('TRAINING', 'TEMP_NFC_TRAINING', 'Navigeer naar Training sectie'),
('AI_AUTOMATION', 'TEMP_NFC_AI_AUTO', 'Navigeer naar AI Automation sectie');

-- =============================================
-- COMPLETED!
-- =============================================

-- Volgende stappen:
-- 1. Vervang alle TEMP_NFC codes met echte NFC codes van je houten attributen
-- 2. Voeg avatar_url toe aan personen en agents
-- 3. Genereer scenarios (zie aparte SQL file: seed_scenarios.sql)
-- 4. Schrijf scenario_hints voor elk scenario (kan via script of handmatig)
