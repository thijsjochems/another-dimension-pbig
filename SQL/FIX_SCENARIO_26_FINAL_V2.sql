-- =============================================
-- FIX SCENARIO 26 COMPLEET
-- Database locatie bestaat al met ID 7
-- =============================================

-- Update scenario 26 met correcte beschrijving + locatie_id 7
UPDATE scenarios 
SET 
  beschrijving = 'Donderdag 31 december, 16:00. Database Beheerder moest laatste sales transacties van december importeren in FACT_Sales. Product Manager belde: "Sales Kickoff is maandag, die cijfers moeten kloppen!" Excel met 2.847 transacties van 28-31 december. Database Beheerder opende SQL Management Studio. Ze was moe, wilde naar huis. Geen tijd voor duplicate check. INSERT INTO FACT_Sales FROM staging. 2847 rows inserted. Klaar! 16:45 wegrennen. Maar: ze had diezelfde ochtend al een backup import gedraaid - "voor de zekerheid, mocht er iets mis gaan". Was het vergeten. Nu stonden transacties van 28-31 december DUBBEL in FACT_Sales. Elke order van die dagen telde 2x. Sales Kickoff maandag: "Record breaking december! 4.2M in laatste week!" Management euforisch. Donderdag belt Financial Controller: "Bank statement zegt 2.1M, dashboard zegt 4.2M..."',
  locatie_id = 7
WHERE id = 26;

-- Update hints naar Database Beheerder (vrouw)
UPDATE scenario_hints
SET hint_context = 'Die laatste werkdag, 31 december. Database Beheerder zat te stressen achter haar scherm. Ik hoorde haar mompelen: "Shit, moet dit nog!" Ze draaide een SQL query - zag "INSERT INTO FACT_Sales" op haar scherm. Melding: "2847 rows inserted successfully". Om kwart voor vijf wegrennen. Computer nog aan. Leek haastig werk, maar ja, laatste werkdag he.'
WHERE scenario_id = 26 AND agent_id = 1;

UPDATE scenario_hints
SET hint_context = 'Laatste werkdag was chaos. Database Beheerder was gehaast. Product Manager had gebeld over december cijfers die absoluut moesten kloppen voor Sales Kickoff. Zag Database Beheerder snel typen, wegrennen om kwart voor vijf. Maandag kwam iedereen euforisch terug: "Record breaking december!" Donderdag kwam Financial Controller binnen. Zag er pissed uit. "We moeten praten over die cijfers."'
WHERE scenario_id = 26 AND agent_id = 2;

UPDATE scenario_hints
SET hint_context = 'Ik zag Database Beheerder die middag in SQL Management Studio. Ze had FACT_Sales open en een staging tabel. Melding kwam: "2847 rows inserted". Ik dacht: wacht, heeft ze dat vanochtend niet al gedaan? Ze doet altijd een backup import eind maand. Ik vroeg niks - ze weet wat ze doet. Maar nu ik erover nadenk...'
WHERE scenario_id = 26 AND agent_id = 3;

-- Verificatie
SELECT 'SCENARIO 26:' as info;
SELECT id, naam, persoon_id, wapen_id, locatie_id FROM scenarios WHERE id = 26;

SELECT 'HINTS:' as info;
SELECT agent_id, LEFT(hint_context, 80) as preview FROM scenario_hints WHERE scenario_id = 26 ORDER BY agent_id;
