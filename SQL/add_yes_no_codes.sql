-- Add YES and NO special NFC codes for standbeheerder

INSERT INTO special_nfc_codes (code_type, nfc_code, description) VALUES
('YES', 'TEMP_NFC_YES', 'Standbeheerder bevestiging - JA'),
('NO', 'TEMP_NFC_NO', 'Standbeheerder bevestiging - NEE')
ON CONFLICT (code_type) DO NOTHING;
