# 🔍 Scenario Audit Report
**Generated:** 2025-12-27 00:40:13  
**Total Scenarios:** 21

---

## 📊 Summary Table

| ID | Naam | Persoon | Wapen | Locatie | R | L | T | S | ST | Total | Verdict |
|----|------|---------|-------|---------|---|---|---|---|----|----|---------|
| 7 | De Heidag Chaos | Power BI Develo | Hidden Slicer | Report View - S | 5 | 3 | 5 | 4 | 3 | **4.0** | **KEEP** |
| 6 | De Verkeerde Path | Financial Contr | Hardcoded Excel Pad | Power Query Edi | 5 | 2 | 1 | 4 | 2 | **2.8** | **REWRITE** |
| 5 | De Budget Stress | Financial Contr | Budgetten Niet Geüpd | OneDrive | 5 | 5 | 5 | 4 | 3 | **4.4** | **KEEP** |
| 18 | De Verborgen Filter Test | Power BI Develo | Hidden Slicer | Report View - S | 2 | 3 | 5 | 4 | 3 | **3.4** | **REWRITE** |
| 23 | De Snelle Fix | Power BI Develo | Dubbele Records in D | Power Query Edi | 5 | 3 | 2 | 5 | 3 | **3.6** | **REWRITE** |
| 4 | Q3 Budget Crisis | Financial Contr | Budgetten Niet Geüpd | OneDrive | 5 | 5 | 5 | 4 | 3 | **4.4** | **KEEP** |
| 8 | De Power BI Gebruikersdag | Power BI Develo | Budgetten Niet Geüpd | Semantisch Mode | 3 | 3 | 5 | 5 | 3 | **3.8** | **REWRITE** |
| 17 | De Database Cleanup | Database Beheer | Dubbele Records in D | Power Query Edi | 2 | 3 | 5 | 4 | 2 | **3.2** | **REWRITE** |
| 22 | De Test Environment | Database Beheer | Many-to-Many Relatie | Semantisch Mode | 1 | 3 | 5 | 4 | 3 | **3.2** | **REWRITE** |
| 16 | De Many-to-Many Model | Power BI Develo | Many-to-Many Relatie | Semantisch Mode | 2 | 3 | 5 | 4 | 3 | **3.4** | **REWRITE** |
| 15 | De Jaar-einde Drukte | Financial Contr | Budgetten Niet Geüpd | OneDrive | 2 | 5 | 5 | 4 | 2 | **3.6** | **REWRITE** |
| 10 | De Toegangsrechten | Database Beheer | Budgetten Niet Geüpd | Semantisch Mode | 3 | 3 | 5 | 4 | 2 | **3.4** | **REWRITE** |
| 14 | De Query Experiment | Power BI Develo | Dubbele Records in D | Power Query Edi | 5 | 3 | 5 | 5 | 2 | **4.0** | **KEEP** |
| 21 | De Budget Versies | Financial Contr | Hardcoded Excel Pad | OneDrive | 3 | 2 | 1 | 4 | 2 | **2.4** | **REWRITE** |
| 13 | De OneDrive Sync | Financial Contr | Hardcoded Excel Pad | OneDrive | 5 | 2 | 1 | 4 | 3 | **3.0** | **REWRITE** |
| 12 | De Test Slicer | Power BI Develo | Hidden Slicer | Report View - S | 2 | 3 | 5 | 5 | 3 | **3.6** | **REWRITE** |
| 19 | De Migratie Path | Power BI Develo | Hardcoded Excel Pad | Power Query Edi | 5 | 3 | 1 | 4 | 2 | **3.0** | **REWRITE** |
| 11 | De Dubbele Dimensie | Database Beheer | Dubbele Records in D | Semantisch Mode | 3 | 3 | 5 | 4 | 3 | **3.6** | **REWRITE** |
| 20 | De Vakantie Vergissing | Power BI Develo | Budgetten Niet Geüpd | Semantisch Mode | 3 | 3 | 5 | 4 | 3 | **3.6** | **REWRITE** |
| 24 | De Reorganisatie | Database Beheer | Budgetten Niet Geüpd | Semantisch Mode | 3 | 3 | 5 | 4 | 2 | **3.4** | **REWRITE** |
| 9 | De Database Migratie | Database Beheer | Many-to-Many Relatie | Semantisch Mode | 3 | 3 | 5 | 4 | 2 | **3.4** | **REWRITE** |

**Legend:** R=Realisme, L=Logica, T=Techniek, S=Speelbaarheid, ST=Storytelling


---

## 📈 Summary Statistics

- ✅ **KEEP:** 4 scenarios (≥4.0 stars)
- ⚠️ **REWRITE:** 17 scenarios (2.0-3.9 stars)
- ❌ **DELETE:** 0 scenarios (<2.0 stars)

**Target:** 12-15 high-quality scenarios

---

## 📋 Detailed Analyses


---

### ✅ Scenario 7: De Heidag Chaos

**Combinatie:**
- **Persoon:** Power BI Developer
- **Wapen:** Hidden Slicer
- **Locatie:** Report View - Selection Pane

**Beschrijving:**
> De dag voor de Heidag wilde de Power BI Developer snel een filter toevoegen voor de presentatie. In de haast verborg hij de slicer maar vergat deze te verwijderen. Het rapport ging live met een actieve filter op alleen Q2 data.

**Scores:**
- **Realisme:** ⭐⭐⭐⭐⭐ (5/5)
- **Logica:** ⭐⭐⭐ (3/5)
- **Techniek:** ⭐⭐⭐⭐⭐ (5/5)
- **Speelbaarheid:** ⭐⭐⭐⭐ (4/5)
- **Storytelling:** ⭐⭐⭐ (3/5)

**Total Score:** 4.0/5  
**Verdict:** **KEEP**

**Issues:**
- Persoon 'Power BI Developer' niet in standaard rollen

---

### ⚠️ Scenario 6: De Verkeerde Path

**Combinatie:**
- **Persoon:** Financial Controller
- **Wapen:** Hardcoded Excel Pad
- **Locatie:** Power Query Editor

**Beschrijving:**
> Na een reorganisatie kreeg de Financial Controller een nieuwe laptop. Het budget Excel bestand stond nu op een andere locatie, maar niemand had de hardcoded path in Power Query aangepast. De refresh faalde stilletjes.

**Scores:**
- **Realisme:** ⭐⭐⭐⭐⭐ (5/5)
- **Logica:** ⭐⭐ (2/5)
- **Techniek:** ⭐ (1/5)
- **Speelbaarheid:** ⭐⭐⭐⭐ (4/5)
- **Storytelling:** ⭐⭐ (2/5)

**Total Score:** 2.8/5  
**Verdict:** **REWRITE**

**Issues:**
- Financial Controller zou normaal niet Hardcoded Excel Pad veroorzaken
- Wapen 'Hardcoded Excel Pad' niet herkend
- Mist menselijk gedrag en/of causale verhaalstructuur

**Rewrite Suggestions:**
- Strengthen causal chain: person → reason → action → weapon
- Add technical details about how the weapon emerges
- Add human behavior elements (forgot, rushed, miscommunication)

---

### ✅ Scenario 5: De Budget Stress

**Combinatie:**
- **Persoon:** Financial Controller
- **Wapen:** Budgetten Niet Geüpdatet
- **Locatie:** OneDrive

**Beschrijving:**
> Het was eind Q3 en de Financial Controller moest snel de nieuwe Q4 budgetten uploaden. In de haast plaatste ze het Excel bestand in haar persoonlijke OneDrive folder in plaats van de gedeelde locatie. De refresh draaide nog op het oude bestand.

**Scores:**
- **Realisme:** ⭐⭐⭐⭐⭐ (5/5)
- **Logica:** ⭐⭐⭐⭐⭐ (5/5)
- **Techniek:** ⭐⭐⭐⭐⭐ (5/5)
- **Speelbaarheid:** ⭐⭐⭐⭐ (4/5)
- **Storytelling:** ⭐⭐⭐ (3/5)

**Total Score:** 4.4/5  
**Verdict:** **KEEP**


---

### ⚠️ Scenario 18: De Verborgen Filter Test

**Combinatie:**
- **Persoon:** Power BI Developer
- **Wapen:** Hidden Slicer
- **Locatie:** Report View - Selection Pane

**Beschrijving:**
> Voor een specifieke afdeling maakte de developer een gefilterde versie van het rapport. Hij dacht de slicer verwijderd te hebben, maar had deze alleen verborgen. De hele organisatie zag nu alleen data van Sales West.

**Scores:**
- **Realisme:** ⭐⭐ (2/5)
- **Logica:** ⭐⭐⭐ (3/5)
- **Techniek:** ⭐⭐⭐⭐⭐ (5/5)
- **Speelbaarheid:** ⭐⭐⭐⭐ (4/5)
- **Storytelling:** ⭐⭐⭐ (3/5)

**Total Score:** 3.4/5  
**Verdict:** **REWRITE**

**Issues:**
- Scenario mist herkenbare Power BI situatie details
- Persoon 'Power BI Developer' niet in standaard rollen

**Rewrite Suggestions:**
- Add more recognizable Power BI context (deadlines, testing, deployment)
- Strengthen causal chain: person → reason → action → weapon
- Add human behavior elements (forgot, rushed, miscommunication)

---

### ⚠️ Scenario 23: De Snelle Fix

**Combinatie:**
- **Persoon:** Power BI Developer
- **Wapen:** Dubbele Records in DIM Table
- **Locatie:** Power Query Editor

**Beschrijving:**
> Het was 17:55 op vrijdag. De developer moest snel een nieuwe kolom toevoegen. Hij deed een quick merge zonder te checken op dubbele keys. Maandagochtend waren alle KPIs verdubbeld.

**Scores:**
- **Realisme:** ⭐⭐⭐⭐⭐ (5/5)
- **Logica:** ⭐⭐⭐ (3/5)
- **Techniek:** ⭐⭐ (2/5)
- **Speelbaarheid:** ⭐⭐⭐⭐⭐ (5/5)
- **Storytelling:** ⭐⭐⭐ (3/5)

**Total Score:** 3.6/5  
**Verdict:** **REWRITE**

**Issues:**
- Persoon 'Power BI Developer' niet in standaard rollen
- Beschrijving mist technische details over hoe Dubbele Records in DIM Table ontstaat

**Rewrite Suggestions:**
- Strengthen causal chain: person → reason → action → weapon
- Add technical details about how the weapon emerges
- Add human behavior elements (forgot, rushed, miscommunication)

---

### ✅ Scenario 4: Q3 Budget Crisis

**Combinatie:**
- **Persoon:** Financial Controller
- **Wapen:** Budgetten Niet Geüpdatet
- **Locatie:** OneDrive

**Beschrijving:**
> Het was eind Q3 en de Financial Controller moest snel de nieuwe Q4 budgetten uploaden. In de haast plaatste ze het Excel bestand in haar persoonlijke OneDrive folder in plaats van de gedeelde locatie. De refresh draaide nog op het oude bestand.

**Scores:**
- **Realisme:** ⭐⭐⭐⭐⭐ (5/5)
- **Logica:** ⭐⭐⭐⭐⭐ (5/5)
- **Techniek:** ⭐⭐⭐⭐⭐ (5/5)
- **Speelbaarheid:** ⭐⭐⭐⭐ (4/5)
- **Storytelling:** ⭐⭐⭐ (3/5)

**Total Score:** 4.4/5  
**Verdict:** **KEEP**


---

### ⚠️ Scenario 8: De Power BI Gebruikersdag

**Combinatie:**
- **Persoon:** Power BI Developer
- **Wapen:** Budgetten Niet Geüpdatet
- **Locatie:** Semantisch Model

**Beschrijving:**
> De Power BI Developer was drie dagen op de Power BI Gebruikersdag. Hij vergat de scheduled refresh voor het weekend aan te zetten. Maandagochtend stonden er nog de cijfers van vorige week in het dashboard.

**Scores:**
- **Realisme:** ⭐⭐⭐ (3/5)
- **Logica:** ⭐⭐⭐ (3/5)
- **Techniek:** ⭐⭐⭐⭐⭐ (5/5)
- **Speelbaarheid:** ⭐⭐⭐⭐⭐ (5/5)
- **Storytelling:** ⭐⭐⭐ (3/5)

**Total Score:** 3.8/5  
**Verdict:** **REWRITE**

**Issues:**
- Persoon 'Power BI Developer' niet in standaard rollen

**Rewrite Suggestions:**
- Add more recognizable Power BI context (deadlines, testing, deployment)
- Strengthen causal chain: person → reason → action → weapon
- Add human behavior elements (forgot, rushed, miscommunication)

---

### ⚠️ Scenario 17: De Database Cleanup

**Combinatie:**
- **Persoon:** Database Beheerder
- **Wapen:** Dubbele Records in DIM Table
- **Locatie:** Power Query Editor

**Beschrijving:**
> Tijdens een database cleanup in Q3 wilde de Database Beheerder oude duplicaten verwijderen. Door een fout in zijn script werden juist nieuwe duplicaten aangemaakt in de DIM_Customer tabel.

**Scores:**
- **Realisme:** ⭐⭐ (2/5)
- **Logica:** ⭐⭐⭐ (3/5)
- **Techniek:** ⭐⭐⭐⭐⭐ (5/5)
- **Speelbaarheid:** ⭐⭐⭐⭐ (4/5)
- **Storytelling:** ⭐⭐ (2/5)

**Total Score:** 3.2/5  
**Verdict:** **REWRITE**

**Issues:**
- Scenario mist herkenbare Power BI situatie details
- Persoon 'Database Beheerder' niet in standaard rollen
- Mist menselijk gedrag en/of causale verhaalstructuur

**Rewrite Suggestions:**
- Add more recognizable Power BI context (deadlines, testing, deployment)
- Strengthen causal chain: person → reason → action → weapon
- Add human behavior elements (forgot, rushed, miscommunication)

---

### ⚠️ Scenario 22: De Test Environment

**Combinatie:**
- **Persoon:** Database Beheerder
- **Wapen:** Many-to-Many Relatie
- **Locatie:** Semantisch Model

**Beschrijving:**
> De Database Beheerder testte een nieuwe feature in de productie database (oeps!). Hij creëerde een test-tabel met bewust een many-to-many relatie. Hij vergat deze te verwijderen en de Power BI Developer koppelde er per ongeluk aan.

**Scores:**
- **Realisme:** ⭐ (1/5)
- **Logica:** ⭐⭐⭐ (3/5)
- **Techniek:** ⭐⭐⭐⭐⭐ (5/5)
- **Speelbaarheid:** ⭐⭐⭐⭐ (4/5)
- **Storytelling:** ⭐⭐⭐ (3/5)

**Total Score:** 3.2/5  
**Verdict:** **REWRITE**

**Issues:**
- Scenario lijkt geforceerd of kunstmatig (sabotage-gedrag)
- Persoon 'Database Beheerder' niet in standaard rollen

**Rewrite Suggestions:**
- Add more recognizable Power BI context (deadlines, testing, deployment)
- Strengthen causal chain: person → reason → action → weapon
- Add human behavior elements (forgot, rushed, miscommunication)

---

### ⚠️ Scenario 16: De Many-to-Many Model

**Combinatie:**
- **Persoon:** Power BI Developer
- **Wapen:** Many-to-Many Relatie
- **Locatie:** Semantisch Model

**Beschrijving:**
> Voor een nieuwe analyse wilde de developer een directe relatie tussen Employees en Projects. Hij vergat dat één employee aan meerdere projecten kan werken. De many-to-many relatie zorgde voor vermenigvuldigde uren in alle rapporten.

**Scores:**
- **Realisme:** ⭐⭐ (2/5)
- **Logica:** ⭐⭐⭐ (3/5)
- **Techniek:** ⭐⭐⭐⭐⭐ (5/5)
- **Speelbaarheid:** ⭐⭐⭐⭐ (4/5)
- **Storytelling:** ⭐⭐⭐ (3/5)

**Total Score:** 3.4/5  
**Verdict:** **REWRITE**

**Issues:**
- Scenario mist herkenbare Power BI situatie details
- Persoon 'Power BI Developer' niet in standaard rollen

**Rewrite Suggestions:**
- Add more recognizable Power BI context (deadlines, testing, deployment)
- Strengthen causal chain: person → reason → action → weapon
- Add human behavior elements (forgot, rushed, miscommunication)

---

### ⚠️ Scenario 15: De Jaar-einde Drukte

**Combinatie:**
- **Persoon:** Financial Controller
- **Wapen:** Budgetten Niet Geüpdatet
- **Locatie:** OneDrive

**Beschrijving:**
> In de laatste week van december was het extreem druk met jaar-einde rapportages. De Financial Controller uploadde wel de nieuwe cijfers, maar in een nieuwe folder "2024 Budget Final FINAL v3". De oude path klopte niet meer.

**Scores:**
- **Realisme:** ⭐⭐ (2/5)
- **Logica:** ⭐⭐⭐⭐⭐ (5/5)
- **Techniek:** ⭐⭐⭐⭐⭐ (5/5)
- **Speelbaarheid:** ⭐⭐⭐⭐ (4/5)
- **Storytelling:** ⭐⭐ (2/5)

**Total Score:** 3.6/5  
**Verdict:** **REWRITE**

**Issues:**
- Scenario mist herkenbare Power BI situatie details
- Mist menselijk gedrag en/of causale verhaalstructuur

**Rewrite Suggestions:**
- Add more recognizable Power BI context (deadlines, testing, deployment)
- Add human behavior elements (forgot, rushed, miscommunication)

---

### ⚠️ Scenario 10: De Toegangsrechten

**Combinatie:**
- **Persoon:** Database Beheerder
- **Wapen:** Budgetten Niet Geüpdatet
- **Locatie:** Semantisch Model

**Beschrijving:**
> Na een security audit trok de Database Beheerder oude service accounts in. Helaas was dit ook het account dat Power BI gebruikte voor de refresh. Niemand kreeg een error, de data werd gewoon niet meer ververst.

**Scores:**
- **Realisme:** ⭐⭐⭐ (3/5)
- **Logica:** ⭐⭐⭐ (3/5)
- **Techniek:** ⭐⭐⭐⭐⭐ (5/5)
- **Speelbaarheid:** ⭐⭐⭐⭐ (4/5)
- **Storytelling:** ⭐⭐ (2/5)

**Total Score:** 3.4/5  
**Verdict:** **REWRITE**

**Issues:**
- Persoon 'Database Beheerder' niet in standaard rollen
- Mist menselijk gedrag en/of causale verhaalstructuur

**Rewrite Suggestions:**
- Add more recognizable Power BI context (deadlines, testing, deployment)
- Strengthen causal chain: person → reason → action → weapon
- Add human behavior elements (forgot, rushed, miscommunication)

---

### ✅ Scenario 14: De Query Experiment

**Combinatie:**
- **Persoon:** Power BI Developer
- **Wapen:** Dubbele Records in DIM Table
- **Locatie:** Power Query Editor

**Beschrijving:**
> De Power BI Developer experimenteerde met een nieuwe merge in Power Query. Door een verkeerde join (Left Outer in plaats van Inner) ontstonden er dubbele rijen. Hij publishte de wijziging vrijdagmiddag zonder te testen.

**Scores:**
- **Realisme:** ⭐⭐⭐⭐⭐ (5/5)
- **Logica:** ⭐⭐⭐ (3/5)
- **Techniek:** ⭐⭐⭐⭐⭐ (5/5)
- **Speelbaarheid:** ⭐⭐⭐⭐⭐ (5/5)
- **Storytelling:** ⭐⭐ (2/5)

**Total Score:** 4.0/5  
**Verdict:** **KEEP**

**Issues:**
- Persoon 'Power BI Developer' niet in standaard rollen
- Mist menselijk gedrag en/of causale verhaalstructuur

---

### ⚠️ Scenario 21: De Budget Versies

**Combinatie:**
- **Persoon:** Financial Controller
- **Wapen:** Hardcoded Excel Pad
- **Locatie:** OneDrive

**Beschrijving:**
> De Financial Controller maakte verschillende versies van het budget: "Conservatief", "Realistisch", "Optimistisch". Power Query was gekoppeld aan "Realistisch", maar het management wilde "Conservatief" zien. Niemand paste de path aan.

**Scores:**
- **Realisme:** ⭐⭐⭐ (3/5)
- **Logica:** ⭐⭐ (2/5)
- **Techniek:** ⭐ (1/5)
- **Speelbaarheid:** ⭐⭐⭐⭐ (4/5)
- **Storytelling:** ⭐⭐ (2/5)

**Total Score:** 2.4/5  
**Verdict:** **REWRITE**

**Issues:**
- Financial Controller zou normaal niet Hardcoded Excel Pad veroorzaken
- Wapen 'Hardcoded Excel Pad' niet herkend
- Mist menselijk gedrag en/of causale verhaalstructuur

**Rewrite Suggestions:**
- Add more recognizable Power BI context (deadlines, testing, deployment)
- Strengthen causal chain: person → reason → action → weapon
- Add technical details about how the weapon emerges
- Add human behavior elements (forgot, rushed, miscommunication)

---

### ⚠️ Scenario 13: De OneDrive Sync

**Combinatie:**
- **Persoon:** Financial Controller
- **Wapen:** Hardcoded Excel Pad
- **Locatie:** OneDrive

**Beschrijving:**
> De Financial Controller werkte thuis en had OneDrive op "Files On-Demand" staan. Het budget bestand was niet lokaal gedownload. Toen Power Query probeerde te refreshen, kreeg het "File not found" omdat het bestand alleen in de cloud stond.

**Scores:**
- **Realisme:** ⭐⭐⭐⭐⭐ (5/5)
- **Logica:** ⭐⭐ (2/5)
- **Techniek:** ⭐ (1/5)
- **Speelbaarheid:** ⭐⭐⭐⭐ (4/5)
- **Storytelling:** ⭐⭐⭐ (3/5)

**Total Score:** 3.0/5  
**Verdict:** **REWRITE**

**Issues:**
- Financial Controller zou normaal niet Hardcoded Excel Pad veroorzaken
- Wapen 'Hardcoded Excel Pad' niet herkend

**Rewrite Suggestions:**
- Strengthen causal chain: person → reason → action → weapon
- Add technical details about how the weapon emerges
- Add human behavior elements (forgot, rushed, miscommunication)

---

### ⚠️ Scenario 12: De Test Slicer

**Combinatie:**
- **Persoon:** Power BI Developer
- **Wapen:** Hidden Slicer
- **Locatie:** Report View - Selection Pane

**Beschrijving:**
> Tijdens een demo voor het management in Q2 wilde de developer alleen "goede" data tonen. Hij voegde snel een slicer toe die slechte resultaten filterde en verborg deze. Na de demo vergat hij deze te verwijderen.

**Scores:**
- **Realisme:** ⭐⭐ (2/5)
- **Logica:** ⭐⭐⭐ (3/5)
- **Techniek:** ⭐⭐⭐⭐⭐ (5/5)
- **Speelbaarheid:** ⭐⭐⭐⭐⭐ (5/5)
- **Storytelling:** ⭐⭐⭐ (3/5)

**Total Score:** 3.6/5  
**Verdict:** **REWRITE**

**Issues:**
- Scenario mist herkenbare Power BI situatie details
- Persoon 'Power BI Developer' niet in standaard rollen

**Rewrite Suggestions:**
- Add more recognizable Power BI context (deadlines, testing, deployment)
- Strengthen causal chain: person → reason → action → weapon
- Add human behavior elements (forgot, rushed, miscommunication)

---

### ⚠️ Scenario 19: De Migratie Path

**Combinatie:**
- **Persoon:** Power BI Developer
- **Wapen:** Hardcoded Excel Pad
- **Locatie:** Power Query Editor

**Beschrijving:**
> Bij een migratie naar een nieuwe server had de developer de database connectie aangepast, maar vergeten dat er ook een Excel bestand als bron werd gebruikt. De hardcoded "C:\Data\Budgets.xlsx" bestond niet op de nieuwe omgeving.

**Scores:**
- **Realisme:** ⭐⭐⭐⭐⭐ (5/5)
- **Logica:** ⭐⭐⭐ (3/5)
- **Techniek:** ⭐ (1/5)
- **Speelbaarheid:** ⭐⭐⭐⭐ (4/5)
- **Storytelling:** ⭐⭐ (2/5)

**Total Score:** 3.0/5  
**Verdict:** **REWRITE**

**Issues:**
- Persoon 'Power BI Developer' niet in standaard rollen
- Wapen 'Hardcoded Excel Pad' niet herkend
- Mist menselijk gedrag en/of causale verhaalstructuur

**Rewrite Suggestions:**
- Strengthen causal chain: person → reason → action → weapon
- Add technical details about how the weapon emerges
- Add human behavior elements (forgot, rushed, miscommunication)

---

### ⚠️ Scenario 11: De Dubbele Dimensie

**Combinatie:**
- **Persoon:** Database Beheerder
- **Wapen:** Dubbele Records in DIM Table
- **Locatie:** Semantisch Model

**Beschrijving:**
> Bij het importeren van nieuwe productcodes aan het einde van het boekjaar, ontstonden er per ongeluk dubbele records in de DIM_Product tabel. Elke verkoop werd nu twee keer geteld in het dashboard.

**Scores:**
- **Realisme:** ⭐⭐⭐ (3/5)
- **Logica:** ⭐⭐⭐ (3/5)
- **Techniek:** ⭐⭐⭐⭐⭐ (5/5)
- **Speelbaarheid:** ⭐⭐⭐⭐ (4/5)
- **Storytelling:** ⭐⭐⭐ (3/5)

**Total Score:** 3.6/5  
**Verdict:** **REWRITE**

**Issues:**
- Persoon 'Database Beheerder' niet in standaard rollen

**Rewrite Suggestions:**
- Add more recognizable Power BI context (deadlines, testing, deployment)
- Strengthen causal chain: person → reason → action → weapon
- Add human behavior elements (forgot, rushed, miscommunication)

---

### ⚠️ Scenario 20: De Vakantie Vergissing

**Combinatie:**
- **Persoon:** Power BI Developer
- **Wapen:** Budgetten Niet Geüpdatet
- **Locatie:** Semantisch Model

**Beschrijving:**
> Vlak voor zijn vakantie in augustus zette de developer de refresh uit "om bandbreedtte te besparen". Hij vergat deze weer aan te zetten na terugkomst. Drie weken lang draaide het dashboard op oude data.

**Scores:**
- **Realisme:** ⭐⭐⭐ (3/5)
- **Logica:** ⭐⭐⭐ (3/5)
- **Techniek:** ⭐⭐⭐⭐⭐ (5/5)
- **Speelbaarheid:** ⭐⭐⭐⭐ (4/5)
- **Storytelling:** ⭐⭐⭐ (3/5)

**Total Score:** 3.6/5  
**Verdict:** **REWRITE**

**Issues:**
- Persoon 'Power BI Developer' niet in standaard rollen

**Rewrite Suggestions:**
- Add more recognizable Power BI context (deadlines, testing, deployment)
- Strengthen causal chain: person → reason → action → weapon
- Add human behavior elements (forgot, rushed, miscommunication)

---

### ⚠️ Scenario 24: De Reorganisatie

**Combinatie:**
- **Persoon:** Database Beheerder
- **Wapen:** Budgetten Niet Geüpdatet
- **Locatie:** Semantisch Model

**Beschrijving:**
> Na een reorganisatie wijzigde de Database Beheerder de security groups. De service account voor Power BI zat niet meer in de juiste groep. De refresh leek te werken, maar pakte eigenlijk geen nieuwe data op.

**Scores:**
- **Realisme:** ⭐⭐⭐ (3/5)
- **Logica:** ⭐⭐⭐ (3/5)
- **Techniek:** ⭐⭐⭐⭐⭐ (5/5)
- **Speelbaarheid:** ⭐⭐⭐⭐ (4/5)
- **Storytelling:** ⭐⭐ (2/5)

**Total Score:** 3.4/5  
**Verdict:** **REWRITE**

**Issues:**
- Persoon 'Database Beheerder' niet in standaard rollen
- Mist menselijk gedrag en/of causale verhaalstructuur

**Rewrite Suggestions:**
- Add more recognizable Power BI context (deadlines, testing, deployment)
- Strengthen causal chain: person → reason → action → weapon
- Add human behavior elements (forgot, rushed, miscommunication)

---

### ⚠️ Scenario 9: De Database Migratie

**Combinatie:**
- **Persoon:** Database Beheerder
- **Wapen:** Many-to-Many Relatie
- **Locatie:** Semantisch Model

**Beschrijving:**
> Tijdens een database migratie in Q1 wijzigde de Database Beheerder de structuur van de Sales tabel. Dit creëerde onverwacht een many-to-many relatie met de Product tabel. Alle verkoopcijfers werden dubbel geteld.

**Scores:**
- **Realisme:** ⭐⭐⭐ (3/5)
- **Logica:** ⭐⭐⭐ (3/5)
- **Techniek:** ⭐⭐⭐⭐⭐ (5/5)
- **Speelbaarheid:** ⭐⭐⭐⭐ (4/5)
- **Storytelling:** ⭐⭐ (2/5)

**Total Score:** 3.4/5  
**Verdict:** **REWRITE**

**Issues:**
- Persoon 'Database Beheerder' niet in standaard rollen
- Mist menselijk gedrag en/of causale verhaalstructuur

**Rewrite Suggestions:**
- Add more recognizable Power BI context (deadlines, testing, deployment)
- Strengthen causal chain: person → reason → action → weapon
- Add human behavior elements (forgot, rushed, miscommunication)

---

## 🎯 Final Recommendations

### Immediate Actions:
2. **REWRITE 17 scenarios** using SCENARIO_CRITERIA.md guidelines
3. **KEEP 4 strong scenarios** as-is

### Gap Analysis:
- Current strong scenarios: 4
- Target: 12-15
- **Need to create/fix: 8 more scenarios**

### Quality Checklist per Scenario:
- [ ] Recognizable Power BI situation
- [ ] Logical causal chain (person → action → weapon → location)
- [ ] Technical accuracy (weapon can truly result from action)
- [ ] Playable (3 agents can give different perspectives)
- [ ] Human behavior (unintentional mistakes, miscommunication)

### Focus Areas for Rewrites:
1. **Strengthen Causality:** Make person → weapon connection more explicit
2. **Add Technical Details:** Explain HOW the weapon emerges technically
3. **Humanize:** Add time pressure, miscommunication, assumptions
4. **Expand Context:** Add timing, planning, who saw what when
5. **Test Playability:** Can agents give hints without revealing answer?

---

*Report generated by audit_scenarios.py*
