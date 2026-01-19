-- =============================================
-- COMPLETE DIAGNOSTIEK
-- =============================================

-- Check alle scenarios
SELECT '=== ALLE SCENARIOS ===' as info;
SELECT id, naam, persoon_id, wapen_id, locatie_id, archive_flag 
FROM scenarios 
ORDER BY id;

-- Check alle personen
SELECT '=== ALLE PERSONEN ===' as info;
SELECT id, naam, nfc_code, LEFT(beschrijving, 50) as beschrijving_preview
FROM personen 
ORDER BY id;

-- Check alle wapens
SELECT '=== ALLE WAPENS ===' as info;
SELECT id, naam, nfc_code, LEFT(beschrijving, 50) as beschrijving_preview
FROM wapens 
ORDER BY id;

-- Check alle locaties
SELECT '=== ALLE LOCATIES ===' as info;
SELECT id, naam, nfc_code, LEFT(beschrijving, 50) as beschrijving_preview
FROM locaties 
ORDER BY id;

-- Check scenario hints
SELECT '=== SCENARIO HINTS ===' as info;
SELECT 
  sh.scenario_id,
  a.naam as agent,
  LEFT(sh.hint_context, 60) as hint_preview
FROM scenario_hints sh
JOIN agents a ON sh.agent_id = a.id
ORDER BY sh.scenario_id, sh.agent_id;

-- Check active games
SELECT '=== ACTIVE GAMES ===' as info;
SELECT id, scenario_id, created_at
FROM games
ORDER BY created_at DESC
LIMIT 10;

-- Check for missing foreign keys
SELECT '=== PROBLEEM CHECK ===' as info;

SELECT 'Scenarios met missing persoon:' as check_type;
SELECT s.id, s.naam, s.persoon_id
FROM scenarios s
LEFT JOIN personen p ON s.persoon_id = p.id
WHERE p.id IS NULL;

SELECT 'Scenarios met missing wapen:' as check_type;
SELECT s.id, s.naam, s.wapen_id
FROM scenarios s
LEFT JOIN wapens w ON s.wapen_id = w.id
WHERE w.id IS NULL;

SELECT 'Scenarios met missing locatie:' as check_type;
SELECT s.id, s.naam, s.locatie_id
FROM scenarios s
LEFT JOIN locaties l ON s.locatie_id = l.id
WHERE l.id IS NULL;
