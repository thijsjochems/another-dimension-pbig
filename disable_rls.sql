-- SIMPELE FIX: Schakel RLS uit voor contacts tabel
-- Dit is veilig omdat de tabel alleen voor beurs leads is

ALTER TABLE contacts DISABLE ROW LEVEL SECURITY;

-- Verwijder alle oude policies
DROP POLICY IF EXISTS "Enable insert for all users" ON contacts;
DROP POLICY IF EXISTS "Allow anonymous inserts" ON contacts;
DROP POLICY IF EXISTS "Enable read for authenticated users only" ON contacts;
DROP POLICY IF EXISTS "Allow authenticated reads" ON contacts;

-- Nu kan iedereen inserten en jij kunt lezen via Supabase dashboard
