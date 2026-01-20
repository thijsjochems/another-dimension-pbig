"""
Update SCOREBOARD NFC code with real scanned value
"""
from db_helper import supabase

def update_scoreboard_nfc():
    """Update SCOREBOARD token with real NFC code"""
    
    real_code = '2078239492'
    
    try:
        # Get current SCOREBOARD record
        result = supabase.table('special_nfc_codes').select('*').eq('code_type', 'SCOREBOARD').execute()
        
        if not result.data:
            print("❌ SCOREBOARD token niet gevonden")
            return
        
        current = result.data[0]
        print(f"📋 Huidige SCOREBOARD data:")
        print(f"   nfc_code: {current.get('nfc_code')}")
        print(f"   nfc_codes: {current.get('nfc_codes')}")
        
        # Update with real code
        update_data = {
            'nfc_code': real_code,
            'nfc_codes': [real_code]  # Replace array with real code
        }
        
        result = supabase.table('special_nfc_codes').update(update_data).eq('code_type', 'SCOREBOARD').execute()
        
        print(f"\n✅ SCOREBOARD NFC code updated!")
        print(f"   Nieuwe code: {real_code}")
        print(f"   Array: {update_data['nfc_codes']}")
        
    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == '__main__':
    update_scoreboard_nfc()
