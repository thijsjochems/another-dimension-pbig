-- Fix scenarios table - rename dader_id to persoon_id for consistency

ALTER TABLE scenarios 
RENAME COLUMN dader_id TO persoon_id;
