-- =============================================
-- CLEANUP COMPLEET: Behoud alleen scenarios 9, 12 en 26
-- Plus scenario 26 toevoegen met juiste foreign keys
-- =============================================

-- STAP 1: Verwijder oude data
-- =============================================

-- Eerst: Verwijder games die verwijzen naar scenarios die we gaan deleten
DELETE FROM games
WHERE scenario_id NOT IN (9, 12, 26);

-- Dan: Verwijder chat_messages die bij oude games horen (optioneel maar scheelt ruimte)
DELETE FROM chat_messages
WHERE game_id NOT IN (SELECT id FROM games);

-- Verwijder alle scenario_hints BEHALVE voor scenario 9, 12 en 26
DELETE FROM scenario_hints 
WHERE scenario_id NOT IN (9, 12, 26);

-- Verwijder alle scenarios BEHALVE 9, 12 en 26
DELETE FROM scenarios 
WHERE id NOT IN (9, 12, 26);

-- Verwijder oude chat_messages (optioneel - kan veel zijn)
-- DELETE FROM chat_messages 
-- WHERE created_at < NOW() - INTERVAL '7 days';

-- STAP 2: Scenario 26 toevoegen
-- =============================================

-- Ensure Financial Controller persoon exists
INSERT INTO personen (id, naam, nfc_code, beschrijving)
VALUES (
  4,
  'Financial Controller',
  'TEMP_NFC_PERSON_04',
  'Verantwoordelijk voor financiële rapportage en budget controle. Nauwkeurig, kritisch, gaat niet akkoord met cijfers die niet kloppen. Werkt nauw samen met sales en finance teams.'
)
ON CONFLICT (id) DO NOTHING;

-- Ensure Database locatie exists
INSERT INTO locaties (id, naam, nfc_code, beschrijving)
VALUES (
  3,
  'Database',
  'TEMP_NFC_LOCATION_03',
  'De database waar alle data wordt opgeslagen. SQL Server, tabellen, queries, imports. Hier gebeurt de magie - en soms gaat het mis.'
)
ON CONFLICT (id) DO NOTHING;

-- Insert or update scenario 26
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM scenarios WHERE id = 26) THEN
    UPDATE scenarios SET
      naam = 'De Sales Kickoff Chaos',
      persoon_id = 3,
      wapen_id = 3,
      locatie_id = 3,
      beschrijving = 'Donderdag 31 december, 16:00. Admin moest laatste sales transacties van december importeren in FACT_Sales. Product Manager belde: "Sales Kickoff is maandag, die cijfers moeten kloppen!" Excel met 2.847 transacties van 28-31 december. Admin opende SQL Management Studio. Normaal checkt Database Beheerder altijd op duplicates voor import. Maar die was al weg (voetbaltraining). Admin dacht: ach, wel goed komen. INSERT INTO FACT_Sales FROM staging. 2847 rows inserted. Klaar! 16:45 rennen naar borrel. Maar: Database Beheerder had diezelfde ochtend al een backup import gedraaid - "voor de zekerheid, mocht er iets mis gaan". Admin wist dat niet. Nu stonden transacties van 28-31 december DUBBEL in FACT_Sales. Elke order van die dagen telde 2x. Sales Kickoff maandag: "Record breaking december! 4.2M in laatste week!" Management euforisch. Donderdag belt Finance: "Bank statement zegt 2.1M, dashboard zegt 4.2M..."',
      archive_flag = 0
    WHERE id = 26;
  ELSE
    INSERT INTO scenarios (
      id,
      naam, 
      persoon_id, 
      wapen_id, 
      locatie_id, 
      beschrijving,
      archive_flag
    ) VALUES (
      26,
      'De Sales Kickoff Chaos',
      3,
      3,
      3,
      'Donderdag 31 december, 16:00. Database Beheerder moest laatste sales transactiess transacties van december importeren in FACT_Sales. Product Manager belde: "Sales Kickoff is maandag, die cijfers moeten kloppen!" Excel met 2.847 transacties van 28-31 december. Database Beheerder opende SQL Management Studio. Hij was moe, wilde naar voetbal. Geen tijd voor duplicate check. INSERT INTO FACT_Sales FROM staging. 2847 rows inserted. Klaar! 16:45 wegrennen. Maar: hij had diezelfde ochtend al een backup import gedraaid - "voor de zekerheid, mocht er iets mis gaan". Was het vergeten. Nu stonden transacties van 28-31 december DUBBEL in FACT_Sales. Elke order van die dagen telde 2x. Sales Kickoff maandag: "Record breaking december! 4.2M in laatste week!" Management euforisch. Donderdag belt Financial Controller: "Bank statement zegt 2.1M, dashboard zegt 4.2M..."',
      0
    );
  END IF;
END $$;

-- STAP 3: Agent hints voor scenario 26
-- =============================================

