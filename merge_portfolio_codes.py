"""Voeg alle PORTFOLIO codes samen in POWERBI_PORTFOLIO"""
from db_helper import supabase

print("=" * 80)
print("🔀 PORTFOLIO CODES SAMENVOEGEN")
print("=" * 80)

# Haal beide items op
portfolio = supabase.table('special_nfc_codes').select('*').eq('id', 4).execute().data[0]
powerbi_portfolio = supabase.table('special_nfc_codes').select('*').eq('id', 17).execute().data[0]

print(f"\n📋 HUIDIGE SITUATIE:")
print(f"   PORTFOLIO (ID 4):")
print(f"      Codes: {portfolio['nfc_codes']}")
print(f"      Aantal: {len(portfolio['nfc_codes'])}")

print(f"\n   POWERBI_PORTFOLIO (ID 17):")
print(f"      Codes: {powerbi_portfolio['nfc_codes']}")
print(f"      Aantal: {len(powerbi_portfolio['nfc_codes'])}")

# Combineer alle codes (zonder duplicaten)
all_codes = list(set(portfolio['nfc_codes'] + powerbi_portfolio['nfc_codes']))

print(f"\n🔄 SAMENVOEGEN...")
print(f"   Totaal unieke codes: {len(all_codes)}")

# Update POWERBI_PORTFOLIO met alle codes
supabase.table('special_nfc_codes').update({
    'nfc_codes': all_codes
}).eq('id', 17).execute()

print(f"   ✅ Alle codes toegevoegd aan POWERBI_PORTFOLIO (ID 17)")

# Verwijder het oude PORTFOLIO item
supabase.table('special_nfc_codes').delete().eq('id', 4).execute()

print(f"   ✅ PORTFOLIO (ID 4) verwijderd")

# Verificatie
result = supabase.table('special_nfc_codes').select('*').eq('id', 17).execute()
final = result.data[0]

print(f"\n📋 NIEUWE SITUATIE:")
print(f"   POWERBI_PORTFOLIO (ID 17):")
print(f"      Codes: {final['nfc_codes']}")
print(f"      Aantal: {len(final['nfc_codes'])}")

print(f"\n✅ Klaar! Alle portfolio codes werken nu via POWERBI_PORTFOLIO")
print("=" * 80)
