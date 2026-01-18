-- =============================================
-- ADD ARCHIVE FLAG TO SCENARIOS TABLE
-- =============================================

-- Voeg archive_flag kolom toe aan scenarios tabel
ALTER TABLE scenarios 
ADD COLUMN IF NOT EXISTS archive_flag INTEGER DEFAULT 1;

-- Zet alle bestaande scenarios op archived (1)
UPDATE scenarios 
SET archive_flag = 1;

-- Check resultaat
SELECT id, naam, archive_flag 
FROM scenarios 
ORDER BY id;

-- =============================================
-- UITLEG:
-- =============================================
-- archive_flag = 0 : Actief scenario (kan geselecteerd worden in game)
-- archive_flag = 1 : Gearchiveerd scenario (wordt overgeslagen)
--
-- Nu kun je handmatig een paar scenarios op 0 zetten om te testen:
-- UPDATE scenarios SET archive_flag = 0 WHERE id IN (9, 10, 12);
