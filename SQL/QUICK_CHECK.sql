-- Simpele overzicht van wat er NU in de database zit

SELECT 'SCENARIOS:' as info;
SELECT id, naam, persoon_id, wapen_id, locatie_id FROM scenarios ORDER BY id;

SELECT 'PERSONEN:' as info;
SELECT id, naam FROM personen ORDER BY id;

SELECT 'WAPENS:' as info;
SELECT id, naam FROM wapens ORDER BY id;

SELECT 'LOCATIES:' as info;
SELECT id, naam FROM locaties ORDER BY id;

SELECT 'SCENARIO_HINTS:' as info;
SELECT scenario_id, agent_id FROM scenario_hints ORDER BY scenario_id, agent_id;
