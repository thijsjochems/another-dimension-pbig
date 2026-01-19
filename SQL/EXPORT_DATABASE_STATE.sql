-- =============================================
-- EXPORT ALLE DATABASE CONTENT NAAR OUTPUT
-- Copy-paste deze VOLLEDIGE output naar Copilot
-- =============================================

-- === TABLE: scenarios ===
SELECT * FROM scenarios ORDER BY id;

-- === TABLE: personen ===
SELECT * FROM personen ORDER BY id;

-- === TABLE: wapens ===
SELECT * FROM wapens ORDER BY id;

-- === TABLE: locaties ===
SELECT * FROM locaties ORDER BY id;

-- === TABLE: agents ===
SELECT * FROM agents ORDER BY id;

-- === TABLE: scenario_hints ===
SELECT sh.*, a.naam as agent_naam 
FROM scenario_hints sh
JOIN agents a ON sh.agent_id = a.id
ORDER BY sh.scenario_id, sh.agent_id;

-- === TABLE: games (last 20) ===
SELECT * FROM games ORDER BY created_at DESC LIMIT 20;

-- === TABLE: special_nfc_codes ===
SELECT * FROM special_nfc_codes ORDER BY id;

-- === COUNTS ===
SELECT 
  'scenarios' as table_name,
  COUNT(*) as record_count
FROM scenarios
UNION ALL
SELECT 'personen', COUNT(*) FROM personen
UNION ALL
SELECT 'wapens', COUNT(*) FROM wapens
UNION ALL
SELECT 'locaties', COUNT(*) FROM locaties
UNION ALL
SELECT 'agents', COUNT(*) FROM agents
UNION ALL
SELECT 'scenario_hints', COUNT(*) FROM scenario_hints
UNION ALL
SELECT 'games', COUNT(*) FROM games
UNION ALL
SELECT 'special_nfc_codes', COUNT(*) FROM special_nfc_codes;
