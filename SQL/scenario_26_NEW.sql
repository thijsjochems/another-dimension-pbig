-- =============================================
-- SCENARIO 26: De Sales Kickoff Chaos (NIEUW)
-- =============================================

-- BASIS:
-- Dubbele records in FACT_Sales door haastige import eind jaar
-- Admin + Dubbele Records + Database (FACT table)

-- CONCEPT:
-- Laatste werkdag voor Sales Kickoff
-- Admin krijgt laatste sales transacties van december
-- Moet in FACT_Sales voor dashboard
-- Normaal proces: check for duplicates, then insert
-- Maar haast! Nieuwjaarsborrel!
-- Admin: APPEND zonder check
-- Transacties van 28-31 december komen dubbel binnen
-- Database Beheerder had al een batch gedraaid (backup proces)
-- Admin wist dat niet, draaide zelfde batch nogmaals
-- Nu: laatste 4 dagen december transacties DUBBEL in FACT table
-- Sales Kickoff: "Record breaking december!"
-- Finance later: bank statement klopt niet

-- PERSONEN: Admin (haastige FACT import)
-- WAPEN: Dubbele Records (in FACT table!)
-- LOCATIE: Database

-- First ensure Admin persoon exists
INSERT INTO personen (id, naam, nfc_code, beschrijving)
VALUES (
  4,
  'Admin',
  'TEMP_NFC_PERSON_04',
  'Verantwoordelijk voor database administratie, user management en data imports. Werkt onder druk tijdens jaar-einde processen.'
)
ON CONFLICT (id) DO NOTHING;

-- First check if scenario 26 exists, if so update it, otherwise insert
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM scenarios WHERE id = 26) THEN
    UPDATE scenarios SET
      naam = 'De Sales Kickoff Chaos',
      persoon_id = 4,
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
      4,
      3,
      3,
      'Donderdag 31 december, 16:00. Admin moest laatste sales transacties van december importeren in FACT_Sales. Product Manager belde: "Sales Kickoff is maandag, die cijfers moeten kloppen!" Excel met 2.847 transacties van 28-31 december. Admin opende SQL Management Studio. Normaal checkt Database Beheerder altijd op duplicates voor import. Maar die was al weg (voetbaltraining). Admin dacht: ach, wel goed komen. INSERT INTO FACT_Sales FROM staging. 2847 rows inserted. Klaar! 16:45 rennen naar borrel. Maar: Database Beheerder had diezelfde ochtend al een backup import gedraaid - "voor de zekerheid, mocht er iets mis gaan". Admin wist dat niet. Nu stonden transacties van 28-31 december DUBBEL in FACT_Sales. Elke order van die dagen telde 2x. Sales Kickoff maandag: "Record breaking december! 4.2M in laatste week!" Management euforisch. Donderdag belt Finance: "Bank statement zegt 2.1M, dashboard zegt 4.2M..."',
      0
    );
  END IF;
END $$;

-- =============================================
-- AGENT HINTS - EMOTIONEEL EN REALISTISCH
-- =============================================

-- SCHOONMAKER
-- Wat zag Schoonmaker?
-- - Admin haastig typen, 31 december
-- - Hoorde: Database Beheerder al weg (voetbal)
-- - Zag haar SQL query draaien: INSERT INTO FACT_Sales
-- - Computer scherm: "2847 rows inserted"
-- - 16:45 wegrennen naar borrel

INSERT INTO scenario_hints (scenario_id, agent_id, hint_context, created_at)
VALUES (
  26,
  1, -- Schoonmaker
  'Die laatste werkdag, 31 december. Admin zat te stressen achter haar scherm. Ik hoorde haar mompelen: "Database Beheerder al weg? Moet dit nog doen!" Ze draaide een SQL query - zag "INSERT INTO FACT_Sales" op haar scherm. Melding: "2847 rows inserted successfully". Om kwart voor vijf wegrennen richting borrel. Computer nog aan. Leek haastig werk, maar ja, laatste werkdag he.',
  NOW()
);

-- RECEPTIONIST
-- Wat zag Receptionist?
-- - Database Beheerder vertrok vroeg (voetbal om 17:30)
-- - Admin vroeg: "Is Database Beheerder nog?" - Nee, al weg
-- - Product Manager belde: December cijfers MOETEN kloppen
-- - Sales Kickoff maandag: iedereen euforisch
-- - Donderdag: Finance kwam langs, looked pissed

INSERT INTO scenario_hints (scenario_id, agent_id, hint_context, created_at)
VALUES (
  26,
  2, -- Receptionist  
  'Laatste werkdag was chaos. Database Beheerder ging vroeg - voetbal om half zes. Admin kwam vragen: "Is Database Beheerder nog?" Nee, al weg. Ze zuchtte. Product Manager had gebeld over december cijfers die absoluut moesten kloppen voor Sales Kickoff. Maandag kwam iedereen euforisch terug: "Record breaking december!" Donderdag kwam Finance binnen. Zag er pissed uit. "We moeten praten over die cijfers."',
  NOW()
);

-- STAGIAIR  
-- Wat zag Stagiair?
-- - Admin in SQL Management Studio
-- - Zag FACT_Sales tabel en staging table
-- - "2847 rows" - stagiair dacht: is dat niet al gedaan?
-- - Admin: "Database Beheerder is weg, moet ik doen"
-- - Stagiair wist dat DBB 's ochtends backup import deed

INSERT INTO scenario_hints (scenario_id, agent_id, hint_context, created_at)
VALUES (
  26,
  3, -- Stagiair
  'Ik zag Admin die middag in SQL Management Studio. Ze had FACT_Sales open en een staging tabel. Melding kwam: "2847 rows inserted". Ik dacht: wacht, heeft Database Beheerder dat vanochtend niet al gedaan? Hij doet altijd een backup import eind maand. Ik vroeg niks - zij is admin, zij weet wat ze doet. Maar nu ik erover nadenk...',
  NOW()
);

-- =============================================
-- WAPEN 3 (Dubbele Records) BESTAAT AL
-- =============================================
-- GEEN INSERT NODIG - wapen_id = 3 is al in database

-- =============================================
-- VERIFICATIE
-- =============================================

SELECT id, naam, persoon_id, wapen_id, locatie_id, archive_flag 
FROM scenarios WHERE id = 26;

SELECT 
  sh.id,
  a.naam as agent,
  LEFT(sh.hint_context, 100) as hint_preview
FROM scenario_hints sh
JOIN agents a ON sh.agent_id = a.id
WHERE sh.scenario_id = 26
ORDER BY sh.agent_id;

SELECT * FROM wapens WHERE naam = 'Dubbele Records';
