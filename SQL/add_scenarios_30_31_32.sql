-- Voeg 3 nieuwe scenarios toe (30, 31, 32) + nieuw wapen (7)
-- Scenario 30: Budget Backup Blunder - Financial Controller + Dubbele Records + OneDrive
-- Scenario 31: Hoofdletter Catastrofe - Financial Controller + Kolomnaam Gewijzigd + Semantisch Model
-- Scenario 32: De Stille Stop - Power BI Developer + Refresh Uitgeschakeld + Power Query Editor

-- STAP 1: Nieuw wapen toevoegen
INSERT INTO wapens (id, naam, nfc_code, beschrijving, technische_uitleg) VALUES
(7, 'Refresh Uitgeschakeld', 'TEMP_NFC_WEAPON_7',
 'Een query waar het "Include in report refresh" vinkje per ongeluk is uitgezet, waardoor de tabel niet meer mee-refresht maar wel in het model blijft staan.',
 'In Power Query Editor heeft elke query een vinkje "Include in report refresh". Als dit uit staat, blijft de query wel in het model (Enable Load = aan) maar refresht deze NIET mee tijdens scheduled refreshes. Er komt geen error, geen warning - de data wordt gewoon steeds ouder. Dit is handig voor statische referentie tabellen, maar catastrofaal als je het per ongeluk uitzet bij een belangrijke data tabel.');

-- STAP 2: Scenario 30
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

INSERT INTO scenario_hints (scenario_id, agent_id, hint_context) VALUES
(30, 1, 'Ik was z''n kantoor aan het stofzuigen. Die Financial Controller is altijd zo netjes met z''n administratie. Zag op zijn scherm dat ie bezig was met een Excel bestand. En toen zag ik dat ie het kopieerde - gewoon Ctrl+C, Ctrl+V. Hoorde hem mompelen: "Even een backup maken voor de zekerheid." Voorzichtig mannetje, snap ik wel. Maar of dat handig is met al die Power BI rapporten die naar z''n OneDrive kijken? Geen idee, ik ben maar een schoonmaker.'),

(30, 2, 'Oh die Financial Controller! Kwam vorige week nog langs, vroeg of ik wist hoe je een backup maakt. Ik zei: "Ik heb geen verstand van computers of Power Dinges, sorry!" Hij moest een beetje lachen. Oh ja, de Database Beheerder was trouwens op padel trip in Barcelona die week. Voorzichtig mannetje die Financial Controller, maakte overal backups van voor de zekerheid. Maar of dat handig is? Geen idee, ik ben maar de receptionist.'),

(30, 3, 'Ehhh ja die Financial Controller ken ik wel. Hij vroeg of ik hem kon helpen met een Excel analyse - beetje saai werk, data checken enzo. Toen zei ie: "Je mag in die file doen wat je wilt, ik heb toch een backup gemaakt." Ik dacht: chill, dan kan ik niet fout zitten. Maar later zag ik die Power BI Developer helemaal gestrest rondlopen. Ze zei iets over "dubbele cijfers in het dashboard". Zou dat met die backup te maken hebben? Want ik zie wel twee bestanden op z''n OneDrive staan met bijna dezelfde naam.');

-- STAP 3: Scenario 31
INSERT INTO scenarios (id, persoon_id, wapen_id, locatie_id, naam, situatie_beschrijving, beschrijving, archive_flag)
VALUES (
  31,
  4, -- Financial Controller (man)
  6, -- Kolomnaam Gewijzigd
  3, -- Semantisch Model
  'De Hoofdletter Catastrofe',
  'Het dashboard toont alleen foutmeldingen. Alle measures zijn rood. Error: "Can''t find column Revenue_Amount". Gisteren werkte alles nog perfect. Wat is er gebeurd?',
  'De stagiair had een goede suggestie: "Kunnen die kolomnamen niet met hoofdletters? Dat leest veel beter." De Financial Controller had net een training gehad van de Power BI Developer over het datamodel. Hij dacht: dat kan ik wel zelf aanpassen! In het Semantisch Model hernoemde hij netjes alle kolomnamen: revenue_amount werd REVENUE_AMOUNT, order_date werd ORDER_DATE. Zag er inderdaad veel professioneler uit. Wat hij niet doorhad: alle measures gebruiken nog de oude kolomnamen met kleine letters. Elke measure die naar "revenue_amount" verwees, kon de kolom niet meer vinden. Het hele dashboard crashte. 50+ measures. Allemaal rood.',
  0
);

