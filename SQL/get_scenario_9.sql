-- Get full scenario 9 details
SELECT 
  s.id,
  s.naam,
  s.beschrijving,
  s.situatie_beschrijving,
  p.naam as persoon,
  w.naam as wapen,
  l.naam as locatie
FROM scenarios s
LEFT JOIN personen p ON s.persoon_id = p.id
LEFT JOIN wapens w ON s.wapen_id = w.id
LEFT JOIN locaties l ON s.locatie_id = l.id
WHERE s.id = 9;
