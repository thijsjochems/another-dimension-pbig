"""Vergelijk beide codes om te zien wat het verschil is"""
from db_helper import supabase

code1 = '3665849860'  # Werkt NIET
code2 = '3665846788'  # Werkt WEL

print("=" * 80)
print("🔍 CODE VERGELIJKING")
print("=" * 80)

tables = ['personen', 'wapens', 'locaties', 'agents', 'special_nfc_codes']

for code in [code1, code2]:
    print(f"\n📡 Code: {code}")
    found = False
    
    for table in tables:
        if table == 'special_nfc_codes':
            result = supabase.table(table).select('id, code_type, nfc_codes').execute()
        else:
            result = supabase.table(table).select('id, naam, nfc_codes').execute()
        
        for item in result.data:
            if code in item.get('nfc_codes', []):
                naam = item.get('naam') or item.get('code_type', 'Unknown')
                print(f"   ✅ Gevonden in: {table}")
                print(f"      Item: {naam} (ID {item['id']})")
                print(f"      Totaal codes: {len(item['nfc_codes'])}")
                found = True
                break
        
        if found:
            break
    
    if not found:
        print(f"   ❌ NIET GEVONDEN in database!")

print("\n" + "=" * 80)
