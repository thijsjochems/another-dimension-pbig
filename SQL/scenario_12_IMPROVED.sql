-- =============================================
-- SCENARIO 12: De Test Slicer - VERBETERD
-- =============================================

-- OUDE VERSIE (Score: 3.8/5):
-- Power BI Developer + Hidden Slicer + Report View - Selection Pane
-- Goed, maar kan beter: meer storytelling en menselijk gedrag

-- NIEUWE VERSIE (Verbeterd):
-- Zelfde combinatie, maar rijkere story met stress en vergeetfout

-- Eerst de kolom toevoegen aan de scenarios tabel (indien nodig)
ALTER TABLE scenarios 
ADD COLUMN IF NOT EXISTS situatie_beschrijving TEXT;

-- Nu de update uitvoeren
UPDATE scenarios 
SET 
    persoon_id = 1, -- Power BI Developer (correct)
    wapen_id = 2, -- Hidden Slicer (correct)
    locatie_id = 4, -- Report View - Selection Pane (correct)
    naam = 'De Demo Stress',
    beschrijving = 'Het management kondigde een onverwachte Q2 review meeting aan - morgen al. De Power BI Developer had geen tijd om de echte datakwaliteitsproblemen op te lossen. In paniek maakte hij een hidden slicer die alleen "goede" regio''s toonde (Noord en Oost met hoge verkoopcijfers). Hij verstopte de slicer in de Selection Pane met plan "morgen na demo cleanup". De demo ging perfect - management was onder de indruk. Maar toen begon Q3 en hij vergat de slicer volledig. Niemand zag Zuid en West regio''s meer. Drie maanden lang.',
    situatie_beschrijving = 'Dashboard toont alleen data van 2 van de 4 regio''s (Noord en Oost). Zuid en West regio''s zijn volledig onzichtbaar. Totalen kloppen niet. Sales managers van Zuid en West vragen waarom hun cijfers niet in het dashboard staan.'
WHERE id = 12;

-- =============================================
-- CAUSALE KETEN (Verbeterd):
-- =============================================
-- 1. Power BI Developer (REDEN): Onverwachte management demo morgen aangekondigd
-- 2. STRESS: Geen tijd om echte datakwaliteitsproblemen op te lossen
-- 3. QUICK FIX: Maakt hidden slicer die alleen "goede" regio's toont
-- 4. ACTIE: Verbergt slicer in Selection Pane
-- 5. INTENTIE: "Na demo opruimen"
-- 6. GEVOLG: Demo gaat perfect, management onder de indruk
-- 7. VERGEET: Q3 begint, slicer cleanup vergeten
-- 8. WAPEN: Hidden Slicer (filters 50% van data weg)
-- 9. LOCATIE: Selection Pane (waar slicer verstopt is)
-- 10. SYMPTOOM: 2 regio's onzichtbaar, managers klagen

-- =============================================
-- MENSELIJK GEDRAG:
-- =============================================
-- - Stress gedreven beslissing: Geen tijd, quick fix needed
-- - Goede intenties: "Morgen opruimen na demo"
-- - Context switch: Q3 begint, developer vergeet cleanup
-- - Demo bias: Perfecte demo = validatie, geen reden om terug te kijken
-- - Onbewust onbekwaam: Vergeet dat slicer er nog staat
-- - Victim: Sales managers van Zuid en West missen hun data

-- =============================================
-- AGENT HINTS MOGELIJKHEDEN:
-- =============================================

-- Schoonmaker:
-- "Vlak voor die grote Q2 meeting hoorde ik de Developer tegen zichzelf praten:
-- 'Dit moet perfect zijn voor het management, geen tijd voor Zuid en West nu.'
-- Hij klonk gestrest. Na de meeting hoorde ik het management zeggen: 
-- 'Uitstekend werk, prachtige cijfers!' De Developer zag er opgelucht uit."

-- Receptionist:
-- "Het management kondigde die Q2 review meeting heel plotseling aan - 
-- de Developer had maar één avond om te prepareren. Ik hoorde hem zeggen:
-- 'Ik maak een quick fix, ruim het morgen op.' De meeting ging perfect,
-- iedereen was blij. De Database Beheerder was die week op kantoor,
-- de Financial Controller ook. Stagiair was net met vakantie."

-- Stagiair:
-- "Ik zag de Developer een slicer toevoegen en dan verbergen in de Selection Pane.
-- Klassieke 'demo mode' truc - verstop de slechte data. Hij selecteerde alleen
-- Noord en Oost regio's. Slim voor een demo, maar je moet het daarna wel weer
-- terug zetten. Als je het vergeet, blijft die filter actief. Zuid en West
-- regio's zijn dan permanent onzichtbaar voor gebruikers."

-- =============================================
-- SITUATIE VOOR BEURSBEZOEKER:
-- =============================================
-- "Het sales dashboard toont alleen cijfers van Noord en Oost regio's.
-- Zuid en West regio's zijn volledig verdwenen uit alle visuals. 
-- De totalen kloppen niet meer - het lijkt alsof de verkoop met 50% gedaald is.
-- Sales managers van Zuid en West bellen dagelijks: 'Waarom staan onze cijfers 
-- er niet in?' Het ziet er niet uit als een error - het dashboard werkt,
-- maar toont gewoon niet alle data."

-- =============================================
-- TECHNISCHE ACCURATESSE:
-- =============================================
-- ✅ Power BI Developer kan slicers verbergen in Selection Pane
-- ✅ Hidden slicer blijft actief filter toepassen
-- ✅ Gebruikers zien de slicer niet, weten niet dat er gefilterd wordt
-- ✅ Demo scenario: verstop slechte data voor presentatie
-- ✅ Vergeten cleanup na demo is zeer herkenbaar
-- ✅ Selection Pane is technisch correcte locatie

-- =============================================
-- WAAROM QUICK WIN:
-- =============================================
-- - Logica en techniek zijn al goed (4/5 en 5/5)
-- - Storytelling verbeterd: stress, goede intenties, context switch
-- - Menselijk gedrag toegevoegd: demo bias, vergeetfout
-- - Speelbaarheid verbeterd: agents kunnen stress en demo verhaal vertellen
-- - Causale keten rijker: van stressvolle aankondiging tot maandenlange gevolgen

-- =============================================
-- SCORE VERWACHTING:
-- =============================================
-- Realisme: 5/5 (Zeer herkenbaar - demo stress situation)
-- Logica: 5/5 (Perfecte causale keten met menselijke fout)
-- Techniek: 5/5 (Blijft technisch perfect)
-- Speelbaarheid: 5/5 (Agents kunnen stress en demo story vertellen)
-- Storytelling: 5/5 (Rijke story: stress → quick fix → succes → vergeten)
-- TOTAAL: 5.0/5 ⭐⭐⭐⭐⭐

SELECT 'Scenario 12 verbeterd van 3.8/5 naar verwacht 5.0/5' as status;
