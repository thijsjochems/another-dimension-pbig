# Scenario Kwaliteitscriteria
**Power BI Murder Mystery - Scenario Design Richtlijnen**

---

## 🎯 Doel
Elk scenario moet een **geloofwaardige, herkenbare Power BI situatie** vertellen waarbij spelers door logische deductie de combinatie kunnen achterhalen.

---

## ✅ Essentiële Vereisten

### 1. **Herkenbare Echte Situaties**
- Scenario moet gebaseerd zijn op **echte Power BI problemen** die professionals herkennen
- Situaties die écht voorkomen in de praktijk
- Geen geforceerde of kunstmatige combinaties

**Voorbeelden:**
- ✅ Developer publiceert vrijdagmiddag zonder te testen → merge gaat fout
- ✅ Financial Controller verplaatst Excel bestand → hardcoded pad werkt niet meer
- ❌ Stagiair maakt opzettelijk een hidden slicer (waarom zou je dat doen?)

---

### 2. **Logische Causale Keten**

Elk scenario moet deze logica volgen:

```
PERSOON → heeft REDEN → doet ACTIE → resulteert in WAPEN → op LOCATIE
```

**Persoon:**
- Heeft **verantwoordelijkheid/toegang** voor deze actie
- Heeft **motief** (niet opzettelijk, maar tijdsdruk/onkunde/miscommunicatie)

**Actie:**
- Ligt binnen de normale **werkzaamheden** van deze persoon
- Is een **realistische fout** (haast, gebrek aan kennis, verkeerde aanname)

**Wapen:**
- Is het **directe technische gevolg** van de actie
- Kan alleen door deze actie ontstaan (niet door toeval)

**Locatie:**
- Is waar de actie **plaatsvond** OF
- Is waar de fout **zichtbaar/ontdekt** werd
- Moet logisch verbonden zijn met persoon en wapen

---

### 3. **Menselijk Gedrag**

Scenario's moeten realistische menselijke dynamieken bevatten:

**Onbewust Onbekwaam:**
- Persoon weet niet dat ze iets fout doen
- "Dat zou toch moeten werken?"
- Overmoedig of te snel gehandeld

**Naar Elkaar Wijzen:**
- Agents kunnen subtiel hints geven: "Ik zag persoon X bij locatie Y"
- Personen geven elkaar de schuld (defensief gedrag)
- "Ik heb het volgens het proces gedaan, maar..."

**Communicatie Fouten:**
- Iemand vergat iets door te geven
- Verkeerde aannames gemaakt
- Geen time voor testing/validatie

---

### 4. **Technische Accuratesse**

Het wapen moet **technisch kloppen**:

**Many-to-Many Relatie:**
- Kan ontstaan door: database structuur wijziging, verkeerde join in Power Query, test-tabel vergeten te verwijderen
- Resulteert in: dubbele tellingen, verkeerde totalen

**Hidden Slicer:**
- Kan ontstaan door: per ongeluk verborgen tijdens testing, verkeerde publish, selectie panel niet gecontroleerd
- Resulteert in: incomplete data zonder zichtbare reden

**Dubbele Records in DIM Table:**
- Kan ontstaan door: verkeerde SQL query, merge/join fout, import zonder deduplicatie
- Resulteert in: measures tellen dubbel

**Hardcoded Pad:**
- Kan ontstaan door: lokaal ontwikkelen, geen parameters gebruiken, OneDrive pad hardcoded
- Resulteert in: bestand niet gevonden, refresh faalt

**Budgetten Niet Geüpdatet:**
- Kan ontstaan door: Excel niet bijgewerkt, refresh niet ingeschakeld, verkeerd bestand gekoppeld
- Resulteert in: verouderde cijfers, variance klopt niet

---

### 5. **Speelbaarheid**

Scenario moet **deductie mogelijk maken**:

**Meerdere Aanknopingspunten:**
- Agents kunnen hints geven vanuit hun perspectief
- Timing/planning info helpt bij eliminatie
- Technische clues wijzen richting oplossing

