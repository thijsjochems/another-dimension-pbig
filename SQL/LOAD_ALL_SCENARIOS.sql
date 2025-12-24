-- =============================================
-- LOAD ALL 20 SCENARIOS - FIXED SCHEMA
-- Updated to use: naam, persoon_id, beschrijving
-- Run this in Supabase SQL Editor after QUICK_FIX.sql
-- =============================================

-- SCENARIO 1: De Budget Stress
INSERT INTO scenarios (naam, persoon_id, wapen_id, locatie_id, beschrijving, active) VALUES (
    'De Budget Stress',
    2, -- Financial Controller
    5, -- Budgetten Niet Geüpdatet
    1, -- OneDrive
    'Het was eind Q3 en de Financial Controller moest snel de nieuwe Q4 budgetten uploaden. In de haast plaatste ze het Excel bestand in haar persoonlijke OneDrive folder in plaats van de gedeelde locatie. De refresh draaide nog op het oude bestand.',
    false
);

-- SCENARIO 2: De Verkeerde Path
INSERT INTO scenarios (naam, persoon_id, wapen_id, locatie_id, beschrijving, active) VALUES (
    'De Verkeerde Path',
    2, -- Financial Controller
    4, -- Hardcoded Excel Pad
    2, -- Power Query Editor
    'Na een reorganisatie kreeg de Financial Controller een nieuwe laptop. Het budget Excel bestand stond nu op een andere locatie, maar niemand had de hardcoded path in Power Query aangepast. De refresh faalde stilletjes.',
    false
);

-- SCENARIO 3: De Heidag Chaos
INSERT INTO scenarios (naam, persoon_id, wapen_id, locatie_id, beschrijving, active) VALUES (
    'De Heidag Chaos',
    1, -- Power BI Developer
    2, -- Hidden Slicer
    4, -- Report View - Selection Pane
    'De dag voor de Heidag wilde de Power BI Developer snel een filter toevoegen voor de presentatie. In de haast verborg hij de slicer maar vergat deze te verwijderen. Het rapport ging live met een actieve filter op alleen Q2 data.',
    false
);

-- SCENARIO 4: De Power BI Gebruikersdag
INSERT INTO scenarios (naam, persoon_id, wapen_id, locatie_id, beschrijving, active) VALUES (
    'De Power BI Gebruikersdag',
    1, -- Power BI Developer
    5, -- Budgetten Niet Geüpdatet
    3, -- Semantisch Model
    'De Power BI Developer was drie dagen op de Power BI Gebruikersdag. Hij vergat de scheduled refresh voor het weekend aan te zetten. Maandagochtend stonden er nog de cijfers van vorige week in het dashboard.',
    false
);

-- SCENARIO 5: De Database Migratie
INSERT INTO scenarios (naam, persoon_id, wapen_id, locatie_id, beschrijving, active) VALUES (
    'De Database Migratie',
    3, -- Database Beheerder
    1, -- Many-to-Many Relatie
    3, -- Semantisch Model
    'Tijdens een database migratie in Q1 wijzigde de Database Beheerder de structuur van de Sales tabel. Dit creëerde onverwacht een many-to-many relatie met de Product tabel. Alle verkoopcijfers werden dubbel geteld.',
    false
);

-- SCENARIO 6: De Toegangsrechten
INSERT INTO scenarios (naam, persoon_id, wapen_id, locatie_id, beschrijving, active) VALUES (
    'De Toegangsrechten',
    3, -- Database Beheerder  
    5, -- Budgetten Niet Geüpdatet (via geen toegang)
    3, -- Semantisch Model
    'Na een security audit trok de Database Beheerder oude service accounts in. Helaas was dit ook het account dat Power BI gebruikte voor de refresh. Niemand kreeg een error, de data werd gewoon niet meer ververst.',
    false
);

