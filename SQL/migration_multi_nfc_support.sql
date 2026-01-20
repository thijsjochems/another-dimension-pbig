-- Migration: Multi-NFC support voor backup tags
-- Voegt nfc_codes JSONB array toe aan alle relevante tabellen
-- Migreert bestaande nfc_code waarden naar array format

-- STAP 1: Voeg nfc_codes kolom toe aan personen
ALTER TABLE personen 
ADD COLUMN IF NOT EXISTS nfc_codes JSONB DEFAULT '[]'::jsonb;

-- Migreer bestaande nfc_code waarden naar array (als ze nog niet gemigreerd zijn)
UPDATE personen 
SET nfc_codes = jsonb_build_array(nfc_code)
WHERE nfc_codes = '[]'::jsonb AND nfc_code IS NOT NULL;

-- STAP 2: Voeg nfc_codes kolom toe aan wapens
ALTER TABLE wapens 
ADD COLUMN IF NOT EXISTS nfc_codes JSONB DEFAULT '[]'::jsonb;

UPDATE wapens 
SET nfc_codes = jsonb_build_array(nfc_code)
WHERE nfc_codes = '[]'::jsonb AND nfc_code IS NOT NULL;

-- STAP 3: Voeg nfc_codes kolom toe aan locaties
ALTER TABLE locaties 
ADD COLUMN IF NOT EXISTS nfc_codes JSONB DEFAULT '[]'::jsonb;

UPDATE locaties 
SET nfc_codes = jsonb_build_array(nfc_code)
WHERE nfc_codes = '[]'::jsonb AND nfc_code IS NOT NULL;

-- STAP 4: Voeg nfc_codes kolom toe aan agents
ALTER TABLE agents 
ADD COLUMN IF NOT EXISTS nfc_codes JSONB DEFAULT '[]'::jsonb;

UPDATE agents 
SET nfc_codes = jsonb_build_array(nfc_code)
WHERE nfc_codes = '[]'::jsonb AND nfc_code IS NOT NULL;

-- STAP 5: Voeg nfc_codes kolom toe aan special_nfc_codes
ALTER TABLE special_nfc_codes 
ADD COLUMN IF NOT EXISTS nfc_codes JSONB DEFAULT '[]'::jsonb;

UPDATE special_nfc_codes 
SET nfc_codes = jsonb_build_array(nfc_code)
WHERE nfc_codes = '[]'::jsonb AND nfc_code IS NOT NULL;

-- STAP 6: Maak indexes voor snelle lookups (JSONB gin operator)
CREATE INDEX IF NOT EXISTS idx_personen_nfc_codes ON personen USING gin(nfc_codes);
CREATE INDEX IF NOT EXISTS idx_wapens_nfc_codes ON wapens USING gin(nfc_codes);
CREATE INDEX IF NOT EXISTS idx_locaties_nfc_codes ON locaties USING gin(nfc_codes);
CREATE INDEX IF NOT EXISTS idx_agents_nfc_codes ON agents USING gin(nfc_codes);
CREATE INDEX IF NOT EXISTS idx_special_nfc_codes_nfc_codes ON special_nfc_codes USING gin(nfc_codes);

-- Verificatie query's
SELECT 'PERSONEN' as table_name, id, naam, nfc_code as old_code, nfc_codes as new_codes FROM personen ORDER BY id;
SELECT 'WAPENS' as table_name, id, naam, nfc_code as old_code, nfc_codes as new_codes FROM wapens ORDER BY id;
SELECT 'LOCATIES' as table_name, id, naam, nfc_code as old_code, nfc_codes as new_codes FROM locaties ORDER BY id;
SELECT 'AGENTS' as table_name, id, naam, nfc_code as old_code, nfc_codes as new_codes FROM agents ORDER BY id;
SELECT 'SPECIAL_NFC_CODES' as table_name, id, code_type, nfc_code as old_code, nfc_codes as new_codes FROM special_nfc_codes ORDER BY id;

-- Test query: Check of een specifieke code voorkomt in arrays
-- SELECT * FROM personen WHERE nfc_codes ? '3032948996';
