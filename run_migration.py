#!/usr/bin/env python3
"""
Run migration manually via Python
"""
from dotenv import load_dotenv
import os

load_dotenv()

from supabase import create_client

SUPABASE_URL = os.getenv("SUPABASE_URL")
SERVICE_ROLE_KEY = os.getenv("SERVICE_ROLE_KEY")

supabase = create_client(SUPABASE_URL, SERVICE_ROLE_KEY)

print("⚠️  Migration moet handmatig in Supabase SQL Editor worden uitgevoerd")
print("📄 Bestand: SQL/migration_multi_nfc_support.sql")
print()
print("STAPPEN:")
print("1. Ga naar: https://supabase.com/dashboard/project/eiynfrgezfyncoqaemfr/sql/new")
print("2. Kopieer inhoud van SQL/migration_multi_nfc_support.sql")
print("3. Plak in SQL Editor")
print("4. Klik 'Run'")
print()
print("🔍 Verificatie: Na migration, run dit script opnieuw met --verify")

if len(os.sys.argv) > 1 and os.sys.argv[1] == '--verify':
    print("\n✅ Verificatie...")
    
    # Check if nfc_codes columns exist
    result = supabase.table('personen').select('id, naam, nfc_code, nfc_codes').limit(1).execute()
    if result.data:
        print(f"\n✅ Personen - nfc_codes kolom bestaat")
        print(f"   Voorbeeld: {result.data[0]}")
    
    result = supabase.table('wapens').select('id, naam, nfc_code, nfc_codes').limit(1).execute()
    if result.data:
        print(f"\n✅ Wapens - nfc_codes kolom bestaat")
        print(f"   Voorbeeld: {result.data[0]}")
    
    result = supabase.table('locaties').select('id, naam, nfc_code, nfc_codes').limit(1).execute()
    if result.data:
        print(f"\n✅ Locaties - nfc_codes kolom bestaat")
        print(f"   Voorbeeld: {result.data[0]}")
    
    result = supabase.table('agents').select('id, naam, nfc_code, nfc_codes').limit(1).execute()
    if result.data:
        print(f"\n✅ Agents - nfc_codes kolom bestaat")
        print(f"   Voorbeeld: {result.data[0]}")
    
    result = supabase.table('special_nfc_codes').select('id, code_type, nfc_code, nfc_codes').limit(1).execute()
    if result.data:
        print(f"\n✅ Special_nfc_codes - nfc_codes kolom bestaat")
        print(f"   Voorbeeld: {result.data[0]}")
    
    print("\n🎉 Migration successful!")
