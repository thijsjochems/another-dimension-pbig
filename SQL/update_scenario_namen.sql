-- Update scenarios 27, 28, 29 met naam en situatie_beschrijving
-- (voor als je de oude INSERT al had gedraaid)

UPDATE scenarios SET
  naam = 'De Budget Vergelijking',
  situatie_beschrijving = 'De CFO toont vol trots tijdens de board meeting de laatste cijfers. Maar komt er vervolgens achter dat de budgetten niet kloppen. Wat is hier aan de hand?!'
WHERE id = 27;

UPDATE scenarios SET
  naam = 'De Refresh Failure',
  situatie_beschrijving = 'Het sales dashboard refresht al een week niet meer. Management kijkt naar verouderde cijfers zonder het door te hebben. De error log toont "File not found". Hoe kan dat?'
WHERE id = 28;

UPDATE scenarios SET
  naam = 'De Filter Fail',
  situatie_beschrijving = 'Filters werken plotseling niet meer. Sales selecteert een product, maar de cijfers veranderen niet. Totalen zijn veel te hoog. Gisteren werkte alles nog perfect!'
WHERE id = 29;

-- Verificatie
SELECT id, naam, situatie_beschrijving FROM scenarios WHERE id IN (27, 28, 29) ORDER BY id;
