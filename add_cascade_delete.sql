-- CASCADE DELETE: Chat messages automatisch verwijderen bij game deletion
-- Run this in Supabase SQL Editor

-- 1. Verwijder bestaande constraint (als die bestaat)
ALTER TABLE chat_messages 
DROP CONSTRAINT IF EXISTS chat_messages_game_id_fkey;

-- 2. Voeg nieuwe constraint toe met CASCADE DELETE
ALTER TABLE chat_messages
ADD CONSTRAINT chat_messages_game_id_fkey 
FOREIGN KEY (game_id) 
REFERENCES games(id) 
ON DELETE CASCADE;

-- 3. Verificatie query (run dit NA de ALTER statements)
SELECT 
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name,
    rc.delete_rule
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
JOIN information_schema.referential_constraints AS rc
    ON rc.constraint_name = tc.constraint_name
WHERE tc.table_name = 'chat_messages'
    AND tc.constraint_type = 'FOREIGN KEY'
    AND kcu.column_name = 'game_id';

-- Verwachte output: delete_rule = 'CASCADE'
