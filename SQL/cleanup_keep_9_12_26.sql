-- =============================================
-- CLEANUP: Behoud alleen scenarios 9, 12 en 26
-- =============================================

-- Stap 1: Verwijder alle scenario_hints BEHALVE voor scenario 9, 12 en 26
DELETE FROM scenario_hints 
WHERE scenario_id NOT IN (9, 12, 26);

-- Stap 2: Verwijder alle scenarios BEHALVE 9, 12 en 26
DELETE FROM scenarios 
WHERE id NOT IN (9, 12, 26);

-- Stap 3: Verwijder chat_messages die niet bij actieve scenarios horen
-- (chat_messages hebben geen directe foreign key naar scenarios, maar we ruimen op)
DELETE FROM chat_messages 
WHERE game_id NOT IN (
  SELECT DISTINCT game_id 
  FROM chat_messages 
  WHERE created_at > NOW() - INTERVAL '7 days'
);

-- Stap 4: Bekijk welke personen, wapens en locaties nog in gebruik zijn
SELECT 'PERSONEN IN GEBRUIK:' as info;
SELECT DISTINCT p.id, p.naam 
FROM personen p
INNER JOIN scenarios s ON s.persoon_id = p.id
WHERE s.id IN (9, 12, 26)
ORDER BY p.id;

SELECT 'WAPENS IN GEBRUIK:' as info;
SELECT DISTINCT w.id, w.naam 
FROM wapens w
INNER JOIN scenarios s ON s.wapen_id = w.id
WHERE s.id IN (9, 12, 26)
ORDER BY w.id;

SELECT 'LOCATIES IN GEBRUIK:' as info;
SELECT DISTINCT l.id, l.naam 
FROM locaties l
INNER JOIN scenarios s ON s.locatie_id = l.id
WHERE s.id IN (9, 12, 26)
ORDER BY l.id;

-- Stap 5: Verwijder ONGEBRUIKTE personen (optioneel - voorlopig uitgecommentarieerd)
-- DELETE FROM personen 
-- WHERE id NOT IN (
--   SELECT DISTINCT persoon_id FROM scenarios WHERE id IN (9, 12, 26)
-- );

-- Stap 6: Verwijder ONGEBRUIKTE wapens (optioneel - voorlopig uitgecommentarieerd)
-- DELETE FROM wapens 
-- WHERE id NOT IN (
--   SELECT DISTINCT wapen_id FROM scenarios WHERE id IN (9, 12, 26)
-- );

-- Stap 7: Verwijder ONGEBRUIKTE locaties (optioneel - voorlopig uitgecommentarieerd)
-- DELETE FROM locaties 
-- WHERE id NOT IN (
--   SELECT DISTINCT locatie_id FROM scenarios WHERE id IN (9, 12, 26)
-- );

-- =============================================
-- VERIFICATIE
-- =============================================

SELECT 'ACTIEVE SCENARIOS:' as info;
SELECT id, naam, persoon_id, wapen_id, locatie_id, archive_flag
FROM scenarios
WHERE id IN (9, 12, 26)
ORDER BY id;

SELECT 'SCENARIO HINTS:' as info;
SELECT 
  sh.scenario_id,
  a.naam as agent,
  LEFT(sh.hint_context, 80) as hint_preview
FROM scenario_hints sh
JOIN agents a ON sh.agent_id = a.id
WHERE sh.scenario_id IN (9, 12, 26)
ORDER BY sh.scenario_id, sh.agent_id;

SELECT 'TOTAAL AANTAL RECORDS:' as info;
SELECT 
  (SELECT COUNT(*) FROM scenarios) as total_scenarios,
  (SELECT COUNT(*) FROM scenario_hints) as total_hints,
  (SELECT COUNT(*) FROM personen) as total_personen,
  (SELECT COUNT(*) FROM wapens) as total_wapens,
  (SELECT COUNT(*) FROM locaties) as total_locaties;
