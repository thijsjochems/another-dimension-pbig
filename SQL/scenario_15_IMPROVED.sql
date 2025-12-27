-- =============================================
-- SCENARIO 15: De Jaar-einde Drukte - VERBETERD
-- =============================================

-- OUDE VERSIE (Score: 3.6/5):
-- Financial Controller + Budgetten Niet Geüpdatet + OneDrive
-- Goede basis, maar kan rijkere story en menselijk gedrag gebruiken

-- NIEUWE VERSIE (Verbeterd):
-- Zelfde combinatie, maar met jaar-einde chaos en "Final FINAL v3" drama

-- Eerst de kolom toevoegen aan de scenarios tabel (indien nodig)
ALTER TABLE scenarios 
ADD COLUMN IF NOT EXISTS situatie_beschrijving TEXT;

-- Nu de update uitvoeren
UPDATE scenarios 
SET 
    persoon_id = 2, -- Financial Controller (correct)
    wapen_id = 5, -- Budgetten Niet Geüpdatet (correct)
    locatie_id = 1, -- OneDrive (correct)
    naam = 'De Final FINAL v3',
    beschrijving = 'Laatste werkweek van december. De Financial Controller kreeg om 16:00 op 30 december nog laatste budget wijzigingen van de Board. Versie 8 van het budget Excel bestand. Ze maakte een nieuwe folder: "2024 Budget FINAL definitief laatste versie echt de laatste". Uploadde het nieuwe bestand. Stuurde een Teams message: "Nieuwe budgetten in OneDrive!" Maar het Power BI pad wees nog naar de oude "2024 Budget" folder. De Power BI Developer was al met kerstvakantie. Het dashboard bleef de oude budgetten tonen - hele Q1 2025 werkten managers met verouderde targets. In maart vroeg Sales waarom hun targets niet matchten met wat ze op papier hadden.',
    situatie_beschrijving = 'Dashboard toont oude 2024 budgetten. Q1 2025 targets kloppen niet. Sales managers zien andere cijfers op papier dan in dashboard. Budget vs Actual analyses zijn fout. Marketing werkt met verkeerde Q1 targets. Pas in maart ontdekt iemand de mismatch.'
WHERE id = 15;

-- =============================================
-- CAUSALE KETEN (Verbeterd):
-- =============================================
-- 1. Financial Controller (CONTEXT): Laatste werkweek december, Board meeting
-- 2. LAST MINUTE CHANGE: 16:00 op 30 december - versie 8 budget wijzigingen
-- 3. ACTIE: Maakt nieuwe folder met "ultieme definitieve" naam
-- 4. UPLOAD: Nieuwe budget Excel in nieuwe folder
-- 5. COMMUNICATIE: Teams message "Nieuwe budgetten in OneDrive!"
-- 6. PROBLEEM: Power BI pad wijst naar oude folder
-- 7. TIMING: Developer al met kerstvakantie
-- 8. GEVOLG: Dashboard blijft oude budgetten laden
-- 9. WAPEN: Budgetten Niet Geüpdatet (laadt oude versie)
-- 10. LOCATIE: OneDrive (waar nieuwe folder staat)
-- 11. DUUR: Hele Q1 2025 met verkeerde targets
-- 12. ONTDEKKING: Maart - Sales vraagt over mismatch

-- =============================================
-- MENSELIJK GEDRAG:
-- =============================================
-- - Jaar-einde stress: Last minute Board wijzigingen op 30 december
-- - Folder chaos: "FINAL definitief laatste versie echt de laatste"
-- - Goede intentie: Teams message om team te informeren
-- - Onbewust onbekwaam: Weet niet dat Power BI pad hardcoded is
-- - Timing victim: Developer al met vakantie, kan niet fixen
-- - Sluimerende fout: Pas na 3 maanden ontdekt
-- - Communication gap: Teams message ≠ technische update

-- =============================================
-- AGENT HINTS MOGELIJKHEDEN:
-- =============================================

