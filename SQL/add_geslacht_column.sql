-- Voeg geslacht kolom toe aan personen tabel
ALTER TABLE personen 
ADD COLUMN geslacht VARCHAR(10);

-- Update bestaande personen
UPDATE personen SET geslacht = 'vrouw' WHERE id = 1; -- Power BI Developer
UPDATE personen SET geslacht = 'man' WHERE id = 2; -- Financial Controller (wacht, die bestaat niet!)
UPDATE personen SET geslacht = 'vrouw' WHERE id = 3; -- Database Beheerder
UPDATE personen SET geslacht = 'man' WHERE id = 4; -- Financial Controller

-- Verificatie
SELECT id, naam, geslacht FROM personen ORDER BY id;
