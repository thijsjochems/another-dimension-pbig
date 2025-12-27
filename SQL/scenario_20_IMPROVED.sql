-- =============================================
-- SCENARIO 20: De Vakantie Vergissing - VERBETERD
-- =============================================

-- OUDE VERSIE (Score: 3.6/5):
-- Power BI Developer + Budgetten Niet Geüpdatet + Semantisch Model
-- Goede basis, maar kan rijkere story gebruiken

-- NIEUWE VERSIE (Verbeterd):
-- Zelfde combinatie, maar met zomervakantie context en "bandwidth besparen" reden

-- Eerst de kolom toevoegen aan de scenarios tabel (indien nodig)
ALTER TABLE scenarios 
ADD COLUMN IF NOT EXISTS situatie_beschrijving TEXT;

-- Nu de update uitvoeren
UPDATE scenarios 
SET 
    persoon_id = 1, -- Power BI Developer (correct)
    wapen_id = 5, -- Budgetten Niet Geüpdatet (correct voor oude data)
    locatie_id = 3, -- Semantisch Model (correct)
    naam = 'De Zomervakantie Bandwidth',
    beschrijving = 'Augustus, laatste dag voor zomervakantie. De Power BI Developer las een artikel over "optimaliseer je Power BI voor vakantieperiode". Hij zette de scheduled refresh uit: "3 weken niemand op kantoor, waarom bandwidth verspillen?" Maakte een TODO notitie: "Na vakantie refresh aanzetten". Drie weken Griekenland, volledig disconnected. Eerste dag terug - inbox chaos, meetings, brand nieuwe Q3 projecten. De TODO notitie verdween in de digitale ruis. September, oktober - dashboard draaide op augustus data. In november vroeg Sales: "Waarom zijn de Q3 cijfers nog niet zichtbaar?" Developer checkt: laatste refresh 2 augustus. Drie maanden oude data.',
    situatie_beschrijving = 'Dashboard toont data van 3 maanden geleden (augustus). Q3 verkoopcijfers ontbreken volledig. Sales rapportages zijn gebaseerd op verouderde zomerdata. November analyses gebruiken augustus cijfers. Management vraagt waarom Q3 resultaten niet zichtbaar zijn.'
WHERE id = 20;

-- =============================================
-- CAUSALE KETEN (Verbeterd):
-- =============================================
-- 1. Power BI Developer (CONTEXT): Laatste dag voor 3 weken zomervakantie
-- 2. ARTIKEL: Leest "optimaliseer Power BI tijdens vakantie"
-- 3. IDEE: "Waarom bandwidth verspillen als niemand op kantoor is?"
-- 4. ACTIE: Zet scheduled refresh uit voor vakantieperiode
-- 5. INTENTIE: Maakt TODO notitie "na vakantie aanzetten"
-- 6. VAKANTIE: 3 weken Griekenland, volledig disconnected
-- 7. TERUGKOMST: Inbox chaos, meetings, nieuwe Q3 projecten
-- 8. VERGETEN: TODO notitie verdwijnt in digitale ruis
-- 9. TIJD: September, oktober verlopen zonder refresh
-- 10. WAPEN: Budgetten Niet Geüpdatet (data is 3 maanden oud)
-- 11. LOCATIE: Semantisch Model (waar refresh moet gebeuren)
-- 12. ONTDEKKING: November - Sales vraagt naar Q3 cijfers

-- =============================================
-- MENSELIJK GEDRAG:
-- =============================================
-- - Good intentions: Wil bandwidth optimaliseren
-- - Pre-vacation brain: Niet volledig doordenken van gevolgen
-- - TODO hell: Notitie verdwijnt na vakantie in inbox chaos
-- - Context overload: Terugkomst = meetings + nieuwe projecten
-- - Gradual blindness: Niemand merkt dagelijks dat data oud is
-- - Long discovery: Pas na 3 maanden ontdekt
-- - Optimization trap: Oplossing voor klein probleem creëert groot probleem

-- =============================================
-- AGENT HINTS MOGELIJKHEDEN:
-- =============================================

