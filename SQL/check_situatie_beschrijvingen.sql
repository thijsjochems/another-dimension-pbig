-- Check naam en situatie_beschrijving van bestaande scenarios
SELECT id, naam, situatie_beschrijving FROM scenarios WHERE id IN (9, 12, 26) ORDER BY id;
