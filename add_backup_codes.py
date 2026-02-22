"""
Interactieve scanner voor het toevoegen van backup NFC codes aan bestaande items
"""
import os
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()
SUPABASE_URL = os.getenv("SUPABASE_URL")
SERVICE_ROLE_KEY = os.getenv("SERVICE_ROLE_KEY")
supabase = create_client(SUPABASE_URL, SERVICE_ROLE_KEY)

def check_code_exists_globally(nfc_code):
    """Check of een NFC code al ergens in de database bestaat"""
    tables = ['personen', 'wapens', 'locaties', 'agents', 'special_nfc_codes']
    
    for table in tables:
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

def add_backup_code(table_name, item_id, nfc_code):
    """Voeg backup NFC code toe aan bestaand item"""
    
    # Check duplicate
    exists, existing_table, existing_name = check_code_exists_globally(nfc_code)
    
    if exists:
        print(f"   🚨 DUPLICATE! Code {nfc_code} bestaat al voor:")
        print(f"      → {existing_name} (in {existing_table})")
        print(f"      ❌ Kan niet opnieuw worden gebruikt!")
        return False
    
    # Haal huidige record op
    result = supabase.table(table_name).select('*').eq('id', item_id).execute()
    
    if not result.data:
        print(f"   ❌ ID {item_id} niet gevonden in {table_name}")
        return False
    
    record = result.data[0]
    current_codes = record.get('nfc_codes', [])
    naam = record.get('naam') or record.get('code_type', 'Unknown')
    
    # Check of code al in dit item zit
    if nfc_code in current_codes:
        print(f"   ⚠️  Code {nfc_code} bestaat al voor {naam}")
        return False
    
    # Voeg toe
    current_codes.append(nfc_code)
    
    # Update (houdt oude nfc_code, voegt alleen toe aan array)
    supabase.table(table_name).update({
        'nfc_codes': current_codes
    }).eq('id', item_id).execute()
    
    print(f"   ✅ Backup code toegevoegd aan {naam}")
    print(f"      Totaal codes: {len(current_codes)}")
    return True

def list_items(table_name, type_label):
    """Toon alle items in een tabel"""
    if table_name == 'special_nfc_codes':
        result = supabase.table(table_name).select('id, code_type, nfc_codes').order('id').execute()
    else:
        result = supabase.table(table_name).select('id, naam, nfc_codes').order('id').execute()
    
    print(f"\n🔹 {type_label}:")
    for item in result.data:
        naam = item.get('naam') or item.get('code_type', 'Unknown')
        codes_count = len(item.get('nfc_codes', []))
        print(f"   [{item['id']:2d}] {naam:45s} ({codes_count} codes)")
    
    return result.data

def main():
    print("=" * 80)
    print("   🔖 BACKUP NFC CODE SCANNER")
    print("=" * 80)
    print("Voeg nieuwe backup codes toe aan bestaande items\n")
    print("Commands:")
    print("  - Type '1' voor PERSONEN")
    print("  - Type '2' voor WAPENS")
    print("  - Type '3' voor LOCATIES")
    print("  - Type '4' voor SPECIAL CODES")
    print("  - Type 'quit' om te stoppen\n")
    print("=" * 80)
    
    types = {
        '1': ('personen', 'PERSONEN'),
        '2': ('wapens', 'WAPENS'),
        '3': ('locaties', 'LOCATIES'),
        '4': ('special_nfc_codes', 'SPECIAL CODES')
    }
    
    scanned_count = 0
    
    try:
        while True:
            print("\n" + "-" * 80)
            category = input("\n>> Selecteer categorie (1-4) of 'quit': ").strip()
            
            if category.lower() == 'quit':
                break
            
            if category not in types:
                print("⚠️  Ongeldige keuze. Kies 1, 2, 3 of 4.")
                continue
            
            table_name, type_label = types[category]
            
            # Toon items
            items = list_items(table_name, type_label)
            
            # Vraag welk item
            item_id_input = input(f"\n>> Selecteer ID (of 'back'): ").strip()
            
            if item_id_input.lower() == 'back':
                continue
            
            try:
                item_id = int(item_id_input)
            except ValueError:
                print("⚠️  Ongeldig ID")
                continue
            
            # Check of ID bestaat
            item = next((i for i in items if i['id'] == item_id), None)
            if not item:
                print(f"⚠️  ID {item_id} niet gevonden")
                continue
            
            naam = item.get('naam') or item.get('code_type', 'Unknown')
            
            # Scan nieuwe code
            print(f"\n📍 Geselecteerd: {naam}")
            print(f"   Huidige codes: {len(item.get('nfc_codes', []))}")
            
            nfc_code = input(f"\n>> SCAN nieuwe NFC TAG voor '{naam}': ").strip()
            
            if not nfc_code:
                print("⚠️  Geen code gescand, overgeslagen")
                continue
            
            if nfc_code.lower() == 'skip':
                print("⏭️  Overgeslagen")
                continue
            
            # Voeg toe
            print(f"\n🔍 Gescande code: {nfc_code}")
            success = add_backup_code(table_name, item_id, nfc_code)
            
            if success:
                scanned_count += 1
        
        print("\n" + "=" * 80)
        print("📊 SAMENVATTING")
        print("=" * 80)
        print(f"✅ Backup codes toegevoegd: {scanned_count}")
        print("\n✅ Scanner gestopt!")
        
    except KeyboardInterrupt:
        print("\n\n✅ Scanner gestopt (CTRL+C)")

if __name__ == "__main__":
    main()
