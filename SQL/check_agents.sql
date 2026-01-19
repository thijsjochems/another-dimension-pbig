-- Check current agent descriptions and tone of voice
SELECT 
  id,
  naam,
  rol,
  LEFT(beschrijving, 100) as beschrijving_preview,
  LEFT(tone_of_voice, 100) as tone_preview
FROM agents
ORDER BY id;
