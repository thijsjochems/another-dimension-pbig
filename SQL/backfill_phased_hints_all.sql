-- =============================================
-- BACKFILL PHASED HINTS FOR ALL SCENARIOS
-- =============================================
-- Doel:
-- - hint_phase_1: subtiele start (meestal 1e zin)
-- - hint_phase_2: iets concreter (eerste 2 zinnen)
-- - hint_phase_3: volledige context
--
-- Veiligheid:
-- - Overschrijft bestaande handmatige fase-velden NIET
-- - Vult alleen lege / NULL velden

BEGIN;

-- 1) Zorg dat phase_1 minimaal gevuld is
UPDATE scenario_hints
SET hint_phase_1 = NULLIF(TRIM(hint_context), '')
WHERE (hint_phase_1 IS NULL OR TRIM(hint_phase_1) = '')
  AND hint_context IS NOT NULL
  AND TRIM(hint_context) <> '';

-- 2) Bouw sentence-array uit hint_context (simpele zin-splitsing op . ! ? + spatie)
WITH parsed AS (
  SELECT
    id,
    regexp_split_to_array(TRIM(hint_context), '(?<=[.!?])\s+') AS parts,
    TRIM(hint_context) AS raw
  FROM scenario_hints
  WHERE hint_context IS NOT NULL
    AND TRIM(hint_context) <> ''
),
phase_values AS (
  SELECT
    id,
    CASE
      WHEN array_length(parts, 1) IS NULL OR array_length(parts, 1) = 0 THEN raw
      ELSE parts[1]
    END AS p1,
    CASE
      WHEN array_length(parts, 1) IS NULL OR array_length(parts, 1) = 0 THEN raw
      WHEN array_length(parts, 1) = 1 THEN parts[1]
      ELSE parts[1] || ' ' || parts[2]
    END AS p2,
    raw AS p3
  FROM parsed
)
UPDATE scenario_hints sh
SET
  hint_phase_1 = CASE
    WHEN sh.hint_phase_1 IS NULL OR TRIM(sh.hint_phase_1) = '' THEN pv.p1
    ELSE sh.hint_phase_1
  END,
  hint_phase_2 = CASE
    WHEN sh.hint_phase_2 IS NULL OR TRIM(sh.hint_phase_2) = '' THEN pv.p2
    ELSE sh.hint_phase_2
  END,
  hint_phase_3 = CASE
    WHEN sh.hint_phase_3 IS NULL OR TRIM(sh.hint_phase_3) = '' THEN pv.p3
    ELSE sh.hint_phase_3
  END
FROM phase_values pv
WHERE sh.id = pv.id;

COMMIT;

-- =============================================
-- VERIFICATION
-- =============================================
SELECT
  COUNT(*) AS total_hints,
  COUNT(*) FILTER (WHERE hint_phase_1 IS NOT NULL AND TRIM(hint_phase_1) <> '') AS with_phase_1,
  COUNT(*) FILTER (WHERE hint_phase_2 IS NOT NULL AND TRIM(hint_phase_2) <> '') AS with_phase_2,
  COUNT(*) FILTER (WHERE hint_phase_3 IS NOT NULL AND TRIM(hint_phase_3) <> '') AS with_phase_3
FROM scenario_hints;

-- Preview per scenario/agent
SELECT
  scenario_id,
  agent_id,
  LEFT(COALESCE(hint_phase_1, ''), 90) AS phase1_preview,
  LEFT(COALESCE(hint_phase_2, ''), 90) AS phase2_preview,
  LEFT(COALESCE(hint_phase_3, ''), 90) AS phase3_preview
FROM scenario_hints
ORDER BY scenario_id, agent_id;
