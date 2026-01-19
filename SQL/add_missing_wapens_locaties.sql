-- Voeg ontbrekende wapens en locaties toe aan database
-- En vervang Many-to-Many door Inactieve Relatie

-- WAPENS
INSERT INTO wapens (id, naam, nfc_code, beschrijving, technische_uitleg) VALUES
(1, 'Inactieve Relatie', 'TEMP_NFC_WEAPON_1', 
 'Een relatie die per ongeluk is uitgeschakeld in het datamodel, waardoor cruciale koppelingen tussen tabellen niet meer werken.',
 'In Power BI Desktop kun je relaties inactief maken via Manage Relationships. Een inactieve relatie wordt niet automatisch gebruikt bij berekeningen. Als iemand per ongeluk een actieve relatie deactiveert, falen alle visuals die op die relatie vertrouwen. Het is alsof twee delen van je data plotseling losgekoppeld zijn - measures geven verkeerde resultaten, filters werken niet meer, en cross-filtering stopt.'),

(4, 'Hardcoded Pad', 'TEMP_NFC_WEAPON_4',
 'Een hardgecodeerd bestandspad in Power Query dat naar een specifieke locatie wijst, waardoor het rapport crasht als die locatie niet bestaat.',
 'Power Query Editor slaat vaak absolute paden op zoals "C:\\Users\\JouwNaam\\Documents\\data.xlsx". Als je het rapport deelt of op een andere machine opent, bestaat dat pad niet meer. De refresh faalt direct met een cryptische error. Best practice is relative paths gebruiken of parameters, maar dat wordt vaak vergeten tijdens development.'),

(5, 'Budget Niet Updated', 'TEMP_NFC_WEAPON_5',
 'Een Excel bestand met budget cijfers dat niet is bijgewerkt, waardoor het rapport oude of incorrecte data toont.',
 'Veel organisaties bewaren budget data in Excel files die handmatig worden bijgewerkt. Als die file niet refresht (bijvoorbeeld omdat ie op iemands OneDrive staat en ze zijn met vakantie), toont het dashboard verouderde cijfers. Niemand ziet dat de data oud is tot het te laat is - de CFO presenteert verkeerde cijfers in een meeting.');

-- LOCATIES  
INSERT INTO locaties (id, naam, nfc_code, beschrijving) VALUES
(1, 'OneDrive', 'TEMP_NFC_LOCATION_1',
 'De persoonlijke OneDrive map van een medewerker waar databestanden staan die het rapport gebruikt. Als die persoon niet beschikbaar is of de toegang wijzigt, faalt de data refresh.'),

(2, 'Power Query Editor', 'TEMP_NFC_LOCATION_2',
 'De Power Query Editor waar alle data transformaties worden gedefinieerd. Een fout hier verspreidt zich door het hele datamodel.');

-- Verificatie
SELECT 'WAPENS' as type, id, naam, nfc_code FROM wapens ORDER BY id;
SELECT 'LOCATIES' as type, id, naam, nfc_code FROM locaties ORDER BY id;
