# DATABASE STATE - POWER BI MURDER MYSTERY
# Laatste update: 2026-01-19 na geslacht toevoeging

## SUPABASE PROJECT
- Project ID: eiynfrgezfyncoqaemfr
- Edge Functions: agent-chat (Deno TypeScript, OpenAI gpt-4o-mini)

## ACTIEVE SCENARIOS

### Scenario 9: De Bronsysteem Migratie
- persoon_id: 3 (Database Beheerder - vrouw)
- wapen_id: 6 (Kolomnaam Gewijzigd)
- locatie_id: 3 (Semantisch Model)
- archive_flag: 0
- Hints: 3 (Schoonmaker, Receptionist, Stagiair)

### Scenario 12: De Demo Stress
- persoon_id: 1 (Power BI Developer - vrouw)
- wapen_id: 2 (Hidden Slicer)
- locatie_id: 4 (Report View - Selection Pane)
- archive_flag: 0
- Hints: 3 (Schoonmaker, Receptionist, Stagiair)

### Scenario 26: De Sales Kickoff Chaos
- persoon_id: 3 (Database Beheerder - vrouw)
- wapen_id: 3 (Dubbele Records)
- locatie_id: 7 (Database)
- archive_flag: 0
- Hints: 3 (Schoonmaker, Receptionist, Stagiair)
- STATUS: ✅ COMPLEET - beschrijving + hints gefixed met vrouwelijke voornaamwoorden

### Scenario 27: De Budget Vergelijking ✨ NIEUW
- persoon_id: 4 (Financial Controller - man)
- wapen_id: 5 (Budget Niet Updated)
- locatie_id: 1 (OneDrive)
- situatie_beschrijving: "De CFO toont vol trots tijdens de board meeting de laatste cijfers. Maar komt er vervolgens achter dat de budgetten niet kloppen. Wat is hier aan de hand?!"
- archive_flag: 0
- Hints: 3 (Schoonmaker, Receptionist, Stagiair)

### Scenario 28: De Refresh Failure ✨ NIEUW
- persoon_id: 1 (Power BI Developer - vrouw)
- wapen_id: 4 (Hardcoded Pad)
- locatie_id: 2 (Power Query Editor)
- situatie_beschrijving: "Het sales dashboard refresht al een week niet meer. Management kijkt naar verouderde cijfers zonder het door te hebben. De error log toont 'File not found'. Hoe kan dat?"
- archive_flag: 0
- Hints: 3 (Schoonmaker, Receptionist, Stagiair)

### Scenario 29: De Filter Fail ✨ NIEUW
- persoon_id: 1 (Power BI Developer - vrouw)
- wapen_id: 1 (Inactieve Relatie)
- locatie_id: 3 (Semantisch Model)
- situatie_beschrijving: "Filters werken plotseling niet meer. Sales selecteert een product, maar de cijfers veranderen niet. Totalen zijn veel te hoog. Gisteren werkte alles nog perfect!"
- archive_flag: 0
- Hints: 3 (Schoonmaker, Receptionist, Stagiair)

### Scenario 30: De Budget Backup Blunder ✨ NIEUW
- persoon_id: 4 (Financial Controller - man)
- wapen_id: 3 (Dubbele Records)
- locatie_id: 1 (OneDrive)
- situatie_beschrijving: "Het Q1 budget dashboard toont plotseling het dubbele van de verwachte cijfers. Alle budget totalen zijn 2x zo hoog. De CFO is in paniek: 'Hebben we echt zoveel budget?' Gisteren klopte alles nog."
- archive_flag: 0
- Hints: 3 (Schoonmaker, Receptionist, Stagiair)

### Scenario 31: De Hoofdletter Catastrofe ✨ NIEUW
- persoon_id: 4 (Financial Controller - man)
- wapen_id: 6 (Kolomnaam Gewijzigd)
- locatie_id: 3 (Semantisch Model)
- situatie_beschrijving: "Het dashboard toont alleen foutmeldingen. Alle measures zijn rood. Error: 'Can't find column Revenue_Amount'. Gisteren werkte alles nog perfect. Wat is er gebeurd?"
- archive_flag: 0
- Hints: 3 (Schoonmaker, Receptionist, Stagiair)

