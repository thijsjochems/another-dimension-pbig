"""Verander code_type van PORTFOLIO naar POWER_BI_PORTFOLIO"""
from db_helper import supabase

print("=" * 80)
print("🔧 CODE_TYPE AANPASSEN")
print("=" * 80)

# Check huidige waarde
result = supabase.table('special_nfc_codes').select('id, code_type, nfc_codes').eq('id', 4).execute()

if result.data:
    item = result.data[0]
    print(f"\n📋 VOOR aanpassing:")
    print(f"   ID: {item['id']}")
    print(f"   Code type: {item['code_type']}")
    print(f"   Aantal codes: {len(item['nfc_codes'])}")
    
    # Update code_type
    supabase.table('special_nfc_codes').update({
        'code_type': 'POWERBI_PORTFOLIO'
    }).eq('id', 4).execute()
    
    # Check nieuwe waarde
    result_after = supabase.table('special_nfc_codes').select('id, code_type, nfc_codes').eq('id', 4).execute()
    item_after = result_after.data[0]
    
    print(f"\n📋 NA aanpassing:")
    print(f"   ID: {item_after['id']}")
    print(f"   Code type: {item_after['code_type']}")
    print(f"   Aantal codes: {len(item_after['nfc_codes'])}")
    
    print(f"\n✅ Code type veranderd van '{item['code_type']}' naar '{item_after['code_type']}'!")
    print(f"   Nu werken beide items met dezelfde switch case in de code")
else:
    print("❌ Item niet gevonden!")

print("\n" + "=" * 80)