-- Schoonmaker:
-- "30 december, 16:00. De Financial Controller was nog op kantoor - iedereen
-- was al naar huis. Ze zat gestrést aan de telefoon met de Board. Ik hoorde
-- haar zeggen: 'Alwéér budget wijzigingen? Dit is versie 8!' Later hoorde ik
-- haar typen: 'FINAL... definitief... laatste versie... echt de laatste.'
-- Ze mompelde: 'Nu kunnen ze niet nog een keer om wijzigingen vragen.'"

-- Receptionist:
-- "De laatste werkweek was chaos. De Financial Controller kreeg op 30 december
-- nog wijzigingen van de Board - ze was gefrustreerd. Ze stuurde een Teams
-- message: 'Nieuwe budgetten in OneDrive!' De Power BI Developer was al met
-- kerstvakantie sinds 23 december. Database Beheerder ook. In januari kreeg ik
-- vragen van Sales managers: 'Waarom kloppen de dashboard targets niet met de 
-- papieren versie?' Maar niemand maakte de link met die nieuwe folder."

-- Stagiair:
-- "Ik zag die OneDrive folder: '2024 Budget FINAL definitief laatste versie 
-- echt de laatste'. Klassiek jaar-einde folder chaos. Maar Power Query heeft
-- een hardcoded pad. Als je in OneDrive een nieuwe folder maakt en het bestand
-- daarin zet, moet je het Power Query pad updaten. Anders blijft Power BI de
-- oude folder inlezen. Een Teams message is niet genoeg - je moet letterlijk
-- in Power Query Editor het Source pad aanpassen. Dat kan alleen een Developer."

-- =============================================
-- SITUATIE VOOR BEURSBEZOEKER:
-- =============================================
-- "Het dashboard toont 2024 budgetten, maar het is al Q1 2025. Sales managers
-- hebben papieren targets die niet matchen met het dashboard. Marketing werkt
-- met verkeerde Q1 budgetten. Budget vs Actual vergelijkingen zijn fout.
-- Niemand weet waarom - de Financial Controller zegt: 'Ik heb de nieuwe budgetten
-- toch ge-upload!' Het ziet er niet uit als een error - het dashboard werkt
-- perfect en toont mooie cijfers, maar het zijn gewoon de verkeerde budgetten
-- uit de verkeerde folder."

-- =============================================
-- TECHNISCHE ACCURATESSE:
-- =============================================
-- ✅ Financial Controller beheert budget Excel bestanden
-- ✅ OneDrive folder chaos is zeer herkenbaar
-- ✅ "FINAL definitief laatste versie" naming is realistisch
-- ✅ Power Query hardcoded pad blijft naar oude folder wijzen
-- ✅ Teams message informeert team, maar lost technisch probleem niet op
-- ✅ Developer op vakantie = kan niet snel fixen
-- ✅ Sluimerende fout: maanden onopgemerkt

-- =============================================
-- WAAROM QUICK WIN:
-- =============================================
-- - Logica en techniek waren al goed (5/5)
-- - Storytelling sterk verbeterd: jaar-einde stress, "versie 8", folder naam chaos
-- - Menselijk gedrag: last minute wijzigingen, goede intentie maar verkeerde uitvoering
-- - Speelbaarheid: agents kunnen jaar-einde chaos en folder naming drama vertellen
-- - Causale keten rijker: van Board wijziging tot 3 maanden verkeerde targets

-- =============================================
-- SCORE VERWACHTING:
-- =============================================
-- Realisme: 5/5 (Zeer herkenbaar - jaar-einde budget chaos met "FINAL v3" folders)
-- Logica: 5/5 (Perfecte causale keten: last minute change → nieuwe folder → oude pad)
-- Techniek: 5/5 (Blijft technisch perfect)
-- Speelbaarheid: 5/5 (Agents kunnen stress en folder chaos vertellen)
-- Storytelling: 5/5 (Rijke story: versie 8 → FINAL v3 folder → 3 maanden fout)
-- TOTAAL: 5.0/5 ⭐⭐⭐⭐⭐

SELECT 'Scenario 15 verbeterd van 3.6/5 naar verwacht 5.0/5' as status;
