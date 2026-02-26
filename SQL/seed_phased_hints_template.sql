-- =============================================
-- Template: 3-phase hints per scenario + agent
-- Use this pattern to rewrite existing hints
-- =============================================

-- Example for one scenario (replace <SCENARIO_ID>)
UPDATE scenario_hints
SET
    hint_phase_1 = '<Subtiele observatie in 1-2 zinnen>',
    hint_phase_2 = '<Zelfde observatie + 1 concreet detail>',
    hint_phase_3 = '<Bijna-oplossing, nog geen letterlijk eindantwoord>'
WHERE scenario_id = <SCENARIO_ID> AND agent_id = 1;

UPDATE scenario_hints
SET
    hint_phase_1 = '<Receptionist fase 1>',
    hint_phase_2 = '<Receptionist fase 2>',
    hint_phase_3 = '<Receptionist fase 3>'
WHERE scenario_id = <SCENARIO_ID> AND agent_id = 2;

UPDATE scenario_hints
SET
    hint_phase_1 = '<Stagiair fase 1>',
    hint_phase_2 = '<Stagiair fase 2>',
    hint_phase_3 = '<Stagiair fase 3>'
WHERE scenario_id = <SCENARIO_ID> AND agent_id = 3;

-- Quick quality check
SELECT
    scenario_id,
    agent_id,
    LEFT(COALESCE(hint_phase_1, ''), 80) AS phase1_preview,
    LEFT(COALESCE(hint_phase_2, ''), 80) AS phase2_preview,
    LEFT(COALESCE(hint_phase_3, ''), 80) AS phase3_preview
FROM scenario_hints
WHERE scenario_id = <SCENARIO_ID>
ORDER BY agent_id;