INSERT INTO scenario_hints (scenario_id, agent_id, hint_context) VALUES
(31, 1, 'Ik was die week niet op kantoor - samen met de Database Beheerder op vakantie in Barcelona. Heerlijk! Padel gespeeld, zon gepakt. Wat was het een zooi toen ik terugkwam van vakantie!'),

(31, 2, 'Oh die Financial Controller! Vorige week zat ie nog in de vergaderzaal met de Power BI Developer. Ze was hem aan het trainen, zag er heel gezellig uit. Kopjes koffie, laptop tussen hen in. Later zei de Financial Controller nog tegen me: "Ik ga eindelijk zelf wat dingen aanpassen in dat rapport!" Leek enthousiast. En die stagiair kwam ook nog langs bij hem, vroeg iets over hoofdletters in rapporten. Weet niet precies wat, ik heb geen verstand van computers.'),

(31, 3, 'Yo, dus ik had aan de Financial Controller gevraagd of er niet betere leesbaarheid in het rapport kon. Je weet wel, hoofdletters bij kolomnamen in plaats van die rare kleine letters met underscores. Hij zei: "Goede suggestie, ik pas het wel aan!" Ik dacht: chill, die heeft toch een training gehad van de Power BI Developer. Maar later hoorde ik haar klagen dat alle measures kapot waren. Ze zei iets over "kolomnamen gewijzigd in het model". Oeps...');

-- STAP 4: Scenario 32
INSERT INTO scenarios (id, persoon_id, wapen_id, locatie_id, naam, situatie_beschrijving, beschrijving, archive_flag)
VALUES (
  32,
  1, -- Power BI Developer (vrouw)
  7, -- Refresh Uitgeschakeld (NIEUW)
  2, -- Power Query Editor
  'De Stille Stop',
  'Het sales dashboard draait perfect, maar de cijfers kloppen niet. Een manager merkt op: "Dit zijn de cijfers van vorige week!" Andere tabellen zijn WEL up-to-date. Waarom refresht deze ene tabel niet mee?',
  'De Power BI Developer was queries aan het opschonen. Ze wilde even testen of een bepaalde tabel echt nodig was, dus ze zette het vinkje "Include in report refresh" uit bij de Sales query. Bedoeling was om het later weer aan te zetten. Maar ze vergat het. Het vreemde: de tabel bleef WEL in het model zitten (Enable Load stond nog aan). Elke nacht draaide de scheduled refresh, alle queries werden ververst, behalve Sales. Die bleef bij de data van 3 dagen geleden. Niemand had door waarom Sales niet meedeed met de refresh - geen error, geen melding, gewoon... stilstand.',
  0
);

INSERT INTO scenario_hints (scenario_id, agent_id, hint_context) VALUES
(32, 1, 'Ik was haar bureau aan het opruimen. Die Power BI Developer is echt een chaos, overal notitiepapiertjes. Op eentje stond: "TODO: Sales query check - refresh nodig?" met een vraagteken. En ik zag op haar scherm dat Power Query Editor open stond, met zo''n lijst aan de linkerkant. Ze zat te klikken bij de vinkjes. Weet niet wat ze deed, maar ze keek geconcentreerd. Opruimen ofzo?'),

(32, 2, 'Oh die Power BI Developer! Kwam vorige week nog even langs, vroeg of ik wist hoeveel ruimte we nog hadden in de Power BI Service. Ze zei: "Ik ben aan het opschonen, kijken wat weg kan." Leek me logisch, beetje opruimen. Maar later hoorde ik managers klagen over verouderde cijfers in het dashboard. Zou dat ermee te maken hebben? Ik heb geen verstand van computers.'),

(32, 3, 'Yo, dus ik was laatst aan het leren over Power Query. Je hebt daar zo''n vinkje: "Include in report refresh". Als dat uit staat, blijft de tabel in je model maar refresht ie niet mee. Gek he? En ik zie in de refresh history dat de Sales query al dagen niet meer refresht, terwijl andere queries wel elke nacht draaien. De Power BI Developer was aan het testen met queries vorige week, misschien heeft ze per ongeluk dat vinkje uitgezet?');

-- Verificatie
SELECT 'NIEUW WAPEN' as type, id, naam, nfc_code FROM wapens WHERE id = 7;
SELECT 'NIEUWE SCENARIOS' as type, id, naam, persoon_id, wapen_id, locatie_id FROM scenarios WHERE id IN (30, 31, 32) ORDER BY id;
SELECT 'HINTS COUNT' as type, scenario_id, COUNT(*) as hint_count FROM scenario_hints WHERE scenario_id IN (30, 31, 32) GROUP BY scenario_id ORDER BY scenario_id;
