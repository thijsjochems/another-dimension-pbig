-- SCENARIO 32: De Stille Stop
-- Power BI Developer + Refresh Uitgeschakeld + Power Query Editor

-- EERST: Nieuw wapen toevoegen
INSERT INTO wapens (id, naam, nfc_code, beschrijving, technische_uitleg) VALUES
(7, 'Refresh Uitgeschakeld', 'TEMP_NFC_WEAPON_7',
 'Een query waar het "Include in report refresh" vinkje per ongeluk is uitgezet, waardoor de tabel niet meer mee-refresht maar wel in het model blijft staan.',
 'In Power Query Editor heeft elke query een vinkje "Include in report refresh". Als dit uit staat, blijft de query wel in het model (Enable Load = aan) maar refresht deze NIET mee tijdens scheduled refreshes. Er komt geen error, geen warning - de data wordt gewoon steeds ouder. Dit is handig voor statische referentie tabellen, maar catastrofaal als je het per ongeluk uitzet bij een belangrijke data tabel.');

-- SCENARIO 32
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

-- Hints voor scenario 32
INSERT INTO scenario_hints (scenario_id, agent_id, hint_context) VALUES
(32, 1, 'Ik was haar bureau aan het opruimen. Die Power BI Developer is echt een chaos, overal notitiepapiertjes. Op eentje stond: "TODO: Sales query check - refresh nodig?" met een vraagteken. En ik zag op haar scherm dat Power Query Editor open stond, met zo''n lijst aan de linkerkant. Ze zat te klikken bij de vinkjes. Weet niet wat ze deed, maar ze keek geconcentreerd. Opruimen ofzo?'),

(32, 2, 'Oh die Power BI Developer! Kwam vorige week nog even langs, vroeg of ik wist hoeveel ruimte we nog hadden in de Power BI Service. Ze zei: "Ik ben aan het opschonen, kijken wat weg kan." Leek me logisch, beetje opruimen. Maar later hoorde ik managers klagen over verouderde cijfers in het dashboard. Zou dat ermee te maken hebben? Ik heb geen verstand van computers.'),

(32, 3, 'Yo, dus ik was laatst aan het leren over Power Query. Je hebt daar zo''n vinkje: "Include in report refresh". Als dat uit staat, blijft de tabel in je model maar refresht ie niet mee. Gek he? En ik zie in de refresh history dat de Sales query al dagen niet meer refresht, terwijl andere queries wel elke nacht draaien. De Power BI Developer was aan het testen met queries vorige week, misschien heeft ze per ongeluk dat vinkje uitgezet?');

-- Verificatie
SELECT 'WAPEN' as type, id, naam FROM wapens WHERE id = 7;
SELECT 'SCENARIO' as type, id, naam, persoon_id, wapen_id, locatie_id FROM scenarios WHERE id = 32;
SELECT 'HINTS' as type, scenario_id, agent_id, COUNT(*) FROM scenario_hints WHERE scenario_id = 32 GROUP BY scenario_id, agent_id;
