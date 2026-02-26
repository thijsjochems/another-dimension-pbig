-- =============================================
-- 3 NIEUWE SCENARIOS MET BESTAANDE PERSONEN/WAPENS/LOCATIES
-- Run dit in Supabase SQL Editor
-- =============================================

-- Reset sequence naar juiste positie (na ID 32)
SELECT setval('scenarios_id_seq', (SELECT MAX(id) FROM scenarios));

-- SCENARIO 1: De Persoonlijke Filter
INSERT INTO scenarios (
    persoon_id,    -- Financial Controller (ID 4)
    wapen_id,      -- Hidden Slicer (ID 2)
    locatie_id,    -- Report View - Selection Pane (ID 4)
    naam,
    situatie_beschrijving,
    beschrijving,
    archive_flag
) VALUES (
    4,
    2,
    4,
    'De Persoonlijke Filter',
    'Een collega vraagt aan Financial Controller Franka om even snel een cijfer te checken in het sales dashboard. Ze opent het rapport, zet een slicer op haar afdeling (Marketing) en ziet dat de cijfers niet kloppen. Ze roept meteen de Data Analyst erbij. Die bekijkt het rapport, checkt de measures, verifieert de brondata - alles lijkt correct. Maar Sales blijft klagen dat alleen hun afdeling wordt getoond. Ze hadden het rapport ge-shared met "Can Edit" rechten, omdat Franka vaak snel dingen moet kunnen checken. Ze vergat dat hidden visuals nog steeds actief blijven, ook als je ze niet ziet.',
    'FC kreeg "Can Edit" rechten om snel aanpassingen te kunnen maken. Ze gebruikte een slicer, verstopte hem (Selection Pane → Hide) en vergat hem uit te zetten. Nu toont IEDER rapport alleen Marketing cijfers, voor iedereen. Iedereen denkt dat er iets mis is met de data of het model. In werkelijkheid staat er gewoon een onzichtbare filter actief. Dit duurt maanden totdat iemand per toeval de Selection Pane opent en de hidden slicer ziet. Personal filter blijft gewoon actief.',
    0
);

-- Haal het ID op van het zojuist aangemaakte scenario
DO $$
DECLARE
    new_scenario_id INTEGER;
BEGIN
    SELECT id INTO new_scenario_id FROM scenarios 
    WHERE naam = 'De Persoonlijke Filter' 
    ORDER BY id DESC LIMIT 1;
    
    -- Voeg hints toe voor scenario 1
    INSERT INTO scenario_hints (scenario_id, agent_id, hint_context) VALUES
    -- Schoonmaker (Agent 1)
    (new_scenario_id, 1, 
     'Jij hebt Franka zien werken aan het rapport. Ze zat geconcentreerd in de Selection Pane te klikken - iets met visuals verbergen. Ze mompelde iets over "even snel checken zonder rommel". Een paar minuten later stond ze op en liep weg. Alsof ze het was vergeten.'),
    
    -- Receptionist (Agent 2)
    (new_scenario_id, 2,
     'Franka belde me na die dag - ze klonk gestrest. "Hoe zet je ook alweer een filter uit in Power BI?" vroeg ze. Ik wist het niet, ik ken dat programma niet zo goed. Ze zei dat ze dacht dat ze iets per ongeluk aan had laten staan, maar ze kon het nergens vinden in het rapport. Ze leek het daarna te vergeten en hing op.'),
    
    -- Stagiair (Agent 3)
    (new_scenario_id, 3,
     'Ik hielp Franka die dag met een andere klus. Ze had haar scherm open en ik zag Power BI. Ik vroeg: "Wat doe je?" Ze zei: "Ik verberg deze slicer even, anders wordt het te druk op de pagina." Ik zag haar de slicer selecteren en ergens op klikken. Daarna sloot ze het rapport. Niet gesaved, volgens mij. Ze zei dat het toch automatisch wordt opgeslagen in de Service.');
END $$;


