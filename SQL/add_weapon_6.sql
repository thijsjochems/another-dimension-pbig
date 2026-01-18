-- Add 6th weapon: Kolomnaam Gewijzigd
-- This is for scenario 9

INSERT INTO wapens (naam, nfc_code, beschrijving, technische_uitleg) VALUES
(
    'Kolomnaam Gewijzigd',
    'TEMP_NFC_WEAPON_6',
    'Een kolomnaam in de brontabel is gewijzigd, maar Power Query verwijst nog naar de oude naam.',
    'Power Query refresh faalt met error "Column not found". Dashboard wordt niet bijgewerkt met nieuwe data. Mapping tussen oude en nieuwe kolomnamen ontbreekt.'
)
ON CONFLICT (nfc_code) DO NOTHING;
