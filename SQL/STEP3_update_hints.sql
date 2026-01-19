-- Stap 3: Update hints naar Database Beheerder (vrouw)

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
SELECT agent_id, LEFT(hint_context, 80) as preview 
FROM scenario_hints 
WHERE scenario_id = 26 
ORDER BY agent_id;
