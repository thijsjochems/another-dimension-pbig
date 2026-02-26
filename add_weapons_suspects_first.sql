-- STAP 1: Voeg nieuwe weapons toe (als ze nog niet bestaan)
-- Run dit EERST voordat je add_new_scenarios.sql runt

-- Weapon voor Scenario 2: Hidden Slicer
INSERT INTO weapons (name, description, rarity)
VALUES (
    'Hidden Slicer met Actieve Filter',
    'Een slicer die via Selection Pane onzichtbaar is gemaakt maar nog steeds actief filtert. De filter is hidden maar niet disabled. Zeldzaam omdat gebruikers meestal geen edit-rechten hebben op production reports.',
    'zeldzaam'
) ON CONFLICT (name) DO NOTHING;

-- Weapon voor Scenario 3: Duplicate Dimension Entries  
INSERT INTO weapons (name, description, rarity)
VALUES (
    'Duplicate Dimension Entries',
    'Dimensietabellen bevatten duplicate entries (zelfde natural key, verschillende technical keys), wat zorgt voor meervoudige koppelingen in het model. Vermenigvuldigt measures onbedoeld. Gevaarlijk omdat het subtiel is — niet alle data is fout.',
    'veelvoorkomend'
) ON CONFLICT (name) DO NOTHING;

-- Weapon voor Scenario 4: Stale Database
-- (Deze bestaat al waarschijnlijk, maar we voegen hem toe met ON CONFLICT)
INSERT INTO weapons (name, description, rarity)
VALUES (
    'Stale Database Connection',
    'De database wordt wel bevraagd, maar de brondata is verouderd doordat upstream ETL-processen stilzwijgend gefaald hebben. Power BI refresht braaf, maar toont oude data. Silent failures zijn het moeilijkst te detecteren.',
    'veelvoorkomend'
) ON CONFLICT (name) DO NOTHING;

-- STAP 2: Voeg nieuwe suspects toe (als ze nog niet bestaan)

-- FC - Financial Controller
INSERT INTO suspects (initials, full_name, role, description)
VALUES (
    'FC',
    'Financial Controller',
    'Finance',
    'Enthousiast na Power BI training. Kreeg edit-rechten om "kleine aanpassingen zelf te doen." Weet genoeg om gevaarlijk te zijn, maar mist diepgaande kennis. Probeert dingen netjes te maken door visuele elementen te verbergen.'
) ON CONFLICT (initials) DO NOTHING;

-- PD - Power BI Developer (als deze nog niet bestaat)
INSERT INTO suspects (initials, full_name, role, description)  
VALUES (
    'PD',
    'Power BI Developer',
    'BI Development',
    'Technisch bekwaam maar vaak onder tijdsdruk. Sluit nieuwe databronnen aan en klikt waarschuwingen weg om door te kunnen werken. Gaat ervan uit dat brondata schoon is. Controleert niet altijd of dimensietabellen unique keys hebben.'
) ON CONFLICT (initials) DO NOTHING;

-- DB - Database Beheerder
INSERT INTO suspects (initials, full_name, role, description)
VALUES (
    'DB',
    'Database Administrator',
    'IT Infrastructure',
    'Beheert backend databases en ETL-processen. Houdt van structuur en naamconventies. Krijgt niet altijd mee wanneer upstream teams hun processen wijzigen. Checkt zelden logs als er geen expliciete errors zijn.'
) ON CONFLICT (initials) DO NOTHING;

-- Verificatie: Check of alles is toegevoegd
SELECT 'Weapons' as type, name FROM weapons 
WHERE name IN (
    'Hidden Slicer met Actieve Filter',
    'Duplicate Dimension Entries',
    'Stale Database Connection'
)
UNION ALL
SELECT 'Suspects' as type, initials || ' - ' || full_name FROM suspects
WHERE initials IN ('FC', 'PD', 'DB')
ORDER BY type, name;
