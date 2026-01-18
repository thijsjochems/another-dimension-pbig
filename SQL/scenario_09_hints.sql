-- =============================================
-- SCENARIO 9 HINTS: De Bronsysteem Migratie
-- =============================================

-- Database Beheerder + Kolomnaam Gewijzigd + Semantisch Model
-- ERP systeem migratie met naming convention change

-- Eerst oude hints verwijderen
DELETE FROM scenario_hints WHERE scenario_id = 9;

-- Schoonmaker hints
INSERT INTO scenario_hints (scenario_id, agent_id, hint_context)
VALUES 
(9, 1, 'Database Beheerder werkte vaak tot laat in februari. Was irritant, chipszakjes overal.');

-- Receptionist hints  
INSERT INTO scenario_hints (scenario_id, agent_id, hint_context)
VALUES 
(9, 2, 'Power BI Developer was op wintersport. Frankrijk dacht ik. Of Italië. Of Oostenrijk.');

-- Stagiair hints
INSERT INTO scenario_hints (scenario_id, agent_id, hint_context)
VALUES 
(9, 3, 'Wilde iets vragen aan Admin. Admin had geen tijd voor me. Was druk bezig met het mappen van alle kolommen van de oude en de nieuwe applicatie.');

-- Check resultaat
SELECT 
    sh.scenario_id,
    s.naam as scenario,
    a.naam as agent,
    sh.hint_context
FROM scenario_hints sh
JOIN scenarios s ON sh.scenario_id = s.id
JOIN agents a ON sh.agent_id = a.id
WHERE sh.scenario_id = 9
ORDER BY sh.agent_id;
