-- Nieuwe scenarios toevoegen aan Power BI Murder Mystery
-- Run dit in Supabase SQL Editor

-- Scenario 2: "De Persoonlijke Filter"
INSERT INTO scenarios (title, situation, description, realisme_score, weapon_id, suspect_id)
VALUES (
    'De Persoonlijke Filter',
    'Het management dashboard toont plotseling alleen Finance data. Sales, Operations en HR cijfers zijn volledig verdwenen. Totalen zijn veel te laag. Maar er is geen filter zichtbaar op het rapport. Waar is de rest van de data gebleven?',
    'De Financial Controller had net zijn Power BI training afgerond en was enthousiast. Hij kreeg edit-rechten op de workspace — "zodat je zelf kleine aanpassingen kunt doen." Hij wilde een slicer toevoegen om alleen zijn Finance afdeling te zien. De slicer werkte perfect. Maar het zag er "rommelig" uit op de pagina. Hij herinnerde zich iets van de training over een oogje in de Selection Pane. Klik — slicer onzichtbaar. Netjes! Wat hij niet doorhad: de slicer filtert nog steeds actief op "Finance." Nu zien ALLE 200 gebruikers alleen Finance data. Sales mist hun omzetcijfers, Operations mist hun KPI''s. En niemand kan de oorzaak vinden — want de slicer is onzichtbaar.',
    9,
    (SELECT id FROM weapons WHERE name = 'Hidden Slicer met Actieve Filter'),
    (SELECT id FROM suspects WHERE initials = 'FC')
);

-- Hints voor Scenario 2
INSERT INTO hints (scenario_id, character, hint_text, hint_order)
VALUES 
(
    (SELECT id FROM scenarios WHERE title = 'De Persoonlijke Filter'),
    'Schoonmaker',
    'Die Financial Controller was zo trots na die training. Zat ''s avonds nog op kantoor achter zijn laptop, zei tegen zichzelf: ''Kijk, dit kan ik nu zelf!'' Ik zag dat hij iets aan het klikken was met zo''n oogje-icoontje. Leek tevreden. Maar de volgende dag hoorde ik mensen klagen.',
    1
),
(
    (SELECT id FROM scenarios WHERE title = 'De Persoonlijke Filter'),
    'Receptionist',
    'Financial Controller vroeg vorige week of zijn edit-rechten al waren ingesteld. Was zo enthousiast! Vertelde iedereen dat hij nu zelf rapporten kon aanpassen. ''Hoef ik niet meer op de Developer te wachten,'' zei hij. Dag later belde de Sales Director: ''Waar zijn onze cijfers?!'' Ik heb echt geen verstand van Power Dinges, maar het klonk serieus.',
    2
),
(
    (SELECT id FROM scenarios WHERE title = 'De Persoonlijke Filter'),
    'Stagiair',
    'Ik keek in het rapport en alles toonde alleen Finance data. Raar. Geen zichtbare filter. Maar toen ik de Selection Pane opende... stond er een slicer die ik niet op de pagina zag! Het oogje stond dicht — hidden dus. En die slicer stond op ''Finance'' gefilterd. Iemand heeft die slicer verborgen maar niet verwijderd. Classic.',
    3
);

-- Scenario 3: "De Onzichtbare Duplicaten"
INSERT INTO scenarios (title, situation, description, realisme_score, weapon_id, suspect_id)
VALUES (
    'De Onzichtbare Duplicaten',
    'De omzetcijfers voor bepaalde productcategorieën zijn veel te hoog. Niet alles — alleen Elektronica en Accessoires tonen onrealistisch hoge bedragen. Andere categorieën kloppen wel. Is er een dataprobleem of een modelprobleem?',
    'De Power BI Developer koppelde een nieuwe productmaster uit het ERP systeem. De Product-dimensietabel bleek duplicaten te bevatten: producten die in meerdere magazijnen voorkwamen hadden aparte rijen (zelfde ProductID, verschillende WarehouseCode). Ze merkte het niet op. Power BI gaf een waarschuwing over een many-to-many relatie — ze klikte het weg. Nu vermenigvuldigt elke sale met het aantal magazijnen dat het product voert. Een product dat in 3 magazijnen ligt telt 3x mee in de omzet. Elektronica (4 magazijnen) toont 4x de werkelijke omzet. Kantoorartikelen (1 magazijn) klopt gewoon. Het subtiele eraan: het totaal klopt ook niet, maar het valt minder op omdat het een mix is van correcte en incorrecte categorieën.',
    9,
    (SELECT id FROM weapons WHERE name = 'Duplicate Dimension Entries'),
    (SELECT id FROM suspects WHERE initials = 'PD')
);

