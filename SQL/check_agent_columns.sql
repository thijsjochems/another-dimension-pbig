-- Check actual column names in agents table
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'agents' 
ORDER BY ordinal_position;

-- And show actual data
SELECT * FROM agents LIMIT 3;
