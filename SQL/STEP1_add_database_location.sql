-- Stap 1: Voeg Database locatie toe
INSERT INTO locaties (naam, nfc_code, beschrijving)
VALUES (
  'Database',
  'TEMP_NFC_LOCATION_DATABASE',
  'De database waar alle data wordt opgeslagen. SQL Server, tabellen, queries, imports. Hier gebeurt de magie - en soms gaat het mis.'
)
RETURNING id;
