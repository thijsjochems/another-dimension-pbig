-- =============================================
-- QUICK FIX SCRIPT
-- Run this in Supabase SQL Editor to fix current issues
-- =============================================

-- 1. Fix column names in scenarios table (only if they exist)
DO $$ 
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns 
               WHERE table_name='scenarios' AND column_name='dader_id') THEN
        ALTER TABLE scenarios RENAME COLUMN dader_id TO persoon_id;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.columns 
               WHERE table_name='scenarios' AND column_name='verhaal') THEN
        ALTER TABLE scenarios RENAME COLUMN verhaal TO beschrijving;
    END IF;
END $$;

-- Add naam column if not exists
ALTER TABLE scenarios
ADD COLUMN IF NOT EXISTS naam VARCHAR(255);

-- 2. Add answer tracking columns to games table
ALTER TABLE games
ADD COLUMN IF NOT EXISTS persoon_answer VARCHAR(100),
ADD COLUMN IF NOT EXISTS wapen_answer VARCHAR(100),
ADD COLUMN IF NOT EXISTS locatie_answer VARCHAR(100);

-- 3. Add YES/NO special codes
INSERT INTO special_nfc_codes (code_type, nfc_code, description) VALUES
('YES', 'TEMP_NFC_YES', 'Standbeheerder bevestiging - JA'),
('NO', 'TEMP_NFC_NO', 'Standbeheerder bevestiging - NEE')
ON CONFLICT (code_type) DO NOTHING;

-- 4. Delete old games referencing old scenarios (must happen before deleting scenarios)
DELETE FROM games WHERE scenario_id IN (1, 2, 3);

-- 5. Delete old test scenarios with wrong structure
DELETE FROM scenarios WHERE id IN (1, 2, 3);

-- 6. Insert corrected test scenario
INSERT INTO scenarios (naam, persoon_id, wapen_id, locatie_id, beschrijving, active) VALUES
(
    'Q3 Budget Crisis',
    2, -- Financial Controller
    5, -- Budgetten Niet Geüpdatet  
    1, -- OneDrive
    'Het was eind Q3 en de Financial Controller moest snel de nieuwe Q4 budgetten uploaden. In de haast plaatste ze het Excel bestand in haar persoonlijke OneDrive folder in plaats van de gedeelde locatie. De refresh draaide nog op het oude bestand.',
    false
);

-- 7. Reset all active scenarios
UPDATE scenarios
SET active = false, started_at = null
WHERE active = true;

-- 8. Mark remaining incomplete games as aborted
UPDATE games
SET aborted = true, end_time = NOW()
WHERE completed = false AND aborted = false;

-- 9. Add index for faster lookups
CREATE INDEX IF NOT EXISTS idx_games_answers ON games(persoon_answer, wapen_answer, locatie_answer);

-- Done! Flask app should work now
SELECT 'Database fixed! You can now start playing.' AS status;
