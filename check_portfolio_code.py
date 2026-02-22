"""Check of code 3665849860 in PORTFOLIO zit"""
from db_helper import supabase

target_code = '3665849860'

# Check PORTFOLIO (ID 4)
result = supabase.table('special_nfc_codes').select('id, code_type, nfc_code, nfc_codes').eq('id', 4).execute()

if result.data:
    item = result.data[0]
    print(f"\n📋 PORTFOLIO (ID {item['id']}):")
    print(f"   Primary code: {item['nfc_code']}")
    print(f"   All codes: {item['nfc_codes']}")
    print(f"   Aantal codes: {len(item['nfc_codes'])}")
    print(f"\n🔍 Check voor code {target_code}:")
    
    if target_code in item['nfc_codes']:
        print(f"   ✅ Code {target_code} staat WEL in de database!")
    else:
        print(f"   ❌ Code {target_code} staat NIET in de database!")
        print(f"\n   → Code toevoegen...")
        
        # Voeg code toe
        current_codes = item['nfc_codes']
        current_codes.append(target_code)
        
        supabase.table('special_nfc_codes').update({
            'nfc_codes': current_codes
        }).eq('id', 4).execute()
        
        print(f"   ✅ Code toegevoegd! Nieuwe totaal: {len(current_codes)} codes")
else:
    print("❌ PORTFOLIO niet gevonden!")
