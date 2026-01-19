-- Forceer INSERT van Database locatie zonder ON CONFLICT
INSERT INTO locaties (id, naam, nfc_code, beschrijving)
VALUES (
  3,
  'Database',
  'TEMP_NFC_LOCATION_03',
  'De database waar alle data wordt opgeslagen. SQL Server, tabellen, queries, imports. Hier gebeurt de magie - en soms gaat het mis.'
);

-- Check result
SELECT * FROM locaties WHERE id = 3;
