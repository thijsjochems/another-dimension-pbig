"""Toon alle items in de database met hun NFC codes"""
import os
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()
SUPABASE_URL = os.getenv("SUPABASE_URL")
SERVICE_ROLE_KEY = os.getenv("SERVICE_ROLE_KEY")
supabase = create_client(SUPABASE_URL, SERVICE_ROLE_KEY)

print("\n" + "=" * 80)
print("📋 ALLE ITEMS IN DE DATABASE")
print("=" * 80)

# Personen
print("\n🔹 PERSONEN (Daders):")
result = supabase.table('personen').select('id, naam, nfc_code, nfc_codes').order('id').execute()
for r in result.data:
    codes_count = len(r.get('nfc_codes', []))
    print(f"  {r['id']:2d}. {r['naam']:45s} {r['nfc_code']:25s} ({codes_count} codes)")

# Wapens
print("\n🔹 WAPENS:")
result = supabase.table('wapens').select('id, naam, nfc_code, nfc_codes').order('id').execute()
for r in result.data:
    codes_count = len(r.get('nfc_codes', []))
    print(f"  {r['id']:2d}. {r['naam']:45s} {r['nfc_code']:25s} ({codes_count} codes)")

# Locaties
print("\n🔹 LOCATIES:")
result = supabase.table('locaties').select('id, naam, nfc_code, nfc_codes').order('id').execute()
for r in result.data:
    codes_count = len(r.get('nfc_codes', []))
    print(f"  {r['id']:2d}. {r['naam']:45s} {r['nfc_code']:25s} ({codes_count} codes)")

# Special codes
print("\n🔹 SPECIAL CODES:")
result = supabase.table('special_nfc_codes').select('id, code_type, nfc_code, nfc_codes').order('id').execute()
for r in result.data:
    codes_count = len(r.get('nfc_codes', []))
    is_temp = '⚠️ TEMP' if r['nfc_code'].startswith('TEMP_NFC') else ''
    print(f"  {r['id']:2d}. {r['code_type']:45s} {r['nfc_code']:25s} ({codes_count} codes) {is_temp}")

print("\n" + "=" * 80)
