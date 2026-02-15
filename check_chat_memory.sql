-- Check of chat history werkt
-- Run dit in Supabase SQL Editor

-- 1. Check of er chat_messages zijn opgeslagen
SELECT 
    game_id,
    agent_id,
    sender,
    LEFT(message, 50) as bericht,
    message_number,
    created_at
FROM chat_messages
ORDER BY created_at DESC
LIMIT 20;

-- 2. Check hoeveel berichten per game per agent
SELECT 
    game_id,
    agent_id,
    COUNT(*) as aantal_berichten,
    MIN(created_at) as eerste_bericht,
    MAX(created_at) as laatste_bericht
FROM chat_messages
GROUP BY game_id, agent_id
ORDER BY game_id, agent_id;

-- 3. Als GEEN data: chat_messages tabel bestaat niet of werkt niet
-- Controleer of tabel bestaat:
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name = 'chat_messages';
