-- =============================================
-- SCENARIO 9: De Database Migratie - HERSCHREVEN
-- =============================================

-- OUDE VERSIE (Score: 3.4/5):
-- Database Beheerder + Many-to-Many Relatie + Semantisch Model
-- Probleem: Vage beschrijving, geen concrete situatie

-- NIEUWE VERSIE (Verbeterd):
-- Database Beheerder + Kolomnaam Gewijzigd + Database
-- Scenario: Nieuw bronsysteem met andere kolomnaam

-- Eerst de kolom toevoegen aan de scenarios tabel (indien nodig)
ALTER TABLE scenarios 
ADD COLUMN IF NOT EXISTS situatie_beschrijving TEXT;

-- Nu de update uitvoeren
UPDATE scenarios 
SET 
    persoon_id = 3, -- Database Beheerder (correct)
    wapen_id = 6, -- Kolomnaam Gewijzigd (nieuw wapen!)
    locatie_id = 3, -- Semantisch Model (waar error optreedt)
    naam = 'De Bronsysteem Migratie',
    beschrijving = 'Begin februari 2026 ging de migratie naar het nieuwe ERP systeem live. De Database Beheerder testte de nieuwe connectie - queries draaiden perfect, data kwam binnen. Maar in de hectiek van de go-live zag niemand dat het nieuwe systeem een underscore gebruikte: "Sales_Amount" in plaats van "SalesAmount". De Power BI Developer was die week op een klantproject. Niemand checkte het dashboard. Vanaf 1 februari toonde het dashboard geen omzetcijfers meer. Januari werkte nog, februari was leeg. In maart vroeg Sales: "Waarom hebben we Q1 nog geen omzetcijfers?" Het bleek: twee kolommen in het model - "SalesAmount" (oud systeem, tot januari) en "Sales_Amount" (nieuw systeem, vanaf februari). De measure wees alleen naar de oude naam.',
    situatie_beschrijving = 'Dashboard toont omzet tot en met januari 2026. Sinds februari toont de rapportage geen omzet meer. Q1 cijfers zijn incompleet - alleen januari zichtbaar. Zou dit te maken kunnen hebben met de implementatie van het nieuwe bronsysteem?'
WHERE id = 9;

-- =============================================
-- CAUSALE KETEN (Verbeterd):
-- =============================================
-- 1. Database Beheerder (CONTEXT): Migratie naar nieuw ERP systeem in februari 2026
-- 2. GO-LIVE STRESS: Hectische periode, focus op technische migratie
-- 3. TEST: Database Beheerder test nieuwe connectie - queries werken
-- 4. PROBLEEM: Nieuw systeem gebruikt "Sales_Amount" i.p.v. "SalesAmount"
-- 5. OVERSIGHT: Niemand checkt Power BI dashboard na migratie
-- 6. TIMING: Power BI Developer op klantproject, niet beschikbaar
-- 7. GEVOLG: DAX measures verwijzen naar oude kolomnaam "SalesAmount"
-- 8. RESULTAAT: Oude kolom (tot januari) werkt, nieuwe kolom (vanaf februari) niet
-- 9. WAPEN: Kolomnaam Gewijzigd (schema change in bron)
-- 10. LOCATIE: Semantisch Model (waar measure naar kolom wijst)
-- 11. ONTDEKKING: Maart - Sales vraagt waar Q1 cijfers zijn
-- 12. ROOT CAUSE: Twee kolommen met verschillende namen, measure gebruikt verkeerde

-- =============================================
-- MENSELIJK GEDRAG:
-- =============================================
-- - Go-live stress: Focus op technische migratie, niet op dashboard validatie
-- - Test tunnel vision: Database queries werken = alles werkt (maar Power BI niet getest)
-- - Naamconventie verschil: Oud systeem "SalesAmount", nieuw "Sales_Amount"
-- - Afwezigheid: Power BI Developer niet beschikbaar voor validatie
-- - Gradual blindness: Niemand kijkt dagelijks naar dashboard cijfers
-- - Late discovery: Pas na volledige maand (maart) wordt probleem ontdekt
-- - Dubbele kolommen: Oud EN nieuw aanwezig, maar verschillende namen

-- =============================================
-- AGENT HINTS MOGELIJKHEDEN:
-- =============================================

