-- =============================================
-- SCENARIO 25: De Excel Refresh Button (NIEUW)
-- =============================================

-- CONCEPT:
-- Financial Controller werkt met Excel broncijfers
-- Excel staat op haar desktop: "Q1_Budget_2026_FINAL_v3.xlsx"
-- Power BI refresh werkt perfect - zij klikt zelf op "Data > Refresh All"
-- Na weken perfect werken: zij gaat op vakantie (2 weken Spanje)
-- Laptop uit, Excel file niet open
-- Power BI scheduled refresh FAALT - kan Excel niet openen (file locked/not accessible)
-- Dashboard vriest in tijd: toont laatste data van voor vakantie
-- Niemand heeft door dat cijfers 2 weken oud zijn
-- Ze komt terug: klikt refresh, alles werkt weer
-- Maar Sales heeft 2 weken besluiten genomen op oude data

-- PERSONEN: Financial Controller (gaat op vakantie, Excel op haar laptop)
-- WAPEN: Gesloten Bestand (Excel niet open, laptop uit)
-- LOCATIE: Power Query Editor (waar Excel connectie staat)

-- Voeg scenario toe
INSERT INTO scenarios (
  naam, 
  persoon_id, 
  wapen_id, 
  locatie_id, 
  beschrijving,
  situatie_beschrijving,
  archive_flag,
  created_at
) VALUES (
  'De Excel Refresh Button',
  5, -- Financial Controller
  8, -- Gesloten Bestand (nieuw wapen!)
  5, -- Power Query Editor
  'Maart 2026. Financial Controller had het budget proces eindelijk afgerond. Excel bestand "Q1_Budget_2026_FINAL_v3.xlsx" op haar desktop. Power BI Developer vroeg: "Kunnen we dit niet in SharePoint zetten?" Ze: "Nee, ik moet dit vaak aanpassen, Excel op mijn desktop werkt perfect." Elke ochtend opende ze Excel, klikte Data > Refresh All. Power BI draaide smooth. 15 maart: vakantie! Twee weken Spanje, eindelijk rust. Laptop uit, thuis in de kast. Power BI scheduled refresh probeerde elke nacht te draaien: "Cannot access file: path not found". Dashboard bleef staan op 14 maart data. Sales team gebruikte het dagelijks - niemand zag de datum. 29 maart kwam ze terug. Klikte Excel open, refresh, Power BI draaide weer. IT Manager: "Wacht, waarom zijn onze Q1 targets van 2 weken geleden?"',
  'Dashboard toont budget cijfers van 2 weken geleden. Sales targets kloppen niet met Excel die Finance heeft. Power BI refresh errors in de logs. Niemand heeft door dat data niet update sinds Financial Controller op vakantie is.',
  0,
  NOW()
);

-- =============================================
-- AGENT HINTS - MET PERSOONLIJKHEID
-- =============================================

-- SCHOONMAKER
-- Wat zag Schoonmaker?
-- - Financial Controller opgelucht voor vakantie
-- - Bureau helemaal opgeruimd (ongebruikelijk!)
-- - Laptop mee naar huis
-- - Post-it: "15-29 maart: Spanje, bereikbaar via mobiel ALLEEN NOODGEVAL"

INSERT INTO scenario_hints (scenario_id, agent_id, hint_context, created_at)
VALUES (
  25,
  1, -- Schoonmaker
  'Half maart was Financial Controller eindelijk klaar met die Q1 budgetten. Echt opgelucht. Ze ruimde haar bureau helemaal op - dat doet ze nooit! Laptop in haar tas. Ik zag een post-it op haar deur: "15-29 maart Spanje, ALLEEN NOODGEVAL bellen!" Ze had het verdiend, die budgetcyclus was een nachtmerrie dit jaar. Kantoor stond twee weken leeg.',
  NOW()
);

-- RECEPTIONIST
-- Wat zag Receptionist?
-- - Financial Controller vroeg pakketjes vast te houden
-- - "Twee weken weg, ECHT offline zijn dit keer"
-- - Sales kwam klagen over budget cijfers
-- - "Maar die cijfers komen van Finance, die is op vakantie"

INSERT INTO scenario_hints (scenario_id, agent_id, hint_context, created_at)
VALUES (
  25,
  2, -- Receptionist
  'Financial Controller kwam voor haar vakantie nog even langs. "Kun je mijn pakketjes vasthouden? Twee weken Spanje, ga ECHT offline zijn dit keer." Zelfs haar laptop liet ze thuis, zei ze. Luxe! Een week later kwam Sales klagen over budget cijfers die niet klopten. Ik zei: "Maar die cijfers komen van Finance toch? Die is op vakantie." Leek niet belangrijk toen.',
  NOW()
);

-- STAGIAIR  
-- Wat zag Stagiair?
-- - Power BI Developer frustratie over Excel op desktop
-- - "Als ze dat ding nu eens in SharePoint zet..."
-- - Stagiair begreep niet waarom dat een probleem was
-- - Power BI Developer: "Als haar laptop uit staat, werkt scheduled refresh niet"

INSERT INTO scenario_hints (scenario_id, agent_id, hint_context, created_at)
VALUES (
  25,
  3, -- Stagiair
  'Ik hoorde Power BI Developer een keer mopperen over Financial Controller. Iets met een Excel bestand op haar desktop. "Als ze dat ding nu eens in SharePoint zet, dan kan scheduled refresh werken!" Ik snapte het niet helemaal. Hij legde uit: "Als haar laptop uit staat, kan Power BI er niet bij." Klonk als een design flaw eerlijk gezegd.',
  NOW()
);

-- =============================================
-- NIEUW WAPEN TOEVOEGEN
-- =============================================

INSERT INTO wapens (naam, nfc_code, beschrijving, technische_uitleg)
VALUES (
  'Gesloten Bestand',
  'TEMP_NFC_WEAPON_08',
  'Een Excel of Access bestand dat niet bereikbaar is omdat de computer uit staat, het bestand gesloten is, of de netwerklocatie offline is.',
  'Power BI scheduled refresh faalt als bronbestand niet bereikbaar is. Veelvoorkomend: Excel op desktop/laptop (computer uit = geen refresh), Access database niet geopend, netwerkschijf offline. Error: "Cannot access file" of "File in use by another process". Dashboard blijft staan op laatste succesvolle refresh. Users zien verouderde data zonder dat ze het weten. Fix: migreer naar SharePoint/OneDrive, gebruik SQL database, of zorg dat bron 24/7 bereikbaar is.'
);

-- =============================================
-- VERIFICATIE
-- =============================================

SELECT id, naam, persoon_id, wapen_id, locatie_id, archive_flag 
FROM scenarios WHERE id = 25;

SELECT 
  sh.id,
  a.naam as agent,
  LEFT(sh.hint_context, 80) as hint_preview
FROM scenario_hints sh
JOIN agents a ON sh.agent_id = a.id
WHERE sh.scenario_id = 25
ORDER BY sh.agent_id;

SELECT * FROM wapens WHERE naam = 'Gesloten Bestand';
