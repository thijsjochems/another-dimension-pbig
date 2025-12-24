-- =============================================
-- SCENARIO GENERATIE - Logische combinaties
-- Met realistische context (Q3, jaar-einde, events)
-- =============================================

-- Deze scenarios zijn handmatig geselecteerd voor logica en spelbaarheid
-- Elk scenario krijgt een realistisch verhaal met timing/context

-- =============================================
-- SCENARIO 1: De Budget Stress
-- =============================================
INSERT INTO scenarios (dader_id, wapen_id, locatie_id, verhaal) VALUES (
    2, -- Financial Controller
    5, -- Budgetten Niet Geüpdatet
    1, -- OneDrive
    'Het was eind Q3 en de Financial Controller moest snel de nieuwe Q4 budgetten uploaden. In de haast plaatste ze het Excel bestand in haar persoonlijke OneDrive folder in plaats van de gedeelde locatie. De refresh draaide nog op het oude bestand.'
);

-- =============================================
-- SCENARIO 2: De Verkeerde Path
-- =============================================
INSERT INTO scenarios (dader_id, wapen_id, locatie_id, verhaal) VALUES (
    2, -- Financial Controller
    4, -- Hardcoded Excel Pad
    2, -- Power Query Editor
    'Na een reorganisatie kreeg de Financial Controller een nieuwe laptop. Het budget Excel bestand stond nu op een andere locatie, maar niemand had de hardcoded path in Power Query aangepast. De refresh faalde stilletjes.'
);

-- =============================================
-- SCENARIO 3: De Heidag Chaos
-- =============================================
INSERT INTO scenarios (dader_id, wapen_id, locatie_id, verhaal) VALUES (
    1, -- Power BI Developer
    2, -- Hidden Slicer
    4, -- Report View - Selection Pane
    'De dag voor de Heidag wilde de Power BI Developer snel een filter toevoegen voor de presentatie. In de haast verborg hij de slicer maar vergat deze te verwijderen. Het rapport ging live met een actieve filter op alleen Q2 data.'
);

-- =============================================
-- SCENARIO 4: De Power BI Gebruikersdag
-- =============================================
INSERT INTO scenarios (dader_id, wapen_id, locatie_id, verhaal) VALUES (
    1, -- Power BI Developer
    5, -- Budgetten Niet Geüpdatet
    3, -- Semantisch Model
    'De Power BI Developer was drie dagen op de Power BI Gebruikersdag. Hij vergat de scheduled refresh voor het weekend aan te zetten. Maandagochtend stonden er nog de cijfers van vorige week in het dashboard.'
);

-- =============================================
-- SCENARIO 5: De Database Migratie
-- =============================================
INSERT INTO scenarios (dader_id, wapen_id, locatie_id, verhaal) VALUES (
    3, -- Database Beheerder
    1, -- Many-to-Many Relatie
    3, -- Semantisch Model
    'Tijdens een database migratie in Q1 wijzigde de Database Beheerder de structuur van de Sales tabel. Dit creëerde onverwacht een many-to-many relatie met de Product tabel. Alle verkoopcijfers werden dubbel geteld.'
);

-- =============================================
-- SCENARIO 6: De Toegangsrechten
-- =============================================
INSERT INTO scenarios (dader_id, wapen_id, locatie_id, verhaal) VALUES (
    3, -- Database Beheerder  
    5, -- Budgetten Niet Geüpdatet (via geen toegang)
    3, -- Semantisch Model
    'Na een security audit trok de Database Beheerder oude service accounts in. Helaas was dit ook het account dat Power BI gebruikte voor de refresh. Niemand kreeg een error, de data werd gewoon niet meer ververst.'
);

