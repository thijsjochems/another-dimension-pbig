-- =============================================
-- SCENARIO 13: De OneDrive Sync - HERSCHREVEN
-- =============================================

-- OUDE VERSIE (Score: 3.0/5):
-- Financial Controller + Hardcoded Excel Pad + OneDrive
-- Probleem: Controller veroorzaakt geen hardcoded paden, dat is Developer werk

-- NIEUWE VERSIE (Verbeterd):
-- Financial Controller + Budgetten Niet Geüpdatet + OneDrive

UPDATE scenarios 
SET 
    persoon_id = 2, -- Financial Controller (correct)
    wapen_id = 5, -- Budgetten Niet Geüpdatet (past bij Controller)
    locatie_id = 1, -- OneDrive (correct)
    naam = 'De OneDrive Reorganisatie',
    beschrijving = 'Begin Q4 reorganiseerde de Financial Controller haar OneDrive structuur. Ze verplaatste het budget Excel bestand naar een nieuwe "2024 Budgets" folder zonder het team te informeren. De Power BI Developer had het pad hardcoded naar de oude locatie. Niemand zag dat de refresh faalde - het dashboard toonde nog steeds de Q3 budgetten terwijl iedereen dacht dat het Q4 cijfers waren.',
    situatie_beschrijving = 'Dashboard toont verouderde budgetcijfers. Actuals vs Budget vergelijking klopt niet. Management ziet Q3 budgetten maar denkt dat het Q4 cijfers zijn. Geen error melding, maar cijfers zijn gewoon fout.'
WHERE id = 13;

-- =============================================
-- CAUSALE KETEN (Verbeterd):
-- =============================================
-- 1. Financial Controller (REDEN): Wil OneDrive opruimen voor nieuw kwartaal
-- 2. ACTIE: Verplaatst budget bestand naar nieuwe folder structuur
-- 3. VERGEET: Team/Developer te informeren over nieuwe locatie
-- 4. GEVOLG: Hardcoded pad in Power Query wijst naar oude locatie
-- 5. WAPEN: Budgetten Niet Geüpdatet (refresh faalt stilletjes, oude data blijft)
-- 6. LOCATIE: OneDrive (waar bestand staat)
-- 7. SYMPTOOM: Dashboard toont Q3 budgetten terwijl Q4 verwacht wordt

-- =============================================
-- MENSELIJK GEDRAG:
-- =============================================
-- - Onbewust onbekwaam: Controller weet niet dat pad hardcoded is
-- - Miscommunicatie: Vergat Developer te informeren
-- - Normale actie: Opruimen OneDrive is logisch voor nieuwe kwartaal
-- - Stille fout: Geen error, maar verkeerde data

-- =============================================
-- AGENT HINTS MOGELIJKHEDEN:
-- =============================================

-- Schoonmaker:
-- "Begin Q4 hoorde ik de Financial Controller zeggen: 'Eindelijk mijn OneDrive opgeruimd!' 
-- Ze had dozen vol met oude bestanden verplaatst naar nieuwe folders. 
-- Klonk trots op haar werk."

-- Receptionist:
-- "De Financial Controller was begin Q4 druk met de Q4 budgetten klaarmaken.
-- Ik zag haar presentatie voorbereiden over de nieuwe kwartaalcijfers.
-- De Power BI Developer was die week gewoon op kantoor, deed zijn normale werk.
-- Database Beheerder was met vakantie."

-- Stagiair:
-- "Ik zag de Financial Controller bezig in haar OneDrive. Ze maakte nieuwe folders aan
-- voor Q4 en verplaatste bestanden. Ik dacht: als Power Query een hardcoded pad heeft
-- naar die bestanden, dan gaat de refresh falen. Maar niemand kreeg een error - 
-- het oude budget bestand stond er nog, dus Power Query laadde gewoon de oude cijfers."

-- =============================================
-- SITUATIE VOOR BEURSBEZOEKER:
-- =============================================
-- "Het dashboard toont verkeerde budgetcijfers. Het zijn nog de Q3 budgetten,
-- maar iedereen denkt dat het Q4 cijfers zijn. Actuals vs Budget analyses 
-- kloppen niet meer. Er is geen error melding - het ziet eruit alsof alles werkt,
-- maar de cijfers zijn gewoon verouderd."

-- =============================================
-- TECHNISCHE ACCURATESSE:
-- =============================================
-- ✅ Financial Controller beheert budget Excel bestanden
-- ✅ OneDrive reorganisatie is normale taak voor Controller
-- ✅ Hardcoded pad in Power Query blijft wijzen naar oude locatie
-- ✅ Als oude bestand blijft staan: refresh werkt, maar met oude data
-- ✅ Geen error = stille fout, moeilijk te detecteren
-- ✅ Locatie (OneDrive) is waar de actie plaatsvond

-- =============================================
-- NIEUWE SCORE VERWACHTING:
-- =============================================
-- Realisme: 5/5 (Zeer herkenbaar)
-- Logica: 5/5 (Perfecte causale keten)
-- Techniek: 5/5 (Klopt volledig)
-- Speelbaarheid: 5/5 (Agents kunnen hints geven)
-- Storytelling: 4/5 (Menselijk gedrag, vergeetfout)
-- TOTAAL: 4.8/5 ⭐⭐⭐⭐⭐

SELECT 'Scenario 13 verbeterd van 3.0/5 naar verwacht 4.8/5' as status;