### Scenario 32: De Stille Stop ✨ NIEUW
- persoon_id: 1 (Power BI Developer - vrouw)
- wapen_id: 7 (Refresh Uitgeschakeld)
- locatie_id: 2 (Power Query Editor)
- situatie_beschrijving: "Het sales dashboard draait perfect, maar de cijfers kloppen niet. Een manager merkt op: 'Dit zijn de cijfers van vorige week!' Andere tabellen zijn WEL up-to-date. Waarom refresht deze ene tabel niet mee?"
- archive_flag: 0
- Hints: 3 (Schoonmaker, Receptionist, Stagiair)

## PERSONEN (Daders)
1. Power BI Developer - vrouw - NFC: 3032948996
2. (BESTAAT NIET - ID 2 is leeg)
3. Database Beheerder - vrouw - NFC: 0458378500
4. Financial Controller - man - NFC: TEMP_NFC_PERSON_04

## WAPENS (Moordwapens)
1. Inactieve Relatie - NFC: TEMP_NFC_WEAPON_1 ✨ NIEUW
2. Hidden Slicer - NFC: TEMP_NFC_WEAPON_2
3. Dubbele Records - NFC: TEMP_NFC_WEAPON_3
4. Hardcoded Pad - NFC: TEMP_NFC_WEAPON_4 ✨ NIEUW
5. Budget Niet Updated - NFC: TEMP_NFC_WEAPON_5 ✨ NIEUW
6. Kolomnaam Gewijzigd - NFC: TEMP_NFC_WEAPON_6
7. Refresh Uitgeschakeld - NFC: TEMP_NFC_WEAPON_7 ✨ NIEUW

## LOCATIES (Crime Scenes)
1. OneDrive - NFC: TEMP_NFC_LOCATION_1 ✨ NIEUW
2. Power Query Editor - NFC: TEMP_NFC_LOCATION_2 ✨ NIEUW
3. Semantisch Model - NFC: TEMP_NFC_LOCATION_3
4. Report View - Selection Pane - NFC: TEMP_NFC_LOCATION_4
7. Database - NFC: TEMP_NFC_LOCATION_DATABASE

## AGENTS (Hint givers)
1. Schoonmaker - NFC: (onbekend)
2. Receptionist - NFC: (onbekend)
3. Stagiair - NFC: (onbekend)

## SPECIAL NFC CODES
- START: TEMP_NFC_START
- EXIT: 0527212036
- RESET: TEMP_NFC_RESET
- PORTFOLIO: TEMP_NFC_PORTFOLIO
## OPENSTAANDE ACTIES
1. ✅ Geslacht kolom toegevoegd aan personen
2. ✅ Edge Function updated met geslacht info
3. ✅ Scenario 26 gefixed (locatie_id=7, vrouwelijke voornaamwoorden)
4. ✅ Interface gefixed - Database locatie button toegevoegd
5. ✅ Many-to-Many vervangen door Inactieve Relatie in interface + database
6. ✅ 4 nieuwe wapens toegevoegd: Inactieve Relatie, Hardcoded Pad, Budget Niet Updated, Refresh Uitgeschakeld
7. ✅ 2 nieuwe locaties toegevoegd: OneDrive, Power Query Editor
8. ✅ 6 nieuwe scenarios gemaakt: 27, 28, 29, 30, 31, 32
9. ✅ Alle scenarios hebben naam + situatie_beschrijving + beschrijving + hints
9. ✅ Alle scenarios hebben naam + situatie_beschrijving + beschrijving + hints
10. ❌ NFC pasjes bestellen:
   - Financial Controller (persoon 4) - TEMP_NFC_PERSON_04
   - Database locatie (locatie 7) - TEMP_NFC_LOCATION_DATABASE
   - Inactieve Relatie (wapen 1) - TEMP_NFC_WEAPON_1
   - Hardcoded Pad (wapen 4) - TEMP_NFC_WEAPON_4
## INTERFACE STATUS
✅ **templates/game.html** - Test buttons compleet:
- Personen: Power BI Developer, Financial Controller, Database Beheerder (3/3)
- Wapens: Inactieve Relatie, Hidden Slicer, Dubbele Records, Hardcoded Pad, Budget Niet Updated, Kolomnaam Gewijzigd, Refresh Uitgeschakeld (7/7)
- Locaties: OneDrive, Power Query Editor, Semantisch Model, Report View - Selection Pane, Database (5/5)
- Agents: Schoonmaker, Receptionist, Stagiair (3/3)

