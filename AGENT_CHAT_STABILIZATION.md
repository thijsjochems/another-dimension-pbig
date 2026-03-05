# Agent Chat Stabilisatie (na scenario-verstrakking)

## Waarom dit nodig is
De scenario-inhoud is nu inhoudelijk sterker, maar de chat kan nog te "robotisch" aanvoelen door strakke guardrails.
Doel is **balans**:
- scenario-waarheid bewaken (geen hallucinaties),
- én natuurlijk gesprek met karakter en geheugen behouden.

## Huidige observaties
- Soms onterechte weigeringstekst: "Dat kan ik niet direct zeggen..." bij normale informatievraag.
- Smalltalk wordt niet altijd als smalltalk herkend.
- Antwoorden kunnen soms te generiek klinken door fallback/sanitizer.

## Gewenste eindgedrag
1. **Gesprek voelt natuurlijk**
   - Groet/smalltalk krijgt menselijk antwoord per agent.
   - Doorvragen blijft in dezelfde lijn (geen abrupt reset naar keuze-menu).
2. **Geheugen blijft werken**
   - Agent verwijst naar eerdere uitwisselingen waar relevant.
3. **Scenario blijft leidend**
   - Nieuwe feiten buiten de fasehint blijven geblokkeerd.
   - Directe "geef de oplossing"-vragen blijven afgevangen.

## Technische bedoeling (index.ts)
- `phaseHint` = fasegebonden waarheid per agentbeurt.
- `chatHistory` = conversatiegeheugen.
- Beide gaan samen naar het model in dezelfde call.
- Sanitizer blijft bestaan, maar alleen strikt waar nodig.

## Actieplan (volgende iteratie)
- [ ] Intent-routing explicieter maken: `smalltalk` / `info_request` / `direct_solution_request`.
- [ ] Weigeringstekst alleen bij echte oplossingsvraag, nooit bij "wat heb je gezien".
- [ ] Fallback-varianten uitbreiden (3-5 per intent) om herhaling te voorkomen.
- [ ] Topic-anker toevoegen: bij "vertel meer over haar" dezelfde entiteit vasthouden.
- [ ] Light telemetry/logging toevoegen (welke guardrail triggerde) voor snelle diagnose.

## Testscript voor morgen
Gebruik scenario 12 met deze volgorde:
1. `yooo`
2. `wat heb je gezien?`
3. `vertel meer over haar`
4. `is zij de dader?`

Verwachting:
- 1: natuurlijk smalltalk antwoord.
- 2-3: inhoudelijk, fasegebonden observaties.
- 4: nette weigering + kleine observatie, zonder robottoon.

## Acceptatiecriteria
- Geen onterechte weigering bij normale info-vragen.
- Smalltalk voelt menselijk per agent-rol.
- Geen nieuwe hallucinaties buiten fasehint.
- Gespreksflow blijft coherent over meerdere turns.
