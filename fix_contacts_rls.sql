-- FIX voor RLS policy op contacts tabel
-- Voer dit uit in Supabase SQL Editor

-- Verwijder de oude restrictieve policy
DROP POLICY IF EXISTS "Enable insert for all users" ON contacts;

-- Nieuwe policy: sta anonymous inserts toe (voor formulier)
CREATE POLICY "Allow anonymous inserts" ON contacts
    FOR INSERT
    TO anon
    WITH CHECK (true);

-- Policy voor authenticated users (lezen voor jou in dashboard)
DROP POLICY IF EXISTS "Enable read for authenticated users only" ON contacts;

CREATE POLICY "Allow authenticated reads" ON contacts
    FOR SELECT
    TO authenticated
    USING (true);

-- Test: probeer een insert (dit zou moeten werken)
-- SELECT current_user; -- Check welke role je gebruikt
