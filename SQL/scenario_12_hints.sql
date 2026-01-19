-- =============================================
-- SCENARIO 12: Agent Hints
-- =============================================

-- Scenario context:
-- Power BI Developer maakte in paniek een hidden slicer voor Q2 demo
-- Verstopte Noord/Oost filter in Selection Pane
-- Demo ging perfect, daarna vergeten
-- Zuid en West regio's zijn nu 3 maanden onzichtbaar

-- Agent hints moeten spelers helpen ontdekken:
-- 1. Wie had de demo? (Power BI Developer)
-- 2. Waarom was er tijdsdruk? (Onverwachte Q2 review morgen al)
-- 3. Wat is de technische oplossing? (Hidden slicer in Selection Pane)

-- =============================================
-- HINT 1: Schoonmaker
-- =============================================
-- Wat kan Schoonmaker gezien hebben?
-- - Power BI Developer werkte 's avonds laat voor de demo
-- - Stress, haast, gefrustreerd
-- - "Morgen demo, moet dit nu fixen"

INSERT INTO scenario_hints (scenario_id, agent_id, hint_context, created_at)
VALUES (
  12,
  1, -- Schoonmaker
  'Ik herinner me die avond voor de Q2 review. Power BI Developer was hier tot laat. Ik hoorde hem praten tegen zichzelf: "Management wil morgen de cijfers zien, geen tijd om alles op te lossen." Hij zat gespannen achter zijn scherm. Leek gehaast, gestrest. De volgende dag was die belangrijke meeting.',
  NOW()
);

-- =============================================
-- HINT 2: Receptionist
-- =============================================
-- Wat kan Receptionist gezien hebben?
-- - De Q2 review meeting in agenda
-- - Power BI Developer vroeg of meeting verzet kon worden (nee)
-- - Na demo: management onder de indruk
-- - Power BI Developer opgelucht

INSERT INTO scenario_hints (scenario_id, agent_id, hint_context, created_at)
VALUES (
  12,
  2, -- Receptionist
  'Oh ja, die Q2 review! Dat was plotseling - normaal plannen we die weken van tevoren. Power BI Developer kwam naar me toe: "Kan die meeting verzet worden? Ik heb echt nog werk te doen." Maar nee, management wilde het per se die dag. Na de meeting zag ik hem wel opgelucht. Demo was goed gegaan blijkbaar.',
  NOW()
);

-- =============================================
-- HINT 3: Stagiair
-- =============================================
-- Wat kan Stagiair gezien hebben?
-- - Power BI Developer bezig in Selection Pane
-- - "Dit is tijdelijk, moet ik morgen fixen"
-- - Stagiair zag het maar begreep het niet helemaal
-- - Geen follow-up daarna

INSERT INTO scenario_hints (scenario_id, agent_id, hint_context, created_at)
VALUES (
  12,
  3, -- Stagiair
  'Ik zag Power BI Developer die dag bezig in dat Selection Pane venster. Je weet wel, waar je dingen kunt verstoppen in Power BI. Hij zei iets van: "Dit is tijdelijk, moet ik morgen na de demo cleanup." Maar ik denk dat hij het gewoon is vergeten. Drukke periode daarna.',
  NOW()
);

-- =============================================
-- ACTIVEER SCENARIO 12
-- =============================================

UPDATE scenarios
SET archive_flag = 0
WHERE id = 12;

-- =============================================
-- VERIFICATIE
-- =============================================

-- Check of de hints goed zijn toegevoegd
SELECT 
  sh.id,
  sc.naam as scenario,
  a.naam as agent,
  LEFT(sh.hint_context, 100) as hint_preview
FROM scenario_hints sh
JOIN scenarios sc ON sh.scenario_id = sc.id
JOIN agents a ON sh.agent_id = a.id
WHERE sh.scenario_id = 12
ORDER BY sh.agent_id;

-- Check of scenario 12 active is
SELECT id, naam, archive_flag FROM scenarios WHERE id = 12;