-- Hints voor Scenario 3
INSERT INTO hints (scenario_id, character, hint_text, hint_order)
VALUES 
(
    (SELECT id FROM scenarios WHERE title = 'De Onzichtbare Duplicaten'),
    'Schoonmaker',
    'Die Developer had een drukke week. Zag haar scherm — zo''n diagram met kastjes en lijntjes. Er stond een geel driehoekje bij een van de lijnen. Weet niet wat dat betekent, maar het leek een waarschuwing. Ze klikte het weg en ging door. Haast, altijd haast.',
    1
),
(
    (SELECT id FROM scenarios WHERE title = 'De Onzichtbare Duplicaten'),
    'Receptionist',
    'De regiomanager van Noord belde: ''Onze Elektronica-omzet is belachelijk hoog. Dat kan niet kloppen.'' Maar de Product Manager zei: ''Kantoorartikelen klopt gewoon.'' Raar toch — sommige categorieën wel goed, andere niet? De Power BI Developer had net een nieuwe databron aangesloten, hoorde ik.',
    2
),
(
    (SELECT id FROM scenarios WHERE title = 'De Onzichtbare Duplicaten'),
    'Stagiair',
    'Ik was de Product-tabel aan het bekijken in het model. En toen viel me iets op: product PRD-2847 stond er DRIE keer in! Zelfde product, maar verschillende warehouse codes. En de relatie tussen Sales en Product had zo''n dubbele pijl — many-to-many. Dat is toch niet goed? Als een product 3 keer in de dimensie staat, wordt elke sale toch 3 keer geteld?',
    3
);

-- Scenario 4: "De Stille ETL"
INSERT INTO scenarios (title, situation, description, realisme_score, weapon_id, suspect_id)
VALUES (
    'De Stille ETL',
    'Het budget dashboard toont al drie maanden dezelfde budgetcijfers. Q2 budget zou allang verwerkt moeten zijn, maar het rapport toont nog steeds Q1 getallen. De CFO vraagt: "Waarom is het budget niet bijgewerkt?" Niemand heeft een antwoord.',
    'De Database Beheerder beheert een nachtelijke ETL-job die budgetdata laadt vanuit een CSV-bestand dat Finance maandelijks aanlevert in een specifieke folder op de server. Het bestand moet BUDGET_2026_Q2.csv heten — exact die naamconventie, want het SSIS-package zoekt op pattern BUDGET_*.csv. Maar het Finance team kreeg een nieuw template van de CFO en leverde het bestand aan als Budget Forecast Q2-2026.csv. De ETL-job vond geen match, gaf geen error (het logde netjes "0 new files found"), en de budget-tabel in de database bleef staan met Q1 data. Het Power BI rapport refreshte elke nacht braaf — maar de brondata was al maanden niet bijgewerkt. Niemand checkt ooit de ETL-logs.',
    8.5,
    (SELECT id FROM weapons WHERE name = 'Stale Database Connection'),
    (SELECT id FROM suspects WHERE initials = 'DB')
);

-- Hints voor Scenario 4
INSERT INTO hints (scenario_id, character, hint_text, hint_order)
VALUES 
(
    (SELECT id FROM scenarios WHERE title = 'De Stille ETL'),
    'Schoonmaker',
    'Die Database Beheerder is altijd zo precies met haar mappen en bestanden. Alles op volgorde, alles met codes. Laatst hoorde ik haar mopperen tegen iemand van Finance: ''Jullie moeten de juiste bestandsnaam gebruiken!'' Maar volgens mij luisterde niemand.',
    1
),
(
    (SELECT id FROM scenarios WHERE title = 'De Stille ETL'),
    'Receptionist',
    'Iemand van Finance bracht vorige maand een USB-stick langs voor de Database Beheerder. ''Hier is het budget bestand,'' zei ze. Maar de Database Beheerder was die dag op een seminar. Ik heb de stick op haar bureau gelegd. Geen idee of ze het ooit heeft gezien. Oh, en de CFO had een nieuwe template ingevoerd voor alle budget documenten. Mooier design, andere bestandsnamen.',
    2
),
(
    (SELECT id FROM scenarios WHERE title = 'De Stille ETL'),
    'Stagiair',
    'Ik moest de ETL-logs checken voor een ander project en zag iets raars. Die budget-job draait elke nacht, maar al drie maanden staat er ''0 new files found.'' Elke nacht. Geen error, gewoon niks geladen. En in de folder op de server staat een bestand, maar het heet anders dan het patroon dat het SSIS-package zoekt. Finance heeft de bestandsnaam veranderd, maar niemand heeft het de Database Beheerder verteld.',
    3
);

-- Verificatie
SELECT 
    s.id,
    s.title,
    s.realisme_score,
    w.name as weapon,
    su.initials as suspect,
    COUNT(h.id) as aantal_hints
FROM scenarios s
LEFT JOIN weapons w ON s.weapon_id = w.id
LEFT JOIN suspects su ON s.suspect_id = su.id
LEFT JOIN hints h ON s.id = h.scenario_id
WHERE s.title IN ('De Persoonlijke Filter', 'De Onzichtbare Duplicaten', 'De Stille ETL')
GROUP BY s.id, s.title, s.realisme_score, w.name, su.initials
ORDER BY s.id;
