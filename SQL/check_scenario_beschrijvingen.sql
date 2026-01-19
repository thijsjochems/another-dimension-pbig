-- Check scenario beschrijvingen voor spelers
SELECT id, beschrijving FROM scenarios WHERE archive_flag = 0 ORDER BY id;