-- SCENARIO 7: De Dubbele Dimensie
INSERT INTO scenarios (naam, persoon_id, wapen_id, locatie_id, beschrijving, active) VALUES (
    'De Dubbele Dimensie',
    3, -- Database Beheerder
    3, -- Dubbele Records in DIM Table  
    3, -- Semantisch Model
    'Bij het importeren van nieuwe productcodes aan het einde van het boekjaar, ontstonden er per ongeluk dubbele records in de DIM_Product tabel. Elke verkoop werd nu twee keer geteld in het dashboard.',
    false
);

-- SCENARIO 8: De Test Slicer
INSERT INTO scenarios (naam, persoon_id, wapen_id, locatie_id, beschrijving, active) VALUES (
    'De Test Slicer',
    1, -- Power BI Developer
    2, -- Hidden Slicer
    4, -- Report View - Selection Pane  
    'Tijdens een demo voor het management in Q2 wilde de developer alleen "goede" data tonen. Hij voegde snel een slicer toe die slechte resultaten filterde en verborg deze. Na de demo vergat hij deze te verwijderen.',
    false
);

-- SCENARIO 9: De OneDrive Sync
INSERT INTO scenarios (naam, persoon_id, wapen_id, locatie_id, beschrijving, active) VALUES (
    'De OneDrive Sync',
    2, -- Financial Controller
    4, -- Hardcoded Excel Pad
    1, -- OneDrive
    'De Financial Controller werkte thuis en had OneDrive op "Files On-Demand" staan. Het budget bestand was niet lokaal gedownload. Toen Power Query probeerde te refreshen, kreeg het "File not found" omdat het bestand alleen in de cloud stond.',
    false
);

-- SCENARIO 10: De Query Experiment  
INSERT INTO scenarios (naam, persoon_id, wapen_id, locatie_id, beschrijving, active) VALUES (
    'De Query Experiment',
    1, -- Power BI Developer
    3, -- Dubbele Records in DIM Table
    2, -- Power Query Editor
    'De Power BI Developer experimenteerde met een nieuwe merge in Power Query. Door een verkeerde join (Left Outer in plaats van Inner) ontstonden er dubbele rijen. Hij publishte de wijziging vrijdagmiddag zonder te testen.',
    false
);

-- SCENARIO 11: De Jaar-einde Drukte
INSERT INTO scenarios (naam, persoon_id, wapen_id, locatie_id, beschrijving, active) VALUES (
    'De Jaar-einde Drukte',
    2, -- Financial Controller
    5, -- Budgetten Niet Geüpdatet
    1, -- OneDrive
    'In de laatste week van december was het extreem druk met jaar-einde rapportages. De Financial Controller uploadde wel de nieuwe cijfers, maar in een nieuwe folder "2024 Budget Final FINAL v3". De oude path klopte niet meer.',
    false
);

-- SCENARIO 12: De Many-to-Many Model
INSERT INTO scenarios (naam, persoon_id, wapen_id, locatie_id, beschrijving, active) VALUES (
    'De Many-to-Many Model',
    1, -- Power BI Developer
    1, -- Many-to-Many Relatie
    3, -- Semantisch Model
    'Voor een nieuwe analyse wilde de developer een directe relatie tussen Employees en Projects. Hij vergat dat één employee aan meerdere projecten kan werken. De many-to-many relatie zorgde voor vermenigvuldigde uren in alle rapporten.',
    false
);

-- SCENARIO 13: De Database Cleanup
INSERT INTO scenarios (naam, persoon_id, wapen_id, locatie_id, beschrijving, active) VALUES (
    'De Database Cleanup',
    3, -- Database Beheerder
    3, -- Dubbele Records in DIM Table
    2, -- Power Query Editor (via database bron)
    'Tijdens een database cleanup in Q3 wilde de Database Beheerder oude duplicaten verwijderen. Door een fout in zijn script werden juist nieuwe duplicaten aangemaakt in de DIM_Customer tabel.',
    false
);