Alle 9 scenarios zijn nu volledig speelbaar via de interface!
Alle 6 scenarios zijn nu volledig speelbaar via de interface!NFC codes
6. ⏳ VOLGENDE: Scenarios testen en nieuwe scenarios bedenken

## INTERFACE STATUS
✅ **templates/game.html** - Test buttons compleet:
- Personen: Power BI Developer, Financial Controller, Database Beheerder (3/3)
- Wapens: Many-to-Many, Hidden Slicer, Dubbele Records, Hardcoded Pad, Budget Niet Updated, Kolomnaam Gewijzigd (6/6)
- Locaties: OneDrive, Power Query Editor, Semantisch Model, Report View - Selection Pane, Database (5/5)
- Agents: Schoonmaker, Receptionist, Stagiair (3/3)

Alle scenarios zijn nu volledig speelbaar via de interface!
Wanneer nieuwe scenario/persoon/wapen/locatie wordt toegevoegd:
- [ ] Database record aanmaken
- [ ] NFC code toewijzen (temp of definitief)
- [ ] Interface select/dropdown updaten
- [ ] Fysiek houten pasje bestellen met NFC tag
- [ ] Testen in game flow

## SCENARIO STRUCTUUR - BELANGRIJK!
**Bij het maken van een nieuw scenario ALTIJD alle velden invullen:**

```sql
INSERT INTO scenarios (id, persoon_id, wapen_id, locatie_id, naam, situatie_beschrijving, beschrijving, archive_flag)
VALUES (
  XX,
  Y, -- Persoon ID (dader)
  Z, -- Wapen ID (wat ging er mis)
  W, -- Locatie ID (waar)
  'Scenario Naam',
  'Korte spannende beschrijving voor de speler - GEEN oplossing weggeven!',
  'Volledige achtergrond met oplossing - dit zien spelers NIET',
  0
);
```

**Kolommen:**
- `naam`: Titel van scenario (bijv. "De Budget Vergelijking")
- `situatie_beschrijving`: Wat de speler ziet aan het begin - kort, spannend, geen oplossing
- `beschrijving`: De volledige oplossing - wat echt gebeurde, wie het deed
- `persoon_id`, `wapen_id`, `locatie_id`: IDs die de speler moet raden

**Hints:** Elke scenario krijgt 3 hints (agent_id 1, 2, 3):
- Agent 1 (Schoonmaker): Visuele observaties, details van bureau/kantoor
- Agent 2 (Receptionist): Gesprekken, sociale interacties
- Agent 3 (Stagiair): Technische details, logs, systeem observaties

**Stijl hints:** Emotie, visueel, character, tijdsdruk, realisme (vakantie, meetings, stress)


- Haalt conversation history (laatste 10 berichten per game_id + agent_id)
- Haalt agent achtergrond + tone_of_voice
- Haalt scenario hint voor specifieke agent
- Haalt persoon info (incl. geslacht!) voor correcte voornaamwoorden
- OpenAI krijgt instructie: gebruik zij/haar voor vrouw, hij/hem voor man

## DEPLOYMENT
- Edge Functions: `supabase functions deploy agent-chat`
- Instant live, geen restart nodig

## POWER BI HORROR SCENARIOS (brainstorm lijst)
Realistische problemen die kunnen leiden tot nieuwe scenarios:
- Excel file verplaatst (refresh break)
- Gateway offline tijdens vakantie
- Row Level Security per ongeluk actief op demo account
- Measure verwijderd die andere measures gebruikten (cascading fail)
- DirectQuery timeout door traag netwerk
- Premium capacity overload (throttling)
- Workspace verplaatst, embedden breekt
- Data source credentials expired
- Incremental refresh verkeerd geconfigureerd (duplicates)
- Date table missing (chaos in time intelligence)

## HINTS SCHRIJVEN - USER STYLE
- Emotie: "rommelkont", "kopjes met laagje koffie"
- Visueel: "trechter met oogje" ipv "Selection Pane"
- Character: "Wazige gast", "knappe Financial Controller"
- Tijdsdruk: laatste werkdag, haast, borrel
- Realisme: voetbal, vakantie, meetings
