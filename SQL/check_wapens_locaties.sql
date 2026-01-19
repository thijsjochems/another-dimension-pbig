-- Check alle wapens en locaties voor nieuwe scenarios
SELECT 'WAPENS' as type, id, naam, nfc_code FROM wapens ORDER BY id;
SELECT 'LOCATIES' as type, id, naam, nfc_code FROM locaties ORDER BY id;
