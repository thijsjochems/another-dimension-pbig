"""
Voeg nieuwe special NFC code toe voor AGENTS
"""
from db_helper import supabase

print("=" * 80)
print("➕ AGENTS SPECIAL CODE TOEVOEGEN")
print("=" * 80)

# Voeg nieuwe special code toe
result = supabase.table('special_nfc_codes').insert({
    'code_type': 'AGENTS',
    'nfc_code': 'TEMP_NFC_AGENTS',
    'description': 'Reminder: scan agents met je telefoon',
    'nfc_codes': ['TEMP_NFC_AGENTS']
}).execute()

print(f"\n✅ AGENTS special code aangemaakt!")
print(f"   ID: {result.data[0]['id']}")
print(f"   Type: AGENTS")
print(f"   Melding: 'Scan mij met je telefoon, weet je nog?'")
print(f"\n💡 Je kunt nu add_backup_codes.py gebruiken om de agent codes te scannen")

print("\n" + "=" * 80)
