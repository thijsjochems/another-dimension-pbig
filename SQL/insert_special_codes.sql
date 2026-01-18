-- Insert special NFC codes for game controls
-- Run this in Supabase SQL Editor

INSERT INTO special_nfc_codes (code_type, nfc_code, description) VALUES
('EXIT', 'TEMP_NFC_EXIT', 'Standhouder pasje om actief spel af te breken'),
('RESET', 'TEMP_NFC_RESET', 'Reset applicatie naar homepage'),
('YES', 'TEMP_NFC_YES', 'Bevestig actie'),
('NO', 'TEMP_NFC_NO', 'Annuleer actie')
ON CONFLICT (nfc_code) DO NOTHING;