-- SCHOONMAKER
INSERT INTO scenario_hints (scenario_id, agent_id, hint_context, created_at)
VALUES (
  26,
  1,
  'Die laatste werkdag, 31 december. Database Beheerder zat te stressen achter zijn scherm. Ik hoorde hem mompelen: "Shit, moet dit nog. Voetbal om half zes!" Hij draaide een SQL query - zag "INSERT INTO FACT_Sales" op zijn scherm. Melding: "2847 rows inserted successfully". Om kwart voor vijf wegrennen. Computer nog aan. Leek haastig werk, maar ja, laatste werkdag he.',
  NOW()
)
ON CONFLICT DO NOTHING;

-- RECEPTIONIST
INSERT INTO scenario_hints (scenario_id, agent_id, hint_context, created_at)
VALUES (
  26,
  2,
  'Laatste werkdag was chaos. Database Beheerder was gehaast - voetbal om half zes. Product Manager had gebeld over december cijfers die absoluut moesten kloppen voor Sales Kickoff. Zag Database Beheerder snel typen, wegrennen om kwart voor vijf. Maandag kwam iedereen euforisch terug: "Record breaking december!" Donderdag kwam Financial Controller binnen. Zag er pissed uit. "We moeten praten over die cijfers."',
  NOW()
)
ON CONFLICT DO NOTHING;

-- STAGIAIR
INSERT INTO scenario_hints (scenario_id, agent_id, hint_context, created_at)
VALUES (
  26,
  3,
  'Ik zag Database Beheerder die middag in SQL Management Studio. Hij had FACT_Sales open en een staging tabel. Melding kwam: "2847 rows inserted". Ik dacht: wacht, heeft hij dat vanochtend niet al gedaan? Hij doet altijd een backup import eind maand. Ik vroeg niks - hij weet wat hij doet. Maar nu ik erover nadenk...',
  NOW()
)
ON CONFLICT DO NOTHING;

-- STAP 4: Cleanup ongebruikte personen, wapens, locaties (OPTIONEEL)
-- =============================================

-- Eerst bekijken wat in gebruik is:
SELECT 'PERSONEN IN GEBRUIK:' as info;
SELECT DISTINCT p.id, p.naam 
FROM personen p
INNER JOIN scenarios s ON s.persoon_id = p.id
WHERE s.id IN (9, 12, 26)
ORDER BY p.id;

SELECT 'WAPENS IN GEBRUIK:' as info;
SELECT DISTINCT w.id, w.naam 
FROM wapens w
INNER JOIN scenarios s ON s.wapen_id = w.id
WHERE s.id IN (9, 12, 26)
ORDER BY w.id;

SELECT 'LOCATIES IN GEBRUIK:' as info;
SELECT DISTINCT l.id, l.naam 
FROM locaties l
INNER JOIN scenarios s ON s.locatie_id = l.id
WHERE s.id IN (9, 12, 26)
ORDER BY l.id;

-- Nu ongebruikte records verwijderen:
DELETE FROM personen 
WHERE id NOT IN (
  SELECT DISTINCT persoon_id FROM scenarios WHERE id IN (9, 12, 26)
);

DELETE FROM wapens 
WHERE id NOT IN (
  SELECT DISTINCT wapen_id FROM scenarios WHERE id IN (9, 12, 26)
);

DELETE FROM locaties 
WHERE id NOT IN (
  SELECT DISTINCT locatie_id FROM scenarios WHERE id IN (9, 12, 26)
);

-- =============================================
-- VERIFICATIE
-- =============================================

SELECT '=== ACTIEVE SCENARIOS ===' as info;
SELECT id, naam, persoon_id, wapen_id, locatie_id, archive_flag
FROM scenarios
WHERE id IN (9, 12, 26)
ORDER BY id;

SELECT '=== SCENARIO HINTS ===' as info;
SELECT 
  sh.scenario_id,
  a.naam as agent,
  LEFT(sh.hint_context, 80) as hint_preview
FROM scenario_hints sh
JOIN agents a ON sh.agent_id = a.id
WHERE sh.scenario_id IN (9, 12, 26)
ORDER BY sh.scenario_id, sh.agent_id;

SELECT '=== TOTALEN ===' as info;
SELECT 
  (SELECT COUNT(*) FROM scenarios) as total_scenarios,
  (SELECT COUNT(*) FROM scenario_hints) as total_hints,
  (SELECT COUNT(*) FROM personen) as total_personen,
  (SELECT COUNT(*) FROM wapens) as total_wapens,
  (SELECT COUNT(*) FROM locaties) as total_locaties;

SELECT '=== PERSONEN ===' as info;
SELECT id, naam, nfc_code FROM personen ORDER BY id;

SELECT '=== WAPENS ===' as info;
SELECT id, naam, nfc_code FROM wapens ORDER BY id;

SELECT '=== LOCATIES ===' as info;
SELECT id, naam, nfc_code FROM locaties ORDER BY id;