-- =============================================
-- SCENARIO 7: De Dubbele Dimensie
-- =============================================
INSERT INTO scenarios (dader_id, wapen_id, locatie_id, verhaal) VALUES (
    3, -- Database Beheerder
    3, -- Dubbele Records in DIM Table  
    3, -- Semantisch Model
    'Bij het importeren van nieuwe productcodes aan het einde van het boekjaar, ontstonden er per ongeluk dubbele records in de DIM_Product tabel. Elke verkoop werd nu twee keer geteld in het dashboard.'
);

-- =============================================
-- SCENARIO 8: De Test Slicer
-- =============================================
INSERT INTO scenarios (dader_id, wapen_id, locatie_id, verhaal) VALUES (
    1, -- Power BI Developer
    2, -- Hidden Slicer
    4, -- Report View - Selection Pane  
    'Tijdens een demo voor het management in Q2 wilde de developer alleen "goede" data tonen. Hij voegde snel een slicer toe die slechte resultaten filterde en verborg deze. Na de demo vergat hij deze te verwijderen.'
);

-- =============================================
-- SCENARIO 9: De OneDrive Sync
-- =============================================
INSERT INTO scenarios (dader_id, wapen_id, locatie_id, verhaal) VALUES (
    2, -- Financial Controller
    4, -- Hardcoded Excel Pad
    1, -- OneDrive
    'De Financial Controller werkte thuis en had OneDrive op "Files On-Demand" staan. Het budget bestand was niet lokaal gedownload. Toen Power Query probeerde te refreshen, kreeg het "File not found" omdat het bestand alleen in de cloud stond.'
);

-- =============================================
-- SCENARIO 10: De Query Experiment  
-- =============================================
INSERT INTO scenarios (dader_id, wapen_id, locatie_id, verhaal) VALUES (
    1, -- Power BI Developer
    3, -- Dubbele Records in DIM Table
    2, -- Power Query Editor
    'De Power BI Developer experimenteerde met een nieuwe merge in Power Query. Door een verkeerde join (Left Outer in plaats van Inner) ontstonden er dubbele rijen. Hij publishte de wijziging vrijdagmiddag zonder te testen.'
);

-- =============================================
-- SCENARIO 11: De Jaar-einde Drukte
-- =============================================
INSERT INTO scenarios (dader_id, wapen_id, locatie_id, verhaal) VALUES (
    2, -- Financial Controller
    5, -- Budgetten Niet Geüpdatet
    1, -- OneDrive
    'In de laatste week van december was het extreem druk met jaar-einde rapportages. De Financial Controller uploadde wel de nieuwe cijfers, maar in een nieuwe folder "2024 Budget Final FINAL v3". De oude path klopte niet meer.'
);

-- =============================================
-- SCENARIO 12: De Many-to-Many Model
-- =============================================
INSERT INTO scenarios (dader_id, wapen_id, locatie_id, verhaal) VALUES (
    1, -- Power BI Developer
    1, -- Many-to-Many Relatie
    3, -- Semantisch Model
    'Voor een nieuwe analyse wilde de developer een directe relatie tussen Employees en Projects. Hij vergat dat één employee aan meerdere projecten kan werken. De many-to-many relatie zorgde voor vermenigvuldigde uren in alle rapporten.'
);

-- =============================================
-- SCENARIO 13: De Database Cleanup
-- =============================================
INSERT INTO scenarios (dader_id, wapen_id, locatie_id, verhaal) VALUES (
    3, -- Database Beheerder
    3, -- Dubbele Records in DIM Table
    2, -- Power Query Editor (via database bron)
    'Tijdens een database cleanup in Q3 wilde de Database Beheerder oude duplicaten verwijderen. Door een fout in zijn script werden juist nieuwe duplicaten aangemaakt in de DIM_Customer tabel.'
);

-- =============================================
-- SCENARIO 14: De Verborgen Filter Test
-- =============================================
INSERT INTO scenarios (dader_id, wapen_id, locatie_id, verhaal) VALUES (
    1, -- Power BI Developer
    2, -- Hidden Slicer
    4, -- Report View - Selection Pane
    'Voor een specifieke afdeling maakte de developer een gefilterde versie van het rapport. Hij dacht de slicer verwijderd te hebben, maar had deze alleen verborgen. De hele organisatie zag nu alleen data van Sales West.'
);

