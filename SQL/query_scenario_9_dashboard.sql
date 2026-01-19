-- Query scenario 9 via SQL editor in Supabase dashboard
-- Copy-paste this into https://supabase.com/dashboard/project/eiynfrgezfyncoqaemfr/editor

SELECT 
  s.id,
  s.naam,
  s.beschrijving,
  s.situatie_beschrijving,
  p.naam as persoon,
  w.naam as wapen,
  l.naam as locatie,
  s.archive_flag
FROM scenarios s
LEFT JOIN personen p ON s.persoon_id = p.id
LEFT JOIN wapens w ON s.wapen_id = w.id
LEFT JOIN locaties l ON s.locatie_id = l.id
WHERE s.id = 9;
