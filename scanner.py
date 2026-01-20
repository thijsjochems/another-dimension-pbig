import sys
import os
from dotenv import load_dotenv
from supabase import create_client

# Load environment
load_dotenv()
SUPABASE_URL = os.getenv("SUPABASE_URL")
SERVICE_ROLE_KEY = os.getenv("SERVICE_ROLE_KEY")
supabase = create_client(SUPABASE_URL, SERVICE_ROLE_KEY)

def list_items(table_name):
    """Toon alle items uit een tabel"""
    result = supabase.table(table_name).select('id, naam, nfc_code, nfc_codes').execute()
    print(f"\n📋 {table_name.upper()}:")
    for item in result.data:
        codes = item.get('nfc_codes', [])
        print(f"   [{item['id']}] {item['naam']}: {item['nfc_code']} | Array: {codes}")
    print()

def check_code_exists_globally(nfc_code):
    """Check of een NFC code al ergens in de database bestaat"""
    tables = ['personen', 'wapens', 'locaties', 'agents', 'special_nfc_codes']
    
    for table in tables:
        # Check in nfc_codes array
        if table == 'special_nfc_codes':
            result = supabase.table(table).select('id, code_type, nfc_codes').execute()
        else:
            result = supabase.table(table).select('id, naam, nfc_codes').execute()
        
        for item in result.data:
            codes = item.get('nfc_codes', [])
            if nfc_code in codes:
                naam = item.get('naam') or item.get('code_type', 'Unknown')
                return True, table, naam
    
    return False, None, None

def update_nfc_code(table_name, item_id, nfc_code):
    """Voeg NFC code toe aan array (met duplicate check over ALLE tabellen)"""
    
    # STAP 1: Check of code al ergens anders bestaat
    exists, existing_table, existing_name = check_code_exists_globally(nfc_code)
    
    if exists:
        print(f"🚨 DUPLICATE DETECTED!")
        print(f"   Code {nfc_code} is al toegewezen aan:")
        print(f"   → {existing_name} (in {existing_table})")
        print(f"   ❌ Kan niet opnieuw worden gebruikt!")
        return False
    
    # STAP 2: Haal huidige record op
    result = supabase.table(table_name).select('*').eq('id', item_id).execute()
    
    if not result.data:
        print(f"❌ ID {item_id} niet gevonden in {table_name}")
        return False
    
    record = result.data[0]
    current_codes = record.get('nfc_codes', [])
    naam = record.get('naam') or record.get('code_type', 'Unknown')
    
    # STAP 3: Check of code al in dit specifieke item zit
    if nfc_code in current_codes:
        print(f"⚠️  Code {nfc_code} bestaat al voor {naam}")
        return False
    
    # STAP 4: Voeg toe aan array
    current_codes.append(nfc_code)
    
    # STAP 5: Update beide kolommen
    supabase.table(table_name).update({
        'nfc_code': nfc_code,  # Primary code (laatste toegevoegd)
        'nfc_codes': current_codes
    }).eq('id', item_id).execute()
    
    print(f"✅ Code {nfc_code} toegevoegd aan {naam}")
    print(f"   Totaal codes voor dit item: {len(current_codes)}")
    return True

def get_items_to_scan():
    """Haal alle items op die nog TEMP_NFC codes hebben"""
    all_items = []
    
    tables = [
        ('personen', 'PERSOON'),
        ('wapens', 'WAPEN'),
        ('locaties', 'LOCATIE'),
        ('agents', 'AGENT'),
        ('special_nfc_codes', 'SPECIAL')
    ]
    
    for table_name, type_name in tables:
        if table_name == 'special_nfc_codes':
            result = supabase.table(table_name).select('id, code_type, nfc_code').execute()
        else:
            result = supabase.table(table_name).select('id, naam, nfc_code').execute()
        
        for item in result.data:
            if item['nfc_code'].startswith('TEMP_NFC'):
                naam = item.get('naam') or item.get('code_type', 'Unknown')
                all_items.append({
                    'table': table_name,
                    'type': type_name,
                    'id': item['id'],
                    'naam': naam,
                    'current_code': item['nfc_code']
                })
    
    return all_items

def main():
    print("=" * 70)
    print("   🔍 NFC SCANNER - AUTOMATISCHE WORKFLOW")
    print("=" * 70)
    print("Scan alle items één voor één\n")
    
    # Haal alle items op die gescand moeten worden
    items_to_scan = get_items_to_scan()
    
    if not items_to_scan:
        print("✅ Alle items hebben al echte NFC codes!")
        print("   Niets te scannen.")
        return
    
    print(f"📋 {len(items_to_scan)} items te scannen\n")
    print("Commands tijdens scannen:")
    print("  - 'skip' → sla dit item over")
    print("  - 'list' → toon resterende items")
    print("  - 'quit' → stop scanner")
    print("  - CTRL+C → stop scanner\n")
    print("=" * 70)

    try:
        scanned_count = 0
        skipped_items = []
        
        for i, item in enumerate(items_to_scan, 1):
            print(f"\n📍 ITEM {i}/{len(items_to_scan)}")
            print(f"   Type: {item['type']}")
            print(f"   Naam: {item['naam']}")
            print(f"   Huidige code: {item['current_code']}")
            print("-" * 70)
            
            nfc_code = input(f">> SCAN NFC TAG voor '{item['naam']}': ").strip()
            
            if not nfc_code:
                print("⚠️  Geen code gescand, item overgeslagen")
                skipped_items.append(item)
                continue
            
            if nfc_code.lower() == 'skip':
                print("⏭️  Item overgeslagen")
                skipped_items.append(item)
                continue
            
            if nfc_code.lower() == 'list':
                print("\n📋 Resterende items:")
                for j, remaining in enumerate(items_to_scan[i-1:], i):
                    print(f"   {j}. {remaining['naam']} ({remaining['type']})")
                print()
                # Scan dit item opnieuw
                nfc_code = input(f">> SCAN NFC TAG voor '{item['naam']}': ").strip()
                if not nfc_code or nfc_code.lower() == 'skip':
                    skipped_items.append(item)
                    continue
            
            if nfc_code.lower() == 'quit':
                print("\n⏸️  Scanner gestopt door gebruiker")
                break
            
            # Probeer code toe te voegen
            print(f"\n🔍 Gescande code: {nfc_code}")
            success = update_nfc_code(item['table'], item['id'], nfc_code)
            
            if success:
                scanned_count += 1
            else:
                print("⚠️  Item niet bijgewerkt, probeer opnieuw of typ 'skip'")
                retry = input(f">> Opnieuw scannen voor '{item['naam']}'? (scan/skip): ").strip()
                if retry.lower() != 'skip' and retry:
                    success = update_nfc_code(item['table'], item['id'], retry)
                    if success:
                        scanned_count += 1
                    else:
                        skipped_items.append(item)
                else:
                    skipped_items.append(item)
        
        # Samenvatting
        print("\n" + "=" * 70)
        print("📊 SCAN SESSIE SAMENVATTING")
        print("=" * 70)
        print(f"✅ Gescand: {scanned_count} items")
        print(f"⏭️  Overgeslagen: {len(skipped_items)} items")
        
        if skipped_items:
            print("\n⚠️  Overgeslagen items:")
            for item in skipped_items:
                print(f"   - {item['naam']} ({item['type']})")
            print("\n💡 Start scanner opnieuw om deze items te scannen")
        
        print("\n✅ Scanner gestopt!")
                
    except KeyboardInterrupt:
        print("\n\n✅ Scanner gestopt (CTRL+C)")
        sys.exit()

if __name__ == "__main__":
    main()