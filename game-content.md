# Game Content - Who Killed the Power BI Dashboard?

## Personen (Verdachten) - 3

### 1. Power BI Developer
**Rol:** Ontwikkelt en onderhoudt Power BI rapportages  
**Verantwoordelijkheden:**
- PBIX files beheren
- Data refreshes instellen
- DAX measures schrijven
- Datamodel opzetten
- Slicers en filters configureren

**Mogelijke fouten:**
- Vergeten refresh in te schakelen
- Hidden slicers toevoegen
- Many-to-many relaties verkeerd modelleren
- Dubbele records in DIM tables niet opruimen

---

### 2. Financial Controller
**Rol:** Beheert budgetten en financiële rapportages  
**Verantwoordelijkheden:**
- Budgetcijfers aanleveren
- Excel bestanden met budgetdata onderhouden
- Rapportages controleren op juistheid
- Financiële analyses uitvoeren

**Mogelijke fouten:**
- Budgetten niet updaten in bronbestanden
- Excel bestand verplaatsen/hernoemen
- Hardcoded pad naar persoonlijke OneDrive
- Verkeerde versie van budget aanleveren

---

### 3. Database Beheerder
**Rol:** Beheert databases en toegangsrechten  
**Verantwoordelijkheden:**
- Database onderhoud
- Gebruikersrechten toekennen/intrekken
- Data integriteit waarborgen
- Performance optimalisatie
- Backup en recovery

**Mogelijke fouten:**
- Toegangsrechten intrekken waardoor refresh faalt
- Database structuur wijzigen zonder communicatie
- Many-to-many relaties in database verkeerd opzetten
- Dubbele records toestaan in dimensie tabellen

---

## Wapens (Power BI Horror Scenarios) - 5

### 1. Many-to-Many Relatie
**Wat is het:**  
Een relatie tussen twee tabellen waarbij meerdere rijen in tabel A kunnen corresponderen met meerdere rijen in tabel B. In Power BI kan dit leiden tot verkeerde berekeningen en dubbeltelling.

**Symptomen:**
- Totalen kloppen niet
- Dubbele aantallen in visuals
- Measures geven verkeerde resultaten
- Filtering werkt niet zoals verwacht

**Impact:** Dashboard toont onjuiste cijfers, beslissingen worden op verkeerde data genomen

---

### 2. Hidden Slicer
**Wat is het:**  
Een slicer die per ongeluk verborgen is in het rapport, maar nog steeds actief filtert. Gebruikers zien niet dat er gefilterd wordt.

**Symptomen:**
- Data lijkt te ontbreken
- Cijfers kloppen niet met verwachtingen
- Niemand ziet waarom data beperkt is
- Selection Pane toont verborgen slicer

**Impact:** Gebruikers zien incomplete data zonder te weten waarom

---

### 3. Dubbele Records in DIM Table
**Wat is het:**  
Dimensietabellen (DIM tables) bevatten duplicate entries, wat zorgt voor meervoudige koppelingen en verkeerde berekeningen.

**Symptomen:**
- Totalen zijn verdubbeld of vermenigvuldigd
- Measures tellen records meerdere keren
- Relaties werken niet correct
- Data integriteit problemen

**Impact:** Alle berekeningen die deze dimensie gebruiken zijn onbetrouwbaar

---

### 4. Hardcoded Excel Pad
**Wat is het:**  
Power Query bevat een vast pad naar een Excel bestand op een specifieke locatie (bijv. `C:\Users\Jan\Documents\budget.xlsx`). Werkt niet op andere computers of als bestand verplaatst wordt.

**Symptomen:**
- "Bestand niet gevonden" error bij refresh
- Rapport werkt alleen op één computer
- Data verouderd omdat refresh faalt
- OneDrive synchronisatie problemen

**Impact:** Dashboard kan niet refreshen, data blijft oud

---

### 5. Budgetten Niet Geüpdatet
**Wat is het:**  
De brondata met budgetcijfers is niet bijgewerkt met de laatste cijfers. Dit kan komen doordat:
- Excel bestand niet is aangepast
- Refresh niet is ingeschakeld in semantisch model
- Verkeerde versie van budget wordt gebruikt

**Symptomen:**
- Actuals vs Budget vergelijking klopt niet
- Verouderde budgetcijfers
- Variance analyses zijn zinloos
- Management ziet verkeerde forecast

**Impact:** Verkeerde budgetanalyses leiden tot foute beslissingen

---

## Locaties (Crime Scenes) - 4

### 1. OneDrive
**Wat is het:**  
Cloud storage van Microsoft waar gebruikers bestanden opslaan. Vaak gebruikt voor Excel bronbestanden.

**Relevantie:**
- Bestanden kunnen verplaatst worden
- Paden veranderen bij synchronisatie
- Toegangsrechten kunnen wijzigen
- Bestandsnamen kunnen aangepast worden

**Typische problemen:**
- Hardcoded pad werkt niet meer
- Sync-conflicten
- Bestanden offline niet beschikbaar

---

### 2. Power Query Editor
**Wat is het:**  
De interface waar data transformaties worden uitgevoerd voordat data in het model komt.

**Relevantie:**
- Hier worden bronnen gekoppeld
- Transformatiestappen worden gedefinieerd
- Query's worden geschreven
- Parameters worden ingesteld

**Typische problemen:**
- Verkeerde paden in bronnen
- Fouten in transformatiestappen
- Performance problemen door complexe queries

---

### 3. Semantisch Model
**Wat is het:**  
Het datamodel binnen Power BI, inclusief tabellen, relaties, measures en instellingen.

**Relevantie:**
- Refresh instellingen staan hier
- Gateway configuratie
- Credentials voor databronnen
- Scheduled refresh moet hier ingesteld zijn

**Typische problemen:**
- Refresh niet ingeschakeld
- Credentials verlopen
- Gateway problemen
- Many-to-many relaties verkeerd gemodelleerd

---

### 4. Report View - Selection Pane
**Wat is het:**  
Het paneel in Report View waar alle objecten op de pagina zichtbaar zijn, inclusief hun zichtbaarheid.

**Relevantie:**
- Hier zie je verborgen objecten
- Slicers kunnen hier verborgen zijn
- Objecten kunnen per ongeluk verborgen worden

**Typische problemen:**
- Hidden slicers die actief blijven filteren
- Visuals per ongeluk verborgen
- Overlappende objecten

---

## Agents (Hint Characters) - 3

### 1. De Schoonmaker
**Achtergrond:**  
Werkt 's avonds en 's nachts in het kantoor. Ziet en hoort alles, maar wordt vaak genegeerd.

**Kenmerken:**
- Observant en oplettend
- Bescheiden, praat niet uit zichzelf
- Heeft sleutels tot alle ruimtes
- Werkt vaak als andere weg zijn

**Type hints:**
- Wie wanneer in welke ruimte was
- Wat er op schermen stond
- Overgehoorde gesprekken
- Ongebruikelijke situaties

**Tone of voice:** Rustig, bedachtzaam, weet meer dan je denkt

---

### 2. De Receptionist
**Achtergrond:**  
Zit aan de balie, ziet iedereen komen en gaan. Houdt agenda's bij en weet welke meetings plaatsvinden.

**Kenmerken:**
- Sociaal en communicatief
- Weet wie waar afspraken mee heeft
- Hoort veel door telefoongesprekken
- Kent de routines van iedereen

**Type hints:**
- Wie op welke tijden aanwezig was
- Wie gestrest of gehaast was
- Meetings en afspraken
- Deadlines en druk momenten

**Tone of voice:** Vriendelijk, professioneel, discreet

---

### 3. De Stagiair
**Achtergrond:**  
Jong en nieuw in het bedrijf. Enthousiast maar nerveus. Heeft toegang gekregen tot systemen en weet van "shortcuts" die het team gebruikt.

**Kenmerken:**
- Eerlijk en open
- Wil graag helpen
- Kent de onofficiële werkwijzen
- Durft "geheimpjes" te delen

**Type hints:**
- "Eigenlijk moet dit niet zo, maar hier doen we dit wel..."
- Onofficiële procedures en workarounds
- Wie hem/haar wat heeft geleerd
- Fouten die gemaakt zijn en verzwegen werden

**Tone of voice:** Jong, enthousiast, soms onzeker, eerlijk

---

## Scenario Matrix

**Totaal aantal mogelijke combinaties:** 3 personen × 5 wapens × 4 locaties = **60 scenario's**

Elk scenario bestaat uit:
- 1 dader (persoon)
- 1 wapen (Power BI horror)
- 1 locatie (crime scene)
- 3 agents met scenario-specifieke kennis

**Voorbeeld Scenario:**
- **Dader:** Power BI Developer
- **Wapen:** Hidden Slicer
- **Locatie:** Report View - Selection Pane
- **Verhaal:** De developer voegde een slicer toe voor testing, vergat deze zichtbaar te maken, en het rapport ging live met een actieve maar onzichtbare filter.
