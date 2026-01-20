"""
Toon alle items die nog een TEMP_NFC code hebben en dus gescand moeten worden
"""

import os
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()
SUPABASE_URL = os.getenv("SUPABASE_URL")
SERVICE_ROLE_KEY = os.getenv("SERVICE_ROLE_KEY")
supabase = create_client(SUPABASE_URL, SERVICE_ROLE_KEY)

print("=" * 70)
print("📋 ITEMS DIE NOG GESCAND MOETEN WORDEN")
print("=" * 70)

tables = [
    ('personen', 'PERSONEN'),
    ('wapens', 'WAPENS'),
    ('locaties', 'LOCATIES'),
    ('agents', 'AGENTS'),
    ('special_nfc_codes', 'SPECIAL CODES')
]

total_needed = 0

for table_name, display_name in tables:
    # Special_nfc_codes heeft 'code_type' ipv 'naam'
    if table_name == 'special_nfc_codes':
        result = supabase.table(table_name).select('id, code_type, nfc_code').execute()
    else:
        result = supabase.table(table_name).select('id, naam, nfc_code').execute()
    
    # Filter items met TEMP_NFC codes
    temp_items = [item for item in result.data if item['nfc_code'].startswith('TEMP_NFC')]
    
    if temp_items:
        print(f"\n🔸 {display_name} ({len(temp_items)} te scannen):")
        for item in temp_items:
            naam = item.get('naam') or item.get('code_type', 'Unknown')
            print(f"   ID {item['id']:2d}: {naam:40s} (huidige code: {item['nfc_code']})")
            total_needed += 1

print("\n" + "=" * 70)
print(f"✅ TOTAAL TE SCANNEN: {total_needed} items")
print("=" * 70)
print("\n💡 Start scanner met: python scanner.py")
print("   Scan een tag → kies type → type ID → klaar!")
