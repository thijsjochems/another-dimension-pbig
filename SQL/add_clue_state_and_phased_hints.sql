-- =============================================
-- Add stateful clue progression + phased hints
-- =============================================

-- 1) Stateful progression per game + agent
CREATE TABLE IF NOT EXISTS agent_clue_state (
    id SERIAL PRIMARY KEY,
    game_id INTEGER NOT NULL REFERENCES games(id) ON DELETE CASCADE,
    agent_id INTEGER NOT NULL REFERENCES agents(id),
    phase INTEGER NOT NULL DEFAULT 1 CHECK (phase BETWEEN 1 AND 3),
    updated_at TIMESTAMP DEFAULT NOW(),
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(game_id, agent_id)
);

CREATE INDEX IF NOT EXISTS idx_agent_clue_state_game_agent
ON agent_clue_state(game_id, agent_id);

-- 2) Add phased hint columns (backward compatible)
ALTER TABLE scenario_hints
ADD COLUMN IF NOT EXISTS hint_phase_1 TEXT,
ADD COLUMN IF NOT EXISTS hint_phase_2 TEXT,
ADD COLUMN IF NOT EXISTS hint_phase_3 TEXT;

-- 3) Seed phase 1 from existing hint_context where empty
UPDATE scenario_hints
SET hint_phase_1 = hint_context
WHERE hint_phase_1 IS NULL;

-- Verification
SELECT
    COUNT(*) AS total_hints,
    COUNT(hint_phase_1) AS with_phase_1,
    COUNT(hint_phase_2) AS with_phase_2,
    COUNT(hint_phase_3) AS with_phase_3
FROM scenario_hints;
