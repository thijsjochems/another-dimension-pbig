-- =============================================
-- TEST: Check current state
-- =============================================

-- Check Financial Controller
SELECT * FROM personen WHERE id = 4;

-- Check Database locatie  
SELECT * FROM locaties WHERE id = 3;

-- Check Database Beheerder
SELECT * FROM personen WHERE id = 3;

-- Check Dubbele Records wapen
SELECT * FROM wapens WHERE id = 3;

-- Check scenario 26
SELECT * FROM scenarios WHERE id = 26;