-- SCENARIO 14: De Verborgen Filter Test
INSERT INTO scenarios (naam, persoon_id, wapen_id, locatie_id, beschrijving, active) VALUES (
    'De Verborgen Filter Test',
    1, -- Power BI Developer
    2, -- Hidden Slicer
    4, -- Report View - Selection Pane
    'Voor een specifieke afdeling maakte de developer een gefilterde versie van het rapport. Hij dacht de slicer verwijderd te hebben, maar had deze alleen verborgen. De hele organisatie zag nu alleen data van Sales West.',
    false
);

-- SCENARIO 15: De Migratie Path
INSERT INTO scenarios (naam, persoon_id, wapen_id, locatie_id, beschrijving, active) VALUES (
    'De Migratie Path',
    1, -- Power BI Developer  
    4, -- Hardcoded Excel Pad
    2, -- Power Query Editor
    'Bij een migratie naar een nieuwe server had de developer de database connectie aangepast, maar vergeten dat er ook een Excel bestand als bron werd gebruikt. De hardcoded "C:\Data\Budgets.xlsx" bestond niet op de nieuwe omgeving.',
    false
);

-- SCENARIO 16: De Vakantie Vergissing
INSERT INTO scenarios (naam, persoon_id, wapen_id, locatie_id, beschrijving, active) VALUES (
    'De Vakantie Vergissing',
    1, -- Power BI Developer
    5, -- Budgetten Niet Geüpdatet  
    3, -- Semantisch Model
    'Vlak voor zijn vakantie in augustus zette de developer de refresh uit "om bandbreedtte te besparen". Hij vergat deze weer aan te zetten na terugkomst. Drie weken lang draaide het dashboard op oude data.',
    false
);

-- SCENARIO 17: De Budget Versies
INSERT INTO scenarios (naam, persoon_id, wapen_id, locatie_id, beschrijving, active) VALUES (
    'De Budget Versies',
    2, -- Financial Controller
    4, -- Hardcoded Excel Pad
    1, -- OneDrive
    'De Financial Controller maakte verschillende versies van het budget: "Conservatief", "Realistisch", "Optimistisch". Power Query was gekoppeld aan "Realistisch", maar het management wilde "Conservatief" zien. Niemand paste de path aan.',
    false
);

-- SCENARIO 18: De Test Environment
INSERT INTO scenarios (naam, persoon_id, wapen_id, locatie_id, beschrijving, active) VALUES (
    'De Test Environment',
    3, -- Database Beheerder
    1, -- Many-to-Many Relatie
    3, -- Semantisch Model
    'De Database Beheerder testte een nieuwe feature in de productie database (oeps!). Hij creëerde een test-tabel met bewust een many-to-many relatie. Hij vergat deze te verwijderen en de Power BI Developer koppelde er per ongeluk aan.',
    false
);

-- SCENARIO 19: De Snelle Fix
INSERT INTO scenarios (naam, persoon_id, wapen_id, locatie_id, beschrijving, active) VALUES (
    'De Snelle Fix',
    1, -- Power BI Developer
    3, -- Dubbele Records in DIM Table
    2, -- Power Query Editor  
    'Het was 17:55 op vrijdag. De developer moest snel een nieuwe kolom toevoegen. Hij deed een quick merge zonder te checken op dubbele keys. Maandagochtend waren alle KPIs verdubbeld.',
    false
);

-- SCENARIO 20: De Reorganisatie
INSERT INTO scenarios (naam, persoon_id, wapen_id, locatie_id, beschrijving, active) VALUES (
    'De Reorganisatie',
    3, -- Database Beheerder
    5, -- Budgetten Niet Geüpdatet (via toegang)
    3, -- Semantisch Model
    'Na een reorganisatie wijzigde de Database Beheerder de security groups. De service account voor Power BI zat niet meer in de juiste groep. De refresh leek te werken, maar pakte eigenlijk geen nieuwe data op.',
    false
);

-- Done! 20 scenarios loaded
SELECT 'All 20 scenarios loaded successfully!' AS status;
