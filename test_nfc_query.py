"""Test NFC query om te kijken of TEMP codes gevonden worden"""
import os
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()
SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_KEY")
supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

# Test met een TEMP code
test_code = "TEMP_NFC_WEAPON_1"

print(f"🔍 Testing NFC mapping voor: {test_code}\n")

# Test personen
print("1. Checking personen...")
result = supabase.table('personen').select('*').or_(f'nfc_code.eq.{test_code},nfc_codes.cs.["{test_code}"]').execute()
print(f"   Found: {len(result.data)} records")
if result.data:
    print(f"   → {result.data[0]['naam']}")

# Test wapens
print("\n2. Checking wapens...")
result = supabase.table('wapens').select('*').or_(f'nfc_code.eq.{test_code},nfc_codes.cs.["{test_code}"]').execute()
print(f"   Found: {len(result.data)} records")
if result.data:
    print(f"   → {result.data[0]['naam']}")
    print(f"   nfc_codes: {result.data[0]['nfc_codes']}")

# Test locaties
print("\n3. Checking locaties...")
test_code2 = "TEMP_NFC_LOCATION_1"
result = supabase.table('locaties').select('*').or_(f'nfc_code.eq.{test_code2},nfc_codes.cs.["{test_code2}"]').execute()
print(f"   Found: {len(result.data)} records")
if result.data:
    print(f"   → {result.data[0]['naam']}")
    print(f"   nfc_codes: {result.data[0]['nfc_codes']}")

print("\n✅ Test complete!")