-- SCENARIO 2: De Onzichtbare Duplicaten
INSERT INTO scenarios (
    persoon_id,    -- Power BI Developer (ID 1)
    wapen_id,      -- Dubbele Records (ID 3)
    locatie_id,    -- Semantisch Model (ID 3)
    naam,
    situatie_beschrijving,
    beschrijving,
    archive_flag
) VALUES (
    1,
    3,
    3,
    'De Onzichtbare Duplicaten',
    'De Power BI Developer krijgt de opdracht om een nieuwe dimensietabel toe te voegen: Product Categories. Hij importeert de tabel uit de database, maakt een relatie met de Sales tabel en klikt op "Apply". Power BI geeft een waarschuwing: "This relationship may result in duplicate values." Hij denkt: "Ja ja, dat zegt-ie altijd" en klikt gewoon op OK. Het rapport ziet er prima uit. Totdat Finance belt: "Sales zijn X3 zo hoog als vorige maand - wat is er gebeurd?!" De Developer checkt de measures, de DAX, de brondata - alles lijkt correct. Maar niemand kijkt naar de relatie. Die is many-to-many. Door duplicate category namen in de dimension tabel worden salesrecords nu 3x geteld.',
    'PBI Developer heeft een many-to-many relatie gemaakt zonder de waarschuwing serieus te nemen. De Product Categories tabel bevatte duplicates (bijv. "Electronics" kwam 3x voor met verschillende IDs). Door de many-to-many relatie worden sales records nu gekoppeld aan ALLE matches, waardoor alles x3 wordt geteld. Hij had moeten deduplicaten, of in ieder geval moeten checken waarom Power BI die warning gaf. Dit is realistisch: developers zijn soms gewend aan false positive warnings en klikken alles weg. En many-to-many relationships zijn notorisch verwarrend, zelfs voor ervaren gebruikers.',
    0
);

DO $$
DECLARE
    new_scenario_id INTEGER;
BEGIN
    SELECT id INTO new_scenario_id FROM scenarios 
    WHERE naam = 'De Onzichtbare Duplicaten' 
    ORDER BY id DESC LIMIT 1;
    
    -- Voeg hints toe voor scenario 2
    INSERT INTO scenario_hints (scenario_id, agent_id, hint_context) VALUES
    -- Schoonmaker (Agent 1)
    (new_scenario_id, 1,
     'Ik zag de Developer aan het werk. Hij importeerde nieuwe data - iets met product categories. Power BI gaf een pop-up met een waarschuwing. Hij las het niet eens, klikte gewoon weg. "Always these annoying warnings," hoorde ik hem mompelen. Hij keek tevreden naar het resultaat en sloot zijn laptop.'),
    
    -- Receptionist (Agent 2)
    (new_scenario_id, 2,
     'Finance belde me in paniek - de sales cijfers waren ineens X3 zo hoog. Ik verbond hen door met de Developer. Hij zei dat hij niks had gewijzigd aan de measures of de data. Alleen een nieuwe tabel toegevoegd. Hij klonk zelfverzekerd. "Als de brondata goed is, kan het niet aan mijn model liggen," zei hij. Hij hing op voordat ik iets kon vragen.'),
    
    -- Stagiair (Agent 3)
    (new_scenario_id, 3,
     'Ik heb de Developer die dag geholpen met een import. Hij liet me zien hoe je relaties maakt in het Model View. Ik zag dat Power BI een waarschuwing gaf: "This relationship may result in duplicate values." Ik vroeg: "Is dat erg?" Hij zei: "Nah, Power BI is altijd overdreven voorzichtig. Als je weet wat je doet, kan je die waarschuwingen negeren." Hij klikte op OK en ging door.');
END $$;


