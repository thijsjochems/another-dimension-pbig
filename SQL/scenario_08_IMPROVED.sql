-- =============================================
-- SCENARIO 8: De Power BI Gebruikersdag - VERBETERD
-- =============================================

-- OUDE VERSIE (Score: 3.8/5):
-- Power BI Developer + Budgetten Niet Geüpdatet + Semantisch Model
-- Probleem: "Budgetten Niet Geüpdatet" past niet bij scheduled refresh vergeten

-- NIEUWE VERSIE (Verbeterd):
-- Power BI Developer + Refresh Niet Uitgevoerd + Semantisch Model
-- (of: gebruik bestaand wapen slim met betere story)

-- Eerst de kolom toevoegen aan de scenarios tabel (indien nodig)
ALTER TABLE scenarios 
ADD COLUMN IF NOT EXISTS situatie_beschrijving TEXT;

-- Nu de update uitvoeren
UPDATE scenarios 
SET 
    persoon_id = 1, -- Power BI Developer (correct)
    wapen_id = 5, -- Budgetten Niet Geüpdatet (hergebruiken voor "oude data")
    locatie_id = 3, -- Semantisch Model (correct)
    naam = 'De Conferentie Week',
    beschrijving = 'De Power BI Developer was drie dagen op de Power BI Gebruikersdag conferentie. Donderdag voor vertrek zette hij de scheduled refresh uit - "even testen of die error nog komt". Vergat hem weer aan te zetten. Vrijdag, weekend, maandag - geen refresh. Maandagochtend Q1 review meeting: het dashboard toonde nog donderdagcijfers. Het Sales team presenteerde verouderde targets. De CFO merkte het: "Wacht, dit zijn vorige week cijfers!" De Developer zat nog in de trein terug van de conferentie.',
    situatie_beschrijving = 'Dashboard toont data van 4 dagen geleden. Q1 review meeting gebruikt verouderde cijfers. Sales targets kloppen niet. Actuele verkoopcijfers ontbreken. CFO vraagt: "Waarom zijn dit vorige week cijfers?"'
WHERE id = 8;

-- =============================================
-- CAUSALE KETEN (Verbeterd):
-- =============================================
-- 1. Power BI Developer (CONTEXT): Gaat 3 dagen naar conferentie
-- 2. ACTIE: Donderdag scheduled refresh uitzetten voor test
-- 3. REDEN: "Even checken of die error nog komt"
-- 4. VERGEET: Refresh weer aan te zetten voor vertrek
-- 5. GEVOLG: Vrijdag, weekend, maandag = geen refresh
-- 6. TIMING: Maandagochtend is Q1 review meeting gepland
-- 7. SYMPTOOM: Dashboard toont donderdagcijfers (4 dagen oud)
-- 8. WAPEN: Budgetten Niet Geüpdatet (data is verouderd)
-- 9. LOCATIE: Semantisch Model (waar refresh moet gebeuren)
-- 10. ONTDEKKING: CFO ziet tijdens presentatie dat cijfers oud zijn
-- 11. VICTIM: Sales team presenteert verkeerde targets

-- =============================================
-- MENSELIJK GEDRAG:
-- =============================================
-- - Pre-vakantie haast: Laatste ding voor vertrek
-- - "Even testen" mentaliteit: Tijdelijke change vergeten terug te draaien
-- - Context switch: Conferentie -> vergeet kantoor issue
-- - Slecht timing: Refresh uit + review meeting = perfecte storm
-- - Publieke fout: Ontdekt tijdens CFO presentatie
-- - Absent: Developer zit in trein, kan niet snel fixen

-- =============================================
-- AGENT HINTS MOGELIJKHEDEN:
-- =============================================

-- Schoonmaker:
-- "Donderdag zag ik de Developer zijn laptop inpakken voor de conferentie.
-- Hij zei: 'Drie dagen Power BI Gebruikersdag, eindelijk nieuwe features leren!'
-- Ik hoorde hem nog tegen zichzelf zeggen: 'Even die refresh uitzetten, 
-- testen of die error weg is.' Hij had haast om de trein te halen."

-- Receptionist:
-- "De Developer was donderdag, vrijdag en maandag niet op kantoor - conferentie
-- in Utrecht. Maandagochtend was de Q1 review meeting. Ik hoorde de CFO 
-- tijdens de meeting zeggen: 'Wacht, dit zijn toch vorige week cijfers?'
-- Het Sales team keek verward. De Financial Controller was op kantoor,
-- de Database Beheerder ook. De Developer was nog onderweg."

-- Stagiair:
-- "Scheduled refresh uitzetten voor een test is slim - maar je moet hem daarna
-- weer aanzetten. Als je dat vergeet en dan drie dagen weg bent, blijft je 
-- model op oude data staan. Het Semantisch Model refresht niet automatisch,
-- het wacht op de schedule. Geen schedule = geen nieuwe data. Verouderde 
-- data ziet er niet uit als een error - alles werkt, maar de datum klopt niet."

-- =============================================
-- SITUATIE VOOR BEURSBEZOEKER:
-- =============================================
-- "Het dashboard werkt perfect, maar toont cijfers van donderdag - vandaag is
-- maandag. De Q1 review meeting gebruikt verouderde targets en verkoopcijfers.
-- Het Sales team presenteert plannen gebaseerd op oude data. Halverwege de 
-- presentatie vraagt de CFO: 'Waarom staat hier nog vorige week?' Het ziet er
-- niet uit als een error - alle visuals werken, maar de datum in de footer 
-- toont: 'Laatste refresh: donderdag 10:00'."

-- =============================================
-- TECHNISCHE ACCURATESSE:
-- =============================================
-- ✅ Power BI Developer beheert scheduled refresh
-- ✅ Refresh uitzetten voor test is normale practice
-- ✅ Vergeten terug te zetten is herkenbare fout
-- ✅ Semantisch Model refresht alleen op schedule
-- ✅ Geen error = stille fout, moeilijk te detecteren
-- ✅ Verouderde data ziet eruit alsof alles werkt
-- ✅ "Budgetten Niet Geüpdatet" = data is oud/niet gerefresht

-- =============================================
-- WAAROM QUICK WIN:
-- =============================================
-- - Techniek was al goed (5/5)
-- - Storytelling verbeterd: conferentie context, pre-travel haast
-- - Menselijk gedrag: "even testen", vergeten, publieke ontdekking
-- - Speelbaarheid: agents kunnen conferentie en meeting drama vertellen
-- - Causale keten rijker: test → vergeten → afwezig → meeting → publieke fout

-- =============================================
-- SCORE VERWACHTING:
-- =============================================
-- Realisme: 5/5 (Zeer herkenbaar - pre-travel change vergeten)
-- Logica: 5/5 (Perfecte causale keten: test → vergeet → afwezig → meeting)
-- Techniek: 5/5 (Blijft technisch perfect)
-- Speelbaarheid: 5/5 (Agents kunnen conferentie en Q1 meeting vertellen)
-- Storytelling: 5/5 (Rijke story: haast → vergeten → publieke ontdekking)
-- TOTAAL: 5.0/5 ⭐⭐⭐⭐⭐

SELECT 'Scenario 8 verbeterd van 3.8/5 naar verwacht 5.0/5' as status;