-- Schoonmaker:
-- "Begin augustus, laatste werkdag voor vakantie. De Developer was relaxed -
-- hij ging naar Griekenland. Ik hoorde hem tegen collega zeggen: 'Ik zet de 
-- refresh uit voor de vakantie, scheelt bandwidth. Zet hem wel weer aan na 
-- terugkomst.' Hij maakte een notitie op een Post-it. Toen hij terugkwam begin
-- september was het chaos - meetings, emails. Die Post-it was weg."

-- Receptionist:
-- "De Developer was drie weken met zomervakantie in augustus. Toen hij terugkwam
-- was het direct druk - Q3 nieuwe projecten, meetings met management. In november
-- belde Sales: 'Waar zijn de Q3 cijfers in het dashboard?' Niemand had het eerder
-- opgemerkt. De Financial Controller was ook in augustus met vakantie geweest,
-- Database Beheerder ook. Iedereen dacht dat iemand anders de data checkte."

-- Stagiair:
-- "Scheduled refresh uitzetten tijdens vakantie klinkt slim - waarom resources
-- gebruiken als niemand kijkt? Maar je moet het wél weer aanzetten. Als je dat
-- vergeet, blijft je model op oude data staan. Het Semantisch Model toont geen
-- waarschuwing 'Data is 3 maanden oud'. Gebruikers zien normale visuals, normale
-- cijfers - ze checken niet altijd de laatste refresh datum in de footer. Stille
-- fout, pas ontdekt als iemand expliciet naar recente data vraagt."

-- =============================================
-- SITUATIE VOOR BEURSBEZOEKER:
-- =============================================
-- "Het dashboard werkt perfect, maar toont augustus data - het is nu november.
-- Q3 verkoopcijfers (september, oktober) ontbreken volledig. Sales rapportages
-- zijn gebaseerd op zomerdata. Management wil Q3 performance bespreken maar ziet
-- alleen augustus cijfers. Het ziet er niet uit als een error - alle visuals
-- werken mooi, maar de datum in de footer toont: 'Laatste refresh: 2 augustus'.
-- Drie maanden productiestilstand zonder dat iemand het merkte."

-- =============================================
-- TECHNISCHE ACCURATESSE:
-- =============================================
-- ✅ Power BI Developer beheert scheduled refresh settings
-- ✅ Refresh uitzetten tijdens vakantie is begrijpelijke (maar riskante) keuze
-- ✅ TODO notities verdwijnen in post-vacation chaos
-- ✅ Semantisch Model refresht alleen als schedule actief is
-- ✅ Geen automatic warning voor "data is oud"
-- ✅ Gradual blindness: gebruikers checken datum niet dagelijks
-- ✅ "Budgetten Niet Geüpdatet" = data is verouderd/niet gerefresht

-- =============================================
-- WAAROM QUICK WIN:
-- =============================================
-- - Techniek was al goed (5/5)
-- - Storytelling verbeterd: vakantie optimalisatie, TODO chaos, 3 maanden blind
-- - Menselijk gedrag: good intentions, post-vacation overload, gradual blindness
-- - Speelbaarheid: agents kunnen vakantie en terugkomst chaos vertellen
-- - Causale keten rijker: van optimalisatie idee tot 3 maanden data-stilstand

-- =============================================
-- SCORE VERWACHTING:
-- =============================================
-- Realisme: 5/5 (Zeer herkenbaar - post-vacation TODO's vergeten)
-- Logica: 5/5 (Perfecte causale keten: optimalisatie → vakantie → chaos → vergeten)
-- Techniek: 5/5 (Blijft technisch perfect)
-- Speelbaarheid: 5/5 (Agents kunnen vakantie en discovery story vertellen)
-- Storytelling: 5/5 (Rijke story: good intentions → vakantie → TODO hell → 3 maanden blind)
-- TOTAAL: 5.0/5 ⭐⭐⭐⭐⭐

SELECT 'Scenario 20 verbeterd van 3.6/5 naar verwacht 5.0/5' as status;