-- SCENARIO 3: De Stille ETL
INSERT INTO scenarios (
    persoon_id,    -- Database Beheerder (ID 3)
    wapen_id,      -- Kolomnaam Gewijzigd (ID 6) - past voor ETL filename mismatch
    locatie_id,    -- Database (ID 7)
    naam,
    situatie_beschrijving,
    beschrijving,
    archive_flag
) VALUES (
    3,
    6,
    7,
    'De Stille ETL',
    'De Database Beheerder heeft een ETL job die elke nacht draait om sales data te importeren. Het script heet "import_sales_2024.py" en leest een CSV file genaamd "SalesData_2024.csv" van een netwerk drive. In januari 2025 start het nieuwe jaar. Het sales systeem genereert nu "SalesData_2025.csv". De ETL job blijft zoeken naar "SalesData_2024.csv", vindt hem niet, en faalt. Maar er is geen error handling. De job logt alleen "File not found" in een obscure log file die niemand leest. Resultaat: het dashboard toont nog steeds December 2024 cijfers. Maandenlang. Niemand merkt het op omdat het rapport gewoon blijft werken - het toont alleen oude data. Pas in Maart vraagt iemand: "Waarom stopt ons dashboard bij December?!" De Database Beheerder checkt en ontdekt dat de ETL al 3 maanden faalt. Silent failure.',
    'DB admin had een hardcoded filename in het ETL script. Geen wildcard, geen dynamische datum, geen error notifications. File not found = silent failure. Het Power BI rapport blijft gewoon oude data tonen zonder enige indicatie dat de refresh niet werkt. Dit is zeer realistisch: veel organisaties hebben legacy ETL scripts zonder adequate monitoring. Totdat iemand opmerkt dat de laatste datum "raar oud" is, merkt niemand het op. En dan blijkt dat er maanden aan data ontbreekt.',
    0
);

DO $$
DECLARE
    new_scenario_id INTEGER;
BEGIN
    SELECT id INTO new_scenario_id FROM scenarios 
    WHERE naam = 'De Stille ETL' 
    ORDER BY id DESC LIMIT 1;
    
    -- Voeg hints toe voor scenario 3
    INSERT INTO scenario_hints (scenario_id, agent_id, hint_context) VALUES
    -- Schoonmaker (Agent 1)
    (new_scenario_id, 1,
     'Ik maak altijd schoon bij de server room. Ik zie daar een scherm met logs - allemaal technische dingen. In januari zag ik steeds dezelfde regel voorbij komen: "File not found: SalesData_2024.csv". Het stond er elke nacht. Ik dacht dat het normaal was. Niemand leek er naar te kijken. Het scherm stond vaak uit.'),
    
    -- Receptionist (Agent 2)
    (new_scenario_id, 2,
     'In Maart kreeg ik een telefoontje van Finance. "Waarom stopt ons sales dashboard bij December?!" Ik verbond ze door naar de Database Beheerder. Hij klonk verbaasd. "Dat kan niet, de ETL draait elke nacht," zei hij. Later hoorde ik hem vloeken in zijn kantoor. Hij had zijn error notifications nooit ingesteld na de laatste server upgrade in December. Hij wist niet dat de scripts al maanden faalden.'),
    
    -- Stagiair (Agent 3)
    (new_scenario_id, 3,
     'Ik moest in januari helpen met een server migratie. De Database Beheerder liet me zijn ETL scripts zien. Ik zag een regel: filename = "SalesData_2024.csv". Ik vroeg: "Moet dat niet dynamisch, met de huidige jaar?" Hij zei: "Oh, goede vraag! Ik zal dat fixen na de migratie." Maar na die dag had hij het zo druk met brand fighting dat hij het vergat. Ik durfde niet meer te vragen.');
END $$;

-- Controleer of alles goed is gegaan
SELECT 
    s.id,
    s.naam AS scenario_naam,
    p.naam AS dader,
    w.naam AS wapen,
    l.naam AS locatie,
    COUNT(sh.id) AS aantal_hints
FROM scenarios s
JOIN personen p ON s.persoon_id = p.id
JOIN wapens w ON s.wapen_id = w.id
JOIN locaties l ON s.locatie_id = l.id
LEFT JOIN scenario_hints sh ON sh.scenario_id = s.id
WHERE s.naam IN ('De Persoonlijke Filter', 'De Onzichtbare Duplicaten', 'De Stille ETL')
GROUP BY s.id, s.naam, p.naam, w.naam, l.naam
ORDER BY s.id;
