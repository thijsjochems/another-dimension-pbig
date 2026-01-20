-- SCENARIO 30: De Dubbele Budget Backup
-- Financial Controller + Dubbele Records + OneDrive

INSERT INTO scenarios (id, persoon_id, wapen_id, locatie_id, naam, situatie_beschrijving, beschrijving, archive_flag)
VALUES (
  30,
  4, -- Financial Controller (man)
  3, -- Dubbele Records
  1, -- OneDrive
  'De Budget Backup Blunder',
  'Het Q1 budget dashboard toont plotseling het dubbele van de verwachte cijfers. Alle budget totalen zijn 2x zo hoog. De CFO is in paniek: "Hebben we echt zoveel budget?" Gisteren klopte alles nog.',
  'De Financial Controller wilde voorzichtig zijn. Voor hij aanpassingen ging maken aan de budget file, maakte hij even een backup: Budget_2026_Q1.xlsx werd Budget_2026_Q1_BACKUP.xlsx. Beide stonden op zijn OneDrive. Wat hij niet doorhad: Power Query was ingesteld om ALLE Excel bestanden in die OneDrive folder te laden die met "Budget_2026" beginnen. Vanaf dat moment laadde het rapport dezelfde budget data twee keer in. Elke regel dubbel. Alle totalen vermenigvuldigd met 2. De CFO dacht dat er een enorme budget verhoging was doorgevoerd.',
  0
);

-- Hints voor scenario 30
INSERT INTO scenario_hints (scenario_id, agent_id, hint_context) VALUES
(30, 1, 'Ik was z''n kantoor aan het stofzuigen. Die Financial Controller is altijd zo netjes met z''n administratie. Zag op zijn scherm dat ie bezig was met een Excel bestand. En toen zag ik dat ie het kopieerde - gewoon Ctrl+C, Ctrl+V. Hoorde hem mompelen: "Even een backup maken voor de zekerheid." Voorzichtig mannetje, snap ik wel. Maar of dat handig is met al die Power BI rapporten die naar z''n OneDrive kijken? Geen idee, ik ben maar een schoonmaker.'),

(30, 2, 'Oh die Financial Controller! Kwam vorige week nog langs, vroeg of ik wist hoe je een backup maakt. Ik zei: "Ik heb geen verstand van computers of Power Dinges, sorry!" Hij moest een beetje lachen. Oh ja, de Database Beheerder was trouwens op padel trip in Barcelona die week. Voorzichtig mannetje die Financial Controller, maakte overal backups van voor de zekerheid. Maar of dat handig is? Geen idee, ik ben maar de receptionist.'),

(30, 3, 'Ehhh ja die Financial Controller ken ik wel. Hij vroeg of ik hem kon helpen met een Excel analyse - beetje saai werk, data checken enzo. Toen zei ie: "Je mag in die file doen wat je wilt, ik heb toch een backup gemaakt." Ik dacht: chill, dan kan ik niet fout zitten. Maar later zag ik die Power BI Developer helemaal gestrest rondlopen. Ze zei iets over "dubbele cijfers in het dashboard". Zou dat met die backup te maken hebben? Want ik zie wel twee bestanden op z''n OneDrive staan met bijna dezelfde naam.');

-- Verificatie
SELECT id, naam, persoon_id, wapen_id, locatie_id FROM scenarios WHERE id = 30;
SELECT scenario_id, agent_id, COUNT(*) FROM scenario_hints WHERE scenario_id = 30 GROUP BY scenario_id, agent_id;
