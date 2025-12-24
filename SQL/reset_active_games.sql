-- Reset all active scenarios
-- Run this when a game is stuck

UPDATE scenarios
SET active = false, started_at = null
WHERE active = true;

-- Mark incomplete games as aborted
UPDATE games
SET aborted = true, end_time = NOW()
WHERE completed = false AND aborted = false;