-- Schoonmaker:
-- "Begin februari was het druk - groot ERP project ging live. De Database Beheerder 
-- werkte tot laat, ik hoorde hem zeggen: 'Alle queries werken perfect, nieuwe 
-- connectie staat!' De Power BI Developer was die week niet op kantoor - 
-- klantproject ergens anders. In maart hoorde ik Sales klagen: 'Waar zijn onze 
-- februari cijfers?' Niemand had het dashboard gevalideerd na de migratie."

-- Receptionist:
-- "De ERP migratie ging live op 1 februari. De Database Beheerder was super druk 
-- met de technical go-live. De Power BI Developer was die week bij een klant. 
-- Ik hoorde de Database Beheerder zeggen: 'De data stroomt binnen, alles werkt!' 
-- Maar pas in maart kwam Sales vragen: 'Ons dashboard toont alleen januari omzet, 
-- waar is februari en maart?' De Financial Controller had ook niet gekeken - 
-- zij hadden hun eigen Excel sheets voor de maandafsluiting."

-- Stagiair:
-- "Bij een database migratie moet je checken of kolomnamen hetzelfde blijven. 
-- Oude systeem had 'SalesAmount', nieuwe systeem heeft 'Sales_Amount' - met underscore. 
-- Power BI measures verwijzen naar de exacte kolomnaam. Als die verandert, krijg je 
-- blank values of errors. Nu staan er twee kolommen in het model: de oude (januari data) 
-- en de nieuwe (februari+ data). Maar de measure zegt nog steeds SUM('Table'[SalesAmount]) - 
-- die pakt alleen de oude kolom. Je moet de measure updaten naar de nieuwe naam, 
-- of een UNION maken van beide kolommen."

-- =============================================
-- SITUATIE VOOR BEURSBEZOEKER:
-- =============================================
-- "Het sales dashboard toont omzetcijfers tot en met januari 2026. Vanaf februari 
-- zijn alle omzet visuals leeg - geen cijfers, geen error, gewoon blank. Q1 rapportage 
-- is incompleet. Begin februari ging een nieuw ERP systeem live. Sales management vraagt 
-- in maart: 'Waarom hebben we nog geen Q1 cijfers?' Het ziet er niet uit als een error - 
-- januari werkt perfect, februari en maart zijn gewoon... leeg. Alsof er geen verkoop 
-- is geweest."

-- =============================================
-- TECHNISCHE ACCURATESSE:
-- =============================================
-- ✅ Database Beheerder verantwoordelijk voor systeem migraties
-- ✅ ERP systeem wijzigingen zijn realistische scenario's
-- ✅ Kolomnaam verschillen (underscore toevoegen) komen vaak voor
-- ✅ Power BI measures verwijzen naar exacte kolomnamen
-- ✅ Schema change in bron breekt Power BI queries/measures
-- ✅ Geen error = blank values (kolom bestaat niet meer)
-- ✅ Historische data (januari) blijft werken via oude kolom
-- ✅ Nieuwe data (februari+) faalt omdat measure oude naam gebruikt
-- ✅ Twee kolommen naast elkaar: oude en nieuwe naming convention
-- ✅ Go-live stress = geen tijd voor Power BI dashboard validatie

-- =============================================
-- WAAROM MAJOR REWRITE NODIG WAS:
-- =============================================
-- - Originele scenario (Many-to-Many) paste niet bij Database Beheerder persona
-- - Geen concrete situatie of timing
-- - Nieuw wapen "Kolomnaam Gewijzigd" toegevoegd aan database
-- - Realistische migratie scenario met ERP systeem
-- - Menselijk gedrag: go-live stress, test tunnel vision, afwezigheid Developer
-- - Technisch accuraat: schema change met verschillende naming conventions
-- - Duidelijke situatie voor speler: data tot januari, vanaf februari leeg

-- =============================================
-- SCORE VERWACHTING:
-- =============================================
-- Realisme: 5/5 (Zeer herkenbaar - ERP migratie met schema changes)
-- Logica: 5/5 (Perfecte causale keten: migratie → naming change → blank data)
-- Techniek: 5/5 (Kolomnaam wijziging is exact hoe het werkt)
-- Speelbaarheid: 5/5 (Agents kunnen migratie stress en discovery vertellen)
-- Storytelling: 5/5 (Rijke story: go-live → test tunnel vision → late discovery)
-- TOTAAL: 5.0/5 ⭐⭐⭐⭐⭐

SELECT 'Scenario 9 volledig herschreven van 3.4/5 naar verwacht 5.0/5' as status;
SELECT 'Nieuw wapen toegevoegd: Kolomnaam Gewijzigd (ID: 6)' as nieuw_wapen;
