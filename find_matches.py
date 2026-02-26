"""
Script om bestaande suspects en weapons op te halen en beste matches te vinden
voor de nieuwe scenarios
"""
import os
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()

supabase = create_client(
    os.getenv("SUPABASE_URL"),
    os.getenv("SERVICE_ROLE_KEY")
)

print("=" * 80)
print("BESTAANDE PERSONEN (Verdachten)")
print("=" * 80)
personen = supabase.table('personen').select('*').execute()
for p in personen.data:
    print(f"ID {p['id']:3} | {p['naam']:40} | NFC: {p['nfc_code']}")
    if p.get('beschrijving'):
        print(f"       {p['beschrijving'][:120]}")
    print()

print("\n" + "=" * 80)
print("BESTAANDE WAPENS (Power BI Horrors)")
print("=" * 80)
wapens = supabase.table('wapens').select('*').execute()
for w in wapens.data:
    print(f"ID {w['id']:3} | {w['naam']}")
    if w.get('beschrijving'):
        print(f"       {w['beschrijving'][:120]}")
    if w.get('technische_uitleg'):
        print(f"       Tech: {w['technische_uitleg'][:100]}...")
    print()

print("\n" + "=" * 80)
print("BESTAANDE LOCATIES")
print("=" * 80)
locaties = supabase.table('locaties').select('*').execute()
for l in locaties.data:
    print(f"ID {l['id']:3} | {l['naam']} | NFC: {l['nfc_code']}")
    if l.get('beschrijving'):
        print(f"       {l['beschrijving'][:100]}")
    print()

print("\n" + "=" * 80)
print("SUGGESTIES VOOR NIEUWE SCENARIOS")
print("=" * 80)

print("\n1. 'De Persoonlijke Filter' (Hidden slicer blijft actief)")
print("   → Business user met edit rechten vergeet hidden slicer uit te zetten")
print("   BESTE MATCH:")
# Zoek business/controller/finance persoon
fc_personen = [p for p in personen.data if any(x in p['naam'].lower() for x in ['controller', 'finance', 'fc'])]
if fc_personen:
    print(f"   Dader: ID {fc_personen[0]['id']} - {fc_personen[0]['naam']}")
else:
    print(f"   Dader: Kies business user met edit rechten")

# Zoek slicer/filter wapen
slicer_wapens = [w for w in wapens.data if any(x in w['naam'].lower() for x in ['slicer', 'filter', 'visual'])]
if slicer_wapens:
    print(f"   Wapen: ID {slicer_wapens[0]['id']} - {slicer_wapens[0]['naam']}")
else:
    print(f"   Wapen: Kies visual/filter gerelateerd wapen")

print("\n2. 'De Onzichtbare Duplicaten' (Many-to-many relatie)")
print("   → Developer klikt waarschuwing weg, sales x3 door duplicate dimension")
print("   BESTE MATCH:")
# Zoek developer/analist
dev_personen = [p for p in personen.data if any(x in p['naam'].lower() for x in ['developer', 'analist', 'dev'])]
if dev_personen:
    print(f"   Dader: ID {dev_personen[0]['id']} - {dev_personen[0]['naam']}")
else:
    print(f"   Dader: Kies technische persoon (developer/analist)")

# Zoek data model/relationship wapen
duplicate_wapens = [w for w in wapens.data if any(x in w['naam'].lower() for x in ['duplicate', 'relationship', 'dimension', 'model'])]
if duplicate_wapens:
    print(f"   Wapen: ID {duplicate_wapens[0]['id']} - {duplicate_wapens[0]['naam']}")
else:
    print(f"   Wapen: Kies data model/relationship wapen")

print("\n3. 'De Stille ETL' (Database niet geupdate)")
print("   → ETL job faalt silent door filename mismatch, nobody notices voor maanden")
print("   BESTE MATCH:")
# Zoek database/IT persoon
db_personen = [p for p in personen.data if any(x in p['naam'].lower() for x in ['database', 'admin', 'it', 'dba'])]
if db_personen:
    print(f"   Dader: ID {db_personen[0]['id']} - {db_personen[0]['naam']}")
else:
    print(f"   Dader: Kies IT/database admin")

# Zoek database/stale data wapen
stale_wapens = [w for w in wapens.data if any(x in w['naam'].lower() for x in ['stale', 'database', 'connection', 'oude', 'verouderd'])]
if stale_wapens:
    print(f"   Wapen: ID {stale_wapens[0]['id']} - {stale_wapens[0]['naam']}")
else:
    print(f"   Wapen: Kies database/connection wapen")

print("\n" + "=" * 80)
