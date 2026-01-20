-- SCENARIO 31: De Hoofdletter Catastrofe
-- Financial Controller + Kolomnaam Gewijzigd + Semantisch Model

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

-- Hints voor scenario 31
INSERT INTO scenario_hints (scenario_id, agent_id, hint_context) VALUES
(31, 1, 'Ik was die week niet op kantoor - samen met de Database Beheerder op vakantie in Barcelona. Heerlijk! Padel gespeeld, zon gepakt. Wat was het een zooi toen ik terugkwam van vakantie!'),

(31, 2, 'Oh die Financial Controller! Vorige week zat ie nog in de vergaderzaal met de Power BI Developer. Ze was hem aan het trainen, zag er heel gezellig uit. Kopjes koffie, laptop tussen hen in. Later zei de Financial Controller nog tegen me: "Ik ga eindelijk zelf wat dingen aanpassen in dat rapport!" Leek enthousiast. En die stagiair kwam ook nog langs bij hem, vroeg iets over hoofdletters in rapporten. Weet niet precies wat, ik heb geen verstand van computers.'),

(31, 3, 'Yo, dus ik had aan de Financial Controller gevraagd of er niet betere leesbaarheid in het rapport kon. Je weet wel, hoofdletters bij kolomnamen in plaats van die rare kleine letters met underscores. Hij zei: "Goede suggestie, ik pas het wel aan!" Ik dacht: chill, die heeft toch een training gehad van de Power BI Developer. Maar later hoorde ik haar klagen dat alle measures kapot waren. Ze zei iets over "kolomnamen gewijzigd in het model". Oeps...');

-- Verificatie
SELECT id, naam, persoon_id, wapen_id, locatie_id FROM scenarios WHERE id = 31;
SELECT scenario_id, agent_id, COUNT(*) FROM scenario_hints WHERE scenario_id = 31 GROUP BY scenario_id, agent_id;
