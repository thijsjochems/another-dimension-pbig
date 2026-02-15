-- Check welke suspects, weapons en locations al bestaan
-- Run dit EERST om te zien wat we kunnen gebruiken

SELECT 'SUSPECTS' as type, initials, full_name, role 
FROM suspects
ORDER BY initials;

SELECT 'WEAPONS' as type, name, description
FROM weapons
ORDER BY name;

SELECT 'LOCATIONS' as type, name, description
FROM locations
ORDER BY name;
