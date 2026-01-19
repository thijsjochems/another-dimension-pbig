-- Voeg 3 nieuwe scenarios toe
-- Scenario 27: Budget Chaos - Financial Controller + Budget Niet Updated + OneDrive
-- Scenario 28: Hardcoded Pad Nachtmerrie - Power BI Developer + Hardcoded Pad + Power Query Editor  
-- Scenario 29: Relatie Ramp - Database Beheerder + Inactieve Relatie + Semantisch Model

-- SCENARIO 27: Budget Chaos (Financial Controller)
INSERT INTO scenarios (id, persoon_id, wapen_id, locatie_id, naam, situatie_beschrijving, beschrijving, archive_flag)
VALUES (
  27,
  4, -- Financial Controller (man)
  5, -- Budget Niet Updated
  1, -- OneDrive
  'De Budget Vergelijking',
  'Het Q4 dashboard toont budget cijfers, maar de CFO zegt dat deze niet kloppen met de laatste forecast. De board meeting is morgen. Het verschil tussen actueel en budget is opeens veel groter dan verwacht. Wanneer is de budget file voor het laatst geüpdatet?',
  'De maandag na de vakantie van de Financial Controller was het drama compleet. Tijdens de board meeting presenteerde de CEO vol trots de Q4 cijfers uit het dashboard - maar niemand had door dat de budget Excel file op zijn persoonlijke OneDrive al 3 weken niet was geüpdatet. De Controller zat op Bali en had zijn laptop niet bij zich. Alle budget vergelijkingen in het rapport klopten niet meer. De CFO zat tijdens de presentatie met een vuurrood hoofd naast de CEO toen bleek dat ze aan de board verkeerde cijfers hadden gepresenteerd.',
  0
);

-- SCENARIO 28: Hardcoded Pad Nachtmerrie (Power BI Developer)
INSERT INTO scenarios (id, persoon_id, wapen_id, locatie_id, naam, situatie_beschrijving, beschrijving, archive_flag)
VALUES (
  28,
  1, -- Power BI Developer (vrouw)
  4, -- Hardcoded Pad
  2, -- Power Query Editor
  'De Refresh Failure',
  'Sales dashboard faalt elke ochtend om 6:00 uur bij de scheduled refresh. Error log toont "DataSource.Error: File not found". Het rapport werkte perfect in Desktop. Wat is er mis gegaan bij het publiceren naar de Service?',
  'Ze had het rapport gemaakt op haar eigen laptop, alles werkte perfect. Maar toen ze het rapport naar de service publishte, crashte alles. In Power Query had ze per ongeluk het pad hardcoded: "C:\\Users\\HaarNaam\\Documents\\Sales_Data.xlsx". Op de service bestaat die C-schijf natuurlijk niet. De refresh faalde elke ochtend om 6:00 uur. Een week lang zag het management verouderde cijfers zonder dat iemand doorhad waarom. Pas toen iemand de query logs checkte, vonden ze de fout - die ene regel in Power Query die niemand ooit controleert.',
  0
);

-- SCENARIO 29: Relatie Ramp (Power BI Developer)
INSERT INTO scenarios (id, persoon_id, wapen_id, locatie_id, naam, situatie_beschrijving, beschrijving, archive_flag)
VALUES (
  29,
  1, -- Power BI Developer (vrouw)
  1, -- Inactieve Relatie
  3, -- Semantisch Model
  'De Filter Fail',
  'Filters werken niet meer. Als gebruikers een product selecteren, veranderen de sales cijfers niet. Totalen kloppen ook niet - ze zijn veel te hoog. De hele sales afdeling belt paniek: "Waarom werkt het dashboard niet meer?" Twee dagen geleden werkte alles nog perfect.',
  'Het was een simpele vraag van sales: "Kunnen we even testen hoe het dashboard eruitziet zonder de forecast data?" Ze had in het model de relatie tussen Sales en Forecast op inactief gezet voor de test. Daarna was ze het vergeten. Twee dagen later zat de hele sales afdeling in paniek - alle visuals toonden verkeerde totalen, filters werkten niet meer, en niemand begreep waarom. Ze had de relatie nooit meer actief gemaakt. Het dashboard was live gegaan naar 200 gebruikers met een kapot datamodel.',
  0
);

-- Voeg hints toe voor alle 3 scenarios (per scenario 3 hints: Schoonmaker, Receptionist, Stagiair)

-- SCENARIO 27 HINTS (Budget Chaos)
INSERT INTO scenario_hints (scenario_id, agent_id, hint_context) VALUES
(27, 1, 'Ik was laatst zijn kantoor aan het stofzuigen. Die Financial Controller is een nette vent, hoor. Hij had net voor zijn vakantie nog late avonden gemaakt - zie ik aan de lege koffiebekers. Op zijn whiteboard stond "Budget update Q4" met een dikke vette streep erdoor. Dacht dat ie het had afgevinkt, maar misschien was dat wishful thinking? Hij ging daarna direct naar Schiphol volgens mij, zie ik aan z''n agenda die open stond.'),