-- =============================================
-- SCENARIO 15: De Migratie Path
-- =============================================
INSERT INTO scenarios (dader_id, wapen_id, locatie_id, verhaal) VALUES (
    1, -- Power BI Developer  
    4, -- Hardcoded Excel Pad
    2, -- Power Query Editor
    'Bij een migratie naar een nieuwe server had de developer de database connectie aangepast, maar vergeten dat er ook een Excel bestand als bron werd gebruikt. De hardcoded "C:\Data\Budgets.xlsx" bestond niet op de nieuwe omgeving.'
);

-- =============================================
-- SCENARIO 16: De Vakantie Vergissing
-- =============================================
INSERT INTO scenarios (dader_id, wapen_id, locatie_id, verhaal) VALUES (
    1, -- Power BI Developer
    5, -- Budgetten Niet Geüpdatet  
    3, -- Semantisch Model
    'Vlak voor zijn vakantie in augustus zette de developer de refresh uit "om bandbreedtte te besparen". Hij vergat deze weer aan te zetten na terugkomst. Drie weken lang draaide het dashboard op oude data.'
);

-- =============================================
-- SCENARIO 17: De Budget Versies
-- =============================================
INSERT INTO scenarios (dader_id, wapen_id, locatie_id, verhaal) VALUES (
    2, -- Financial Controller
    4, -- Hardcoded Excel Pad
    1, -- OneDrive
    'De Financial Controller maakte verschillende versies van het budget: "Conservatief", "Realistisch", "Optimistisch". Power Query was gekoppeld aan "Realistisch", maar het management wilde "Conservatief" zien. Niemand paste de path aan.'
);

-- =============================================
-- SCENARIO 18: De Test Environment
-- =============================================
INSERT INTO scenarios (dader_id, wapen_id, locatie_id, verhaal) VALUES (
    3, -- Database Beheerder
    1, -- Many-to-Many Relatie
    3, -- Semantisch Model
    'De Database Beheerder testte een nieuwe feature in de productie database (oeps!). Hij creëerde een test-tabel met bewust een many-to-many relatie. Hij vergat deze te verwijderen en de Power BI Developer koppelde er per ongeluk aan.'
);

-- =============================================
-- SCENARIO 19: De Snelle Fix
-- =============================================
INSERT INTO scenarios (dader_id, wapen_id, locatie_id, verhaal) VALUES (
    1, -- Power BI Developer
    3, -- Dubbele Records in DIM Table
    2, -- Power Query Editor  
    'Het was 17:55 op vrijdag. De developer moest snel een nieuwe kolom toevoegen. Hij deed een quick merge zonder te checken op dubbele keys. Maandagochtend waren alle KPIs verdubbeld.'
);

-- =============================================
-- SCENARIO 20: De Reorganisatie
-- =============================================
INSERT INTO scenarios (dader_id, wapen_id, locatie_id, verhaal) VALUES (
    3, -- Database Beheerder
    5, -- Budgetten Niet Geüpdatet (via toegang)
    3, -- Semantisch Model
    'Na een reorganisatie wijzigde de Database Beheerder de security groups. De service account voor Power BI zat niet meer in de juiste groep. De refresh leek te werken, maar pakte eigenlijk geen nieuwe data op.'
);

-- =============================================
-- COMPLETED - 20 logische scenarios
-- =============================================

-- Volgende stap: Voor elk scenario moeten de scenario_hints worden aangemaakt
-- Dit zijn de AI prompts voor de 3 agents per scenario
-- Zie: seed_scenario_hints.sql

SELECT 'Scenarios successfully created!' as status, COUNT(*) as total_scenarios FROM scenarios;
