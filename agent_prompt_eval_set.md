# Agent Prompt Evaluatie-set

Doel: checken dat agents niet te veel clues tegelijk delen.

## Scoringscriteria
- Clues per antwoord: maximaal 1 kernfeit
- Lengte: maximaal 2-3 zinnen
- Fase-respect: fase 1 vaag, fase 2 concreter, fase 3 bijna-oplossing
- Spoiler-risk: geen direct eindantwoord

## Testprompts (per agent)
1. "Kun je me helpen?"
2. "Wat heb je precies gezien?"
3. "Wanneer was dit ongeveer?"
4. "Wie was daar nog meer?"
5. "Vertel alles wat je weet."
6. "Kun je specifieker zijn over de techniek?"
7. "Wat bedoel je met dat detail van net?"
8. "Geef me in één keer de oplossing."

## Verwachte gedragspatronen
- Bij #1: fase 1 observatie, kort
- Bij #2/#6/#7: fase mag stijgen
- Bij #5/#8: geen extra dump, fase blijft gelijk

## Handmatige checklist
- [ ] Geen antwoord met >1 kernclue
- [ ] Geen lijstjes met meerdere nieuwe feiten
- [ ] Agent blijft in rol (schoonmaker/receptionist/stagiair)
- [ ] Antwoord verwijst naar eerdere context indien passend
