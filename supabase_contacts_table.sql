-- Contacts table voor beurs leads
-- Aanmaken in Supabase SQL Editor

CREATE TABLE IF NOT EXISTS contacts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    naam TEXT NOT NULL,
    bedrijf TEXT NOT NULL,
    email TEXT NOT NULL,
    telefoon TEXT,
    
    -- Interesses (boolean velden)
    interesse_powerbi_training BOOLEAN DEFAULT false,
    interesse_powerbi_rapportage BOOLEAN DEFAULT false,
    interesse_ai_training BOOLEAN DEFAULT false,
    interesse_ai_automation BOOLEAN DEFAULT false,
    interesse_samenwerken BOOLEAN DEFAULT false,
    interesse_overig TEXT,
    
    -- Metadata
    created_at TIMESTAMPTZ DEFAULT NOW(),
    bron TEXT DEFAULT 'beurs_qr', -- om te tracken waar lead vandaan komt
    
    -- Indexen voor snellere queries
    CONSTRAINT contacts_email_check CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

-- Index op email voor snellere lookups
CREATE INDEX IF NOT EXISTS idx_contacts_email ON contacts(email);

-- Index op created_at voor rapportage
CREATE INDEX IF NOT EXISTS idx_contacts_created_at ON contacts(created_at DESC);

-- Row Level Security (RLS) - optioneel, voor nu uit
ALTER TABLE contacts ENABLE ROW LEVEL SECURITY;

-- Policy: iedereen mag inserts doen (voor formulier)
CREATE POLICY "Enable insert for all users" ON contacts
    FOR INSERT
    WITH CHECK (true);

-- Policy: alleen authenticated users mogen lezen (voor jou in dashboard)
CREATE POLICY "Enable read for authenticated users only" ON contacts
    FOR SELECT
    USING (auth.role() = 'authenticated');

-- Optioneel: View voor rapportage
CREATE OR REPLACE VIEW contacts_summary AS
SELECT 
    DATE(created_at) as datum,
    COUNT(*) as aantal_leads,
    COUNT(CASE WHEN interesse_powerbi_training THEN 1 END) as powerbi_training,
    COUNT(CASE WHEN interesse_powerbi_rapportage THEN 1 END) as powerbi_rapportage,
    COUNT(CASE WHEN interesse_ai_training THEN 1 END) as ai_training,
    COUNT(CASE WHEN interesse_ai_automation THEN 1 END) as ai_automation,
    COUNT(CASE WHEN interesse_samenwerken THEN 1 END) as samenwerken,
    COUNT(CASE WHEN interesse_overig IS NOT NULL AND interesse_overig != '' THEN 1 END) as overig
FROM contacts
GROUP BY DATE(created_at)
ORDER BY datum DESC;
