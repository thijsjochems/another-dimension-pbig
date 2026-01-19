-- =============================================
-- ADD: Financial Controller + Database locatie
-- =============================================

-- Add Financial Controller
INSERT INTO personen (id, naam, nfc_code, beschrijving)
VALUES (
  4,
  'Financial Controller',
  'TEMP_NFC_PERSON_04',
  'Verantwoordelijk voor financiële rapportage en budget controle. Nauwkeurig, kritisch, gaat niet akkoord met cijfers die niet kloppen. Werkt nauw samen met sales en finance teams.'
)
ON CONFLICT (id) DO NOTHING;

-- Add Database locatie
INSERT INTO locaties (id, naam, nfc_code, beschrijving)
VALUES (
  3,
  'Database',
  'TEMP_NFC_LOCATION_03',
  'De database waar alle data wordt opgeslagen. SQL Server, tabellen, queries, imports. Hier gebeurt de magie - en soms gaat het mis.'
)
ON CONFLICT (id) DO NOTHING;

-- Verify
SELECT 'Financial Controller added:' as info;
SELECT * FROM personen WHERE id = 4;

SELECT 'Database locatie added:' as info;
SELECT * FROM locaties WHERE id = 3;
