-- Add answer tracking columns to games table

ALTER TABLE games
ADD COLUMN persoon_answer VARCHAR(100),
ADD COLUMN wapen_answer VARCHAR(100),
ADD COLUMN locatie_answer VARCHAR(100);

-- Add index for faster lookups
CREATE INDEX idx_games_answers ON games(persoon_answer, wapen_answer, locatie_answer);
