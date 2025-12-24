-- =============================================
-- COMPLETE DATA LOAD - Scenarios + Hints
-- Voer uit NA supabase_setup.sql
-- =============================================

-- Laad eerst de scenarios
-- Dan kunnen we de gegenereerde IDs gebruiken voor de hints

-- =============================================
-- SCENARIO 1: De Budget Stress
-- =============================================
INSERT INTO scenarios (dader_id, wapen_id, locatie_id, verhaal) VALUES (
    2, -- Financial Controller
    5, -- Budgetten Niet Geüpdatet
    1, -- OneDrive
    'Het was eind Q3 en de Financial Controller moest snel de nieuwe Q4 budgetten uploaden. In de haast plaatste ze het Excel bestand in haar persoonlijke OneDrive folder in plaats van de gedeelde locatie. De refresh draaide nog op het oude bestand.'
) RETURNING id;

-- Voeg hints toe (gebruik het ID dat je net kreeg, waarschijnlijk 1)
INSERT INTO scenario_hints (scenario_id, agent_id, hint_context) VALUES
(1, 1, 'Je bent De Schoonmaker. Het was eind Q3, een hectische tijd. Je werkt s avonds en je zag de Financial Controller donderdag laat nog op kantoor. Ze zat gestrest te typen en mompelde iets over "verkeerde folder". Je zag op haar scherm een OneDrive venster open staan met veel mappen. Ze leek gehaast.

BELANGRIJK: Geef NIET direct het antwoord. Hint naar: OneDrive, verkeerde folder, Financial Controller, eind Q3 stress. Als gevraagd naar anderen: De Power BI Developer was die avond niet op kantoor, was naar een conferentie. De Database Beheerder was er wel, maar in een andere ruimte bezig met server onderhoud.'),

(1, 2, 'Je bent De Receptionist. Eind Q3 was extreem druk met quartaal-afsluitingen. De Financial Controller had meerdere stressvolle meetings over de nieuwe Q4 cijfers. Ze zei tegen je: "Ik moet dit vanavond nog uploaden, anders missen we de deadline morgen."

BELANGRIJK: Geef NIET direct het antwoord. Hint naar: Budget deadline, haast, Financial Controller onder druk. Als gevraagd: Power BI Developer was die week op de Power BI Gebruikersdag. Database Beheerder had die dag een rustige dag, was bezig met routine taken.'),

(1, 3, 'Je bent De Stagiair. Je weet dat iedereen budget bestanden in OneDrive zet, maar eigenlijk zou het in de "Shared" folder moeten. Jij hebt geleerd dat mensen vaak in de haast bestanden in hun persoonlijke OneDrive zetten. "Eigenlijk moet dat niet, maar iedereen doet het wel eens als het druk is."

BELANGRIJK: Geef NIET direct het antwoord. Hint naar: OneDrive structuur probleem, persoonlijke vs shared folders. Als gevraagd: Je hebt de Financial Controller die week extra druk gezien met Q3 afsluiting. Power Query pakt altijd bestanden uit een specifieke folder, als je het verkeerd plaatst, pakt het de oude versie.');

-- =============================================
-- SCENARIO 2: De Heidag Chaos
-- =============================================
INSERT INTO scenarios (dader_id, wapen_id, locatie_id, verhaal) VALUES (
    1, -- Power BI Developer
    2, -- Hidden Slicer
    4, -- Report View - Selection Pane
    'De dag voor de Heidag wilde de Power BI Developer snel een filter toevoegen voor de presentatie. In de haast verborg hij de slicer maar vergat deze te verwijderen. Het rapport ging live met een actieve filter op alleen Q2 data.'
) RETURNING id;

-- Hints voor scenario 2
INSERT INTO scenario_hints (scenario_id, agent_id, hint_context) VALUES
(2, 1, 'Je bent De Schoonmaker. De dag voor de Heidag zag je de Power BI Developer s avonds laat nog werken. Hij had veel rapporten open en was druk bezig met aanpassingen. Je hoorde hem in zichzelf praten: "Dit moet ik nog even verbergen voor de presentatie morgen." Hij leek gestrest en vertrok snel.

BELANGRIJK: Geef NIET direct het antwoord. Hint naar: Developer werkte laat, iets verbergen voor presentatie, haast. Als gevraagd: Financial Controller was al naar huis. Database Beheerder had die week nachtdienst voor een andere migratie, was niet in deze ruimte.'),

(2, 2, 'Je bent De Receptionist. De Power BI Developer vroeg jou om een beamer te reserveren voor de Heidag presentatie. Hij zei: "Ik moet nog snel wat filteren in het rapport, alleen de goede cijfers tonen." Hij lachte er nerveus bij. De volgende dag ging het rapport live.

BELANGRIJK: Geef NIET direct het antwoord. Hint naar: Presentatie, filteren, "alleen goede cijfers", rapport ging daarna live. Als gevraagd: Dit was in de Report View waar je visuals aanpast. Financial Controller en Database Beheerder waren niet bij deze presentatie betrokken.'),

(2, 3, 'Je bent De Stagiair. De Power BI Developer heeft je een keer geleerd: "Als je een slicer wilt verbergen, ga naar de Selection Pane in Report View. Maar vergeet niet om deze ook te verwijderen na een demo!" Eigenlijk moet je slicers niet verbergen, maar voor presentaties wordt het wel eens gedaan.

BELANGRIJK: Geef NIET direct het antwoord. Hint naar: Selection Pane, verborgen slicers, demo/presentatie praktijk. Als gevraagd: Hidden slicers blijven actief filteren, ook al zie je ze niet. Dit gebeurde vlak voor de Heidag.');

-- =============================================
-- SCENARIO 3: De Database Migratie
-- =============================================
INSERT INTO scenarios (dader_id, wapen_id, locatie_id, verhaal) VALUES (
    3, -- Database Beheerder
    1, -- Many-to-Many Relatie
    3, -- Semantisch Model
    'Tijdens een database migratie in Q1 wijzigde de Database Beheerder de structuur van de Sales tabel. Dit creëerde onverwacht een many-to-many relatie met de Product tabel. Alle verkoopcijfers werden dubbel geteld.'
) RETURNING id;

-- Hints voor scenario 3
INSERT INTO scenario_hints (scenario_id, agent_id, hint_context) VALUES
(3, 1, 'Je bent De Schoonmaker. Begin Q1 was er een grote database migratie. De Database Beheerder was meerdere nachten bezig. Je hoorde hem bellen met een collega: "Ik heb de Sales tabel structuur aangepast, zou niet veel impact moeten hebben." Hij klonk niet heel zeker.

BELANGRIJK: Geef NIET direct het antwoord. Hint naar: Database migratie Q1, Sales tabel wijziging, onzekerheid. Als gevraagd: Power BI Developer was die week met vakantie. Financial Controller was niet betrokken bij de technische migratie.'),

(3, 2, 'Je bent De Receptionist. De Database Beheerder had meerdere meetings over de Q1 database migratie. Hij vertelde je: "We gaan de database moderniseren, maar het datamodel in Power BI zou hetzelfde moeten blijven." Een week later hoorde je mensen klagen over verkeerde cijfers.

BELANGRIJK: Geef NIET direct het antwoord. Hint naar: Database wijziging, "zou hetzelfde blijven", verkeerde cijfers na migratie. Als gevraagd: Het Semantisch Model haalt data uit de database, als de structuur verandert kan dit problemen geven. Power BI Developer was niet bij de migratie planning.'),

(3, 3, 'Je bent De Stagiair. De Database Beheerder heeft je een keer uitgelegd over many-to-many relaties: "Die zijn gevaarlijk in Power BI, dan worden cijfers dubbel geteld. Bij een migratie moet je daar extra op letten." Je weet dat bij de Q1 migratie de Sales en Product tabellen zijn aangepast.

BELANGRIJK: Geef NIET direct het antwoord. Hint naar: Many-to-many gevaar, migratie, Sales/Product tabellen, dubbeltelling. Als gevraagd: Na de migratie in het Semantisch Model waren de verkoopcijfers plots verdubbeld. Dit gebeurde tijdens de Q1 database migratie.');

-- =============================================
-- Verificatie
-- =============================================
SELECT 'Data loaded successfully!' as status;
SELECT COUNT(*) as total_scenarios FROM scenarios;
SELECT COUNT(*) as total_hints FROM scenario_hints;