**Niet Te Makkelijk:**
- Antwoord mag niet direct zichtbaar zijn
- Speler moet 2-3 hints combineren

**Niet Te Moeilijk:**
- Met alle 3 agents gesproken → voldoende info
- Logische conclusie mogelijk zonder te veel gissen

---

## 🧪 Testcriteria per Scenario

Elk scenario moet deze vragen met JA beantwoorden:

### Realisme Check
- [ ] Zou een Power BI professional zeggen: **"Ja, dat kan echt gebeuren"**?
- [ ] Herken ik deze situatie uit mijn eigen ervaring of verhalen?
- [ ] Is dit een veelvoorkomend probleem in Power BI?

### Logica Check
- [ ] Heeft de **persoon** toegang/verantwoordelijkheid voor deze actie?
- [ ] Is er een **logische reden** waarom deze persoon dit deed?
- [ ] Leidt de **actie direct** tot het wapen?
- [ ] Klopt de **locatie** als plaats van actie of ontdekking?

### Techniek Check
- [ ] Kan het **wapen** echt zo ontstaan?
- [ ] Zijn persoon + wapen + locatie **technisch consistent**?
- [ ] Zou een foutmelding/symptoom matchen met dit scenario?

### Speelbaarheid Check
- [ ] Kunnen agents **3 verschillende perspectieven** geven?
- [ ] Zijn er **meerdere hints** die naar de oplossing wijzen?
- [ ] Kunnen spelers **andere opties elimineren** via alibi's?
- [ ] Is de oplossing **deduceerbaar** (niet raden)?

### Storytelling Check
- [ ] Is er een **coherent verhaal** met begin/midden/eind?
- [ ] Wordt **menselijk gedrag** realistisch weergegeven?
- [ ] Kunnen agents **karaktervol** reageren op vragen?

---

## ❌ Anti-Patronen (VERMIJDEN)

### Geforceerde Combinaties
```
❌ "De stagiair maakte een hidden slicer in het semantisch model"
   → Waarom zou een stagiair dit doen? Geen motief.
   → Semantisch model is geen logische plek voor hidden slicers
   → Niet herkenbaar
```

### Technische Onmogelijkheden
```
❌ "Financial Controller wijzigde de many-to-many relatie in Power Query"
   → Financial Controller heeft geen toegang tot Power Query
   → Dit is werk van Developer/Analyst
   → Niet realistisch
```

### Vage Locaties
```
❌ "Het gebeurde ergens in Power BI"
   → Te vaag, niet specifiek genoeg
   → Geen duidelijke causale link
```

### Opzettelijk Sabotage
```
❌ "Developer maakte expres een fout om..."
   → We willen onbewuste fouten, geen sabotage
   → Niet herkenbaar als dagelijkse situatie
```

---

## 📋 Scenario Template

```markdown
### SCENARIO [NR]: [Naam]

**Persoon:** [Wie]
**Wapen:** [Wat ging fout]
**Locatie:** [Waar]

**Verhaal:**
[Beschrijving situatie met timing, motief, actie, resultaat]

**Causale Keten:**
1. [Persoon] had [reden] om [actie] uit te voeren
2. Tijdens [actie] ging [technische fout] fout
3. Dit resulteerde in [wapen symptoom]
4. Ontdekt/zichtbaar in [locatie]

**Agent Hints Mogelijkheden:**
- Schoonmaker: [wat hoorde/zag deze persoon]
- Receptionist: [wie was waar wanneer, alibi's]
- Stagiair: [technische observatie/kennis]

**Realisme Score:** [1-5 sterren]
**Technische Accuratesse:** [1-5 sterren]
**Speelbaarheid:** [1-5 sterren]
```

---

## 🎯 Doel: 12-15 Solide Scenarios

**Liever 12 sterke scenarios dan 20 zwakke.**

Elk scenario moet minimaal **4/5 sterren** scoren op:
- Realisme
- Technische accuratesse
- Speelbaarheid

---

*Laatst bijgewerkt: 27 december 2024*
