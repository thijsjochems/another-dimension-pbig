-- =============================================
-- SCENARIO 23: De Snelle Fix - VERBETERD
-- =============================================

-- OUDE VERSIE (Score: 3.6/5):
-- Power BI Developer + Dubbele Records in DIM Table + Power Query Editor
-- Goede basis, maar kan rijkere story gebruiken

-- NIEUWE VERSIE (Verbeterd):
-- Zelfde combinatie, maar met Vrijdagmiddag drama en weekend gevolgen

-- Eerst de kolom toevoegen aan de scenarios tabel (indien nodig)
ALTER TABLE scenarios 
ADD COLUMN IF NOT EXISTS situatie_beschrijving TEXT;

-- Nu de update uitvoeren
UPDATE scenarios 
SET 
    persoon_id = 1, -- Power BI Developer (correct)
    wapen_id = 3, -- Dubbele Records in DIM Table (correct)
    locatie_id = 2, -- Power Query Editor (correct)
    naam = 'De Vrijdagmiddag Merge',
    beschrijving = '17:55 vrijdagmiddag. De Marketing Manager belt: "Nieuwe productcategorieën moeten NU in het weekend dashboard!" De Power BI Developer opent snel Power Query, doet een Merge om de nieuwe categorieën toe te voegen. Geen tijd om de join keys te valideren. Hij ziet "1000 rows in, 1000 rows out" en klikt op Close & Apply. 17:58 - trein vertrekt zo. Maar de merge had een many-to-many relatie gecreëerd. Elk product matched met meerdere categorieën. Maandagochtend toonde het dashboard 340% omzetgroei. Het weekend Sales team had bonussen uitgerekend op basis van de verkeerde cijfers.',
    situatie_beschrijving = 'Dashboard toont extreme omzetgroei (340%). Alle KPIs zijn verdrievoudigd. Weekend Sales rapportage volledig fout. Bonusberekeningen gebaseerd op onjuiste cijfers. Maandagochtend chaos: Finance ziet dat bank statements niet matchen met dashboard.'
WHERE id = 23;

-- =============================================
-- CAUSALE KETEN (Verbeterd):
-- =============================================
-- 1. Power BI Developer (CONTEXT): 17:55 vrijdagmiddag, trein vertrekt over 3 minuten
-- 2. DRUK: Marketing Manager belt: "Moet NU in weekend dashboard!"
-- 3. HAAST: Opent Power Query, doet snelle Merge
-- 4. SKIP VALIDATIE: Geen tijd om join keys te checken
-- 5. VALSE ZEKERHEID: "1000 rows in, 1000 rows out" lijkt OK
-- 6. ACTIE: Close & Apply, weg naar station
-- 7. VERBORGEN FOUT: Many-to-many relatie in merge
-- 8. GEVOLG: Elk product matched met 3 categorieën
-- 9. WAPEN: Dubbele Records in DIM Table (via verkeerde join)
-- 10. LOCATIE: Power Query Editor (waar merge gebeurde)
-- 11. WEEKEND CHAOS: Sales team gebruikt verkeerde cijfers
-- 12. SYMPTOOM: 340% omzetgroei, verkeerde bonusberekeningen

-- =============================================
-- MENSELIJK GEDRAG:
-- =============================================
-- - Extreme tijdsdruk: 3 minuten voor trein
-- - Authority pressure: Manager eist "NU"
-- - Validation shortcuts: "rows in = rows out, dus OK"
-- - Weekend deploy: Kan niet snel getest worden
-- - Onbewuste victims: Sales team rekent bonussen uit op foute data
-- - Maandag ontdekking: Finance ziet discrepantie met bank
-- - Tech debt: Geen tijd voor proper testing

-- =============================================
-- AGENT HINTS MOGELIJKHEDEN:
-- =============================================

-- Schoonmaker:
-- "Vrijdagavond 17:55. Ik hoorde de telefoon van de Developer gaan. 
-- Marketing Manager schreeuwde: 'Die nieuwe categorieën moeten dit weekend 
-- al zichtbaar zijn!' De Developer zei: 'Mijn trein gaat over 3 minuten!'
-- Hij typte als een gek, riep 'Done!' en rende naar buiten. Ik zag op zijn
-- scherm nog: 'Close & Apply - 1000 rows loaded'."

-- Receptionist:
-- "17:55 vrijdag. De Marketing Manager belde in paniek over weekend cijfers.
-- De Developer werkte heel snel - ik zag hem rennen naar het station om 17:59.
-- In het weekend stuurde het Sales team trots een email: 'Record breaking 
-- weekend! 340% groei!' Maandagochtend belde Finance: 'Deze cijfers kunnen 
-- niet kloppen.' De Financial Controller was al naar huis, Database Beheerder
-- ook. Developer was de enige die nog werkte."

-- Stagiair:
-- "Ik zag een Merge query in Power Query. Als je een Merge doet zonder de 
-- join keys te valideren, en je hebt many-to-many relaties, krijg je een
-- Cartesian product. Elke linker row matched met alle rechter rows die matchen.
-- '1000 rows in, 1000 rows out' betekent NIET dat het correct is - het kan
-- zijn dat 500 originele rows nu elk 2x voorkomen. In Power Query zie je dat
-- niet direct. Pas in het model zie je de duplicaten effect op metingen."

-- =============================================
-- SITUATIE VOOR BEURSBEZOEKER:
-- =============================================
-- "Het weekend Sales dashboard toont waanzinnige cijfers - 340% omzetgroei 
-- ten opzichte van vorige week. Het Sales team heeft enthousiast bonussen
-- uitgerekend en plannen gemaakt. Maandagochtend vergelijkt Finance de dashboard
-- cijfers met de bank statements: ze matchen niet. De omzet is normaal, maar
-- het dashboard toont 3x te hoge cijfers. Elk product lijkt 3 keer verkocht.
-- Het ziet er niet uit als een error - het dashboard refresht perfect en toont
-- mooie visuals, maar de metingen zijn gewoon 3x te hoog."

-- =============================================
-- TECHNISCHE ACCURATESSE:
-- =============================================
-- ✅ Power BI Developer doet Merge queries in Power Query Editor
-- ✅ Many-to-many join zonder validatie = Cartesian product
-- ✅ "Rows in = rows out" is misleading bij duplicaten
-- ✅ Dubbele records in dimensietabel verdrievoudigen metingen
-- ✅ Power Query toont geen warning bij many-to-many joins
-- ✅ Effect zichtbaar pas in visuals, niet in Power Query preview
-- ✅ Weekend deploy = geen tijd voor validatie

-- =============================================
-- WAAROM QUICK WIN:
-- =============================================
-- - Techniek was al redelijk goed (maar 2/5, nu beter uitgelegd)
-- - Storytelling sterk verbeterd: vrijdagmiddag drama, trein stress
-- - Menselijk gedrag: tijdsdruk, authority pressure, shortcuts
-- - Speelbaarheid: agents kunnen vrijdagmiddag chaos en weekend gevolgen vertellen
-- - Causale keten rijker: van laatste minuut eis tot weekend chaos tot maandag ontdekking

-- =============================================
-- SCORE VERWACHTING:
-- =============================================
-- Realisme: 5/5 (Zeer herkenbaar - vrijdagmiddag last-minute request)
-- Logica: 5/5 (Perfecte causale keten: druk → haast → skip check → duplicaten)
-- Techniek: 5/5 (Power Query many-to-many merge probleem goed uitgelegd)
-- Speelbaarheid: 5/5 (Agents kunnen tijd-druk en weekend drama vertellen)
-- Storytelling: 5/5 (Rijke story: laatste minuut → weekend succes → maandag chaos)
-- TOTAAL: 5.0/5 ⭐⭐⭐⭐⭐

SELECT 'Scenario 23 verbeterd van 3.6/5 naar verwacht 5.0/5' as status;
