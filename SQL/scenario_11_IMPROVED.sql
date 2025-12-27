-- =============================================
-- SCENARIO 11: De Dubbele Dimensie - VERBETERD
-- =============================================

-- OUDE VERSIE (Score: 3.6/5):
-- Database Beheerder + Dubbele Records in DIM Table + Semantisch Model
-- Goed concept, maar "Database Beheerder" is geen standaard rol

-- NIEUWE VERSIE (Verbeterd):
-- Power BI Developer + Dubbele Records in DIM Table + Semantisch Model
-- Rijkere story met jaar-einde stress en import chaos

-- Eerst de kolom toevoegen aan de scenarios tabel (indien nodig)
ALTER TABLE scenarios 
ADD COLUMN IF NOT EXISTS situatie_beschrijving TEXT;

-- Nu de update uitvoeren
UPDATE scenarios 
SET 
    persoon_id = 1, -- Power BI Developer (correct voor model werk)
    wapen_id = 3, -- Dubbele Records in DIM Table (correct)
    locatie_id = 3, -- Semantisch Model (correct)
    naam = 'De Jaar-einde Import',
    beschrijving = 'Laatste werkdag van het jaar kreeg de Power BI Developer een Excel met 847 nieuwe productcodes van de Product Manager. "Moet vandaag nog live, morgen is Sales Kickoff!" In de haast kopieerde hij de Excel kolommen naar de DIM_Product tabel - maar vergat eerst de oude staging data te clearen. Nu stond elk product dubbel: oude code én nieuwe code. Het model refreshte zonder errors. Maar elke verkoop telde nu dubbel. Op de Sales Kickoff toonde het dashboard 180% omzetgroei. Sales team was euforisch. Finance team was verward.',
    situatie_beschrijving = 'Dashboard toont dubbele verkoopcijfers. Elke transactie telt twee keer. Omzet lijkt 180% gestegen. Sales Kickoff presentatie toont onrealistische groeicijfers. Finance vraagt: "Hoe kan omzet in één maand verdubbelen?"'
WHERE id = 11;

-- =============================================
-- CAUSALE KETEN (Verbeterd):
-- =============================================
-- 1. Power BI Developer (CONTEXT): Laatste werkdag van het jaar
-- 2. DRUK: Product Manager: "Moet vandaag nog live voor Sales Kickoff morgen!"
-- 3. STRESS: 847 nieuwe productcodes importeren in paar uur
-- 4. ACTIE: Kopieert Excel kolommen naar DIM_Product tabel
-- 5. FOUT: Vergeet oude staging data te clearen eerst
-- 6. GEVOLG: Elk product staat nu dubbel (oude + nieuwe code)
-- 7. GEEN ERROR: Model refresht perfect, relationele integriteit klopt
-- 8. WAPEN: Dubbele Records in DIM Table
-- 9. EFFECT: Elke verkoop matched met 2 producten = dubbele telling
-- 10. LOCATIE: Semantisch Model (waar relaties actief zijn)
-- 11. SYMPTOOM: Dashboard toont 180% groei, Sales Kickoff chaos

-- =============================================
-- MENSELIJK GEDRAG:
-- =============================================
-- - Deadline stress: "Moet vandaag nog live"
-- - Haast maakt fouten: Vergeet cleanup stap
-- - Geen validatie: Geen tijd om cijfers te checken
-- - Onbedoeld succes: Sales team euforisch over "groei"
-- - Victim: Finance team verward door onmogelijke cijfers
-- - Timing: Jaar-einde + Sales Kickoff = maximale druk

-- =============================================
-- AGENT HINTS MOGELIJKHEDEN:
-- =============================================

-- Schoonmaker:
-- "Die laatste werkdag voor kerst was hectisch. Ik hoorde de Product Manager 
-- tegen de Developer schreeuwen: '847 nieuwe codes, moet vandaag nog klaar!
-- Morgen is Sales Kickoff!' De Developer zat tot 8 uur 's avonds te werken.
-- Ik hoorde hem mompelen: 'Gewoon kopieren en plakken, geen tijd voor checks.'"

-- Receptionist:
-- "De Product Manager kwam die dag in paniek binnen: 'Nieuwe productcodes moeten
-- vandaag live!' De Developer werkte heel laat door. De volgende dag was de 
-- Sales Kickoff - ik hoorde het Sales team juichen: '180% groei!' Maar de 
-- Financial Controller belde direct: 'Deze cijfers kloppen niet.' De Database
-- Beheerder was met kerstvakantie die week."

-- Stagiair:
-- "Ik zag de Developer data importeren in de DIM_Product tabel. Hij deed
-- copy-paste vanuit Excel. Maar als je eerst niet de oude staging records 
-- verwijdert, krijg je duplicaten. Elk product staat dan twee keer in de 
-- dimensietabel. Als je een FACT tabel joined met een DIM die dubbele keys heeft,
-- matched elke verkoop met twee producten. Klassieke Cartesian product fout.
-- De cijfers verdubbelen letterlijk."

-- =============================================
-- SITUATIE VOOR BEURSBEZOEKER:
-- =============================================
-- "Het sales dashboard toont extreme groeicijfers - 180% omzetstijging in één maand.
-- Tijdens de Sales Kickoff waren alle verkopers dolenthousiast. Maar Finance
-- belt direct: 'Dit kan niet kloppen, onze bank statements tonen normale cijfers.'
-- Elke transactie telt dubbel in alle visuals. Product lijst toont elk artikel
-- twee keer. Het ziet er niet uit als een error - het dashboard werkt perfect,
-- maar de cijfers zijn gewoon 2x te hoog."

-- =============================================
-- TECHNISCHE ACCURATESSE:
-- =============================================
-- ✅ Power BI Developer beheert dimensietabellen
-- ✅ DIM_Product dubbele records is realistische fout
-- ✅ Import zonder cleanup = staging data blijft staan
-- ✅ Relationele join met dubbele keys = Cartesian product
-- ✅ Elke FACT row matched met 2 DIM rows = dubbele cijfers
-- ✅ Model refresht zonder errors (geen referential integrity check)
-- ✅ Semantisch Model is waar de relaties actief zijn

-- =============================================
-- WAAROM QUICK WIN:
-- =============================================
-- - Techniek was al goed (5/5)
-- - Developer is betere persona match dan Database Beheerder
-- - Storytelling sterk verbeterd: deadline stress, Sales Kickoff drama
-- - Menselijk gedrag: haast, vergeten cleanup, geen validatie
-- - Speelbaarheid: agents kunnen jaar-einde chaos vertellen
-- - Causale keten rijker: van deadline → import → dubbeling → Kickoff chaos

-- =============================================
-- SCORE VERWACHTING:
-- =============================================
-- Realisme: 5/5 (Zeer herkenbaar - jaar-einde import stress)
-- Logica: 5/5 (Perfecte causale keten: stress → haast → fout → dubbeling)
-- Techniek: 5/5 (Blijft technisch perfect)
-- Speelbaarheid: 5/5 (Agents kunnen import chaos en Kickoff drama vertellen)
-- Storytelling: 5/5 (Rijke story: deadline → chaos → onbedoeld succes → Finance alarm)
-- TOTAAL: 5.0/5 ⭐⭐⭐⭐⭐

SELECT 'Scenario 11 verbeterd van 3.6/5 naar verwacht 5.0/5' as status;
