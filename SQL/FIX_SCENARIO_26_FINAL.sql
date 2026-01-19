-- =============================================
-- FIX SCENARIO 26 - Correcte beschrijving + Database locatie
-- =============================================

-- Stap 1: Voeg Database locatie toe (nieuwe ID)
INSERT INTO locaties (naam, nfc_code, beschrijving)
VALUES (
  'Database',
  'TEMP_NFC_LOCATION_DATABASE',
  'De database waar alle data wordt opgeslagen. SQL Server, tabellen, queries, imports. Hier gebeurt de magie - en soms gaat het mis.'
)
RETURNING id;

-- LET OP: Noteer het ID dat je terugkrijgt! Bijvoorbeeld id=5
-- Gebruik dat ID hieronder bij locatie_id

-- Stap 2: Update scenario 26 met correcte beschrijving EN locatie_id
-- VERVANG 5 hieronder met het ID dat je kreeg bij stap 1!
UPDATE scenarios 
SET 
  beschrijving = 'Donderdag 31 december, 16:00. Database Beheerder moest laatste sales transacties van december importeren in FACT_Sales. Product Manager belde: "Sales Kickoff is maandag, die cijfers moeten kloppen!" Excel met 2.847 transacties van 28-31 december. Database Beheerder opende SQL Management Studio. Hij was moe, wilde naar voetbal. Geen tijd voor duplicate check. INSERT INTO FACT_Sales FROM staging. 2847 rows inserted. Klaar! 16:45 wegrennen. Maar: hij had diezelfde ochtend al een backup import gedraaid - "voor de zekerheid, mocht er iets mis gaan". Was het vergeten. Nu stonden transacties van 28-31 december DUBBEL in FACT_Sales. Elke order van die dagen telde 2x. Sales Kickoff maandag: "Record breaking december! 4.2M in laatste week!" Management euforisch. Donderdag belt Financial Controller: "Bank statement zegt 2.1M, dashboard zegt 4.2M..."',
  locatie_id = 5  -- VERVANG 5 met het ID uit stap 1!
WHERE id = 26;

-- Stap 3: Update scenario hints - Database Beheerder in plaats van Admin
UPDATE scenario_hints
SET hint_context = 'Die laatste werkdag, 31 december. Database Beheerder zat te stressen achter zijn scherm. Ik hoorde hem mompelen: "Shit, moet dit nog. Voetbal om half zes!" Hij draaide een SQL query - zag "INSERT INTO FACT_Sales" op zijn scherm. Melding: "2847 rows inserted successfully". Om kwart voor vijf wegrennen. Computer nog aan. Leek haastig werk, maar ja, laatste werkdag he.'
WHERE scenario_id = 26 AND agent_id = 1;

UPDATE scenario_hints
SET hint_context = 'Laatste werkdag was chaos. Database Beheerder was gehaast - voetbal om half zes. Product Manager had gebeld over december cijfers die absoluut moesten kloppen voor Sales Kickoff. Zag Database Beheerder snel typen, wegrennen om kwart voor vijf. Maandag kwam iedereen euforisch terug: "Record breaking december!" Donderdag kwam Financial Controller binnen. Zag er pissed uit. "We moeten praten over die cijfers."'
WHERE scenario_id = 26 AND agent_id = 2;

UPDATE scenario_hints
SET hint_context = 'Ik zag Database Beheerder die middag in SQL Management Studio. Hij had FACT_Sales open en een staging tabel. Melding kwam: "2847 rows inserted". Ik dacht: wacht, heeft hij dat vanochtend niet al gedaan? Hij doet altijd een backup import eind maand. Ik vroeg niks - hij weet wat hij doet. Maar nu ik erover nadenk...'
WHERE scenario_id = 26 AND agent_id = 3;

-- Verificatie
SELECT 'SCENARIO 26 FIXED:' as info;
SELECT id, naam, persoon_id, wapen_id, locatie_id FROM scenarios WHERE id = 26;

SELECT 'DATABASE LOCATIE:' as info;
SELECT * FROM locaties WHERE naam = 'Database';

SELECT 'SCENARIO 26 HINTS:' as info;
SELECT agent_id, LEFT(hint_context, 80) FROM scenario_hints WHERE scenario_id = 26 ORDER BY agent_id;