(27, 2, 'Oh die Financial Controller! Knappe man, altijd zo netjes gekleed. Hij kwam vorige week nog even langs voor de sleutel van de fietsenstalling, ging op vakantie zie je. Vlak voor ie wegging zei ie nog: "Als iemand naar mijn Excel files vraagt, zeg maar dat ik na mijn vakantie alles update." Ik dacht nog: waarom nu niet? Maar ja, ik ben maar de receptionist natuurlijk. Mensen denken dat data vanzelf update, snap je?'),

(27, 3, 'Ehhh ja die Financial Controller ken ik wel. Ik moest laatst een rapport maken over cloud storage kosten. Bleek dat die gast z''n OneDrive helemaal vol heeft met budget bestanden. En toen ik de access logs checkte - want dat kan ik als stagiair gewoon inzien - zag ik dat ie al 3 weken niet had ingelogd. Er staan zoveel Power BI rapporten die naar zijn OneDrive wijzen, man. Als die files niet refreshen, dan refresh niks. Simpel toch?');

-- SCENARIO 28 HINTS (Hardcoded Pad)
INSERT INTO scenario_hints (scenario_id, agent_id, hint_context) VALUES
(28, 1, 'Die Power BI Developer is echt een rommelkont, haha. Laatst haar bureau gedaan, overal notitiepapiertjes. Op eentje stond: "LET OP: paden relatief maken!!" met 3 uitroeptekens. Alsof ze zichzelf een reminder gaf. Maar ja, als je in tijdsnood zit vergeet je dat soort dingen snel he. Ze had ook een post-it met "C:\\ Users\\ MijnNaam" doorgestreept. Zie je dat soort dingen te vaak bij developers - werkt op hun laptop, publish naar cloud, en dan... pats boem.'),

(28, 2, 'Die Power BI Developer? Lieve meid, altijd beleefd. Ze kwam vorige week helemaal gestrest binnen, had een deadline voor een rapport. Zei nog tegen een collega: "Ik heb geen tijd om alles netjes te maken, ik push het gewoon." Je weet toch, dat soort developers work? First make it work, dan make it pretty. Maar soms vergeten ze die tweede stap. En met paden in Power Query... daar let echt niemand op totdat het te laat is.'),

(28, 3, 'Oké dus ik was laatst aan het leren over Power Query, toch? En toen zei mijn begeleider: "Altijd opletten met file paths, want die verschillen per machine." En toen dacht ik: hoe vaak gaat dat fout? Bleek dus: heel vaak. Die Power BI Developer heeft vorige week een rapport gepubliceerd, en ik zie in de refresh history dat ie ELKE dag faalt. Error message: "File not found C:\\ blabla". Klassieke fout, man. Je laptop is niet de cloud.');

-- SCENARIO 29 HINTS (Relatie Ramp)  
INSERT INTO scenario_hints (scenario_id, agent_id, hint_context) VALUES
(29, 1, 'Die Power BI Developer, rustige vrouw, altijd bezig met haar laptop. Laatst aan het stofzuigen, zie ik op haar scherm zo''n diagram met allemaal lijnen tussen tabellen. Ik snap er niks van natuurlijk, maar ze had er eentje met stippellijntjes gemaakt. Zei nog hardop tegen zichzelf: "Even testen zonder forecast." Toen ging ze lunchen. Maar of ze het terug heeft gezet? Geen idee. Zag er stressed uit toen ze terugkwam, misschien is ze het vergeten?'),

(29, 2, 'De Power BI Developer? Ja die ken ik, ze komt vaak langs. Vorige week zat ze nog met iemand van sales te praten. Die sales gast vroeg: "Kun je even de forecast uitzetten zodat we kunnen testen?" En zij zei: "Ja hoor, ik maak de relatie inactief." Klinkt technisch allemaal. Maar sales ging daarna direct weer weg, en zij had nog 10 andere dingen te doen. Zou ze het hebben teruggezet? Weet ik niet, maar ik zie dat dashboard wel langs komen bij support met rare vragen over waarom cijfers niet kloppen.'),

(29, 3, 'Yo, dus die Power BI Developer is eigenlijk best chill. Ze had me laatst uitgelegd hoe relaties werken in Power BI - actief en inactief en zo. En toen zei ze: "Als je een relatie op inactief zet voor een test, VERGEET NIET hem weer actief te maken." Ze benadrukte die laatste woorden echt. Dus ik dacht: ze weet wat ze doet. Maar laatst hoorde ik haar met IT bellen over "waarom werken de visuals niet meer" en toen dacht ik... hmm, heeft ze het zelf wel teruggedraaid? Oeps.');

-- Verificatie
SELECT id, persoon_id, wapen_id, locatie_id FROM scenarios WHERE id IN (27, 28, 29) ORDER BY id;
SELECT scenario_id, agent_id, COUNT(*) as hint_count FROM scenario_hints WHERE scenario_id IN (27, 28, 29) GROUP BY scenario_id, agent_id ORDER BY scenario_id, agent_id;
