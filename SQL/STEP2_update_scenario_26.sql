-- Stap 2: Update scenario 26
-- VERVANG XXX met het ID dat stap 1 je gaf!

UPDATE scenarios 
SET 
  beschrijving = 'Donderdag 31 december, 16:00. Database Beheerder moest laatste sales transacties van december importeren in FACT_Sales. Product Manager belde: "Sales Kickoff is maandag, die cijfers moeten kloppen!" Excel met 2.847 transacties van 28-31 december. Database Beheerder opende SQL Management Studio. Ze was moe, wilde naar huis. Geen tijd voor duplicate check. INSERT INTO FACT_Sales FROM staging. 2847 rows inserted. Klaar! 16:45 wegrennen. Maar: ze had diezelfde ochtend al een backup import gedraaid - "voor de zekerheid, mocht er iets mis gaan". Was het vergeten. Nu stonden transacties van 28-31 december DUBBEL in FACT_Sales. Elke order van die dagen telde 2x. Sales Kickoff maandag: "Record breaking december! 4.2M in laatste week!" Management euforisch. Donderdag belt Financial Controller: "Bank statement zegt 2.1M, dashboard zegt 4.2M..."',
  locatie_id = XXX  -- VERVANG XXX!
WHERE id = 26;

-- Verificatie
SELECT * FROM scenarios WHERE id = 26;
