"""
Add SCOREBOARD NFC token to special_nfc_codes table
"""
from db_helper import supabase

def add_scoreboard_token():
    """Add SCOREBOARD token with TEMP code for scanning"""
    
    # Insert SCOREBOARD token
    data = {
        'code_type': 'SCOREBOARD',
        'description': 'Navigeer naar het scorebord',
        'nfc_code': 'TEMP_NFC_SCOREBOARD',  # Required field
        'nfc_codes': ['TEMP_NFC_SCOREBOARD']  # Array for multiple codes
    }
    
    try:
        result = supabase.table('special_nfc_codes').insert(data).execute()
        print("✅ SCOREBOARD token toegevoegd!")
        print(f"   Code type: SCOREBOARD")
        print(f"   TEMP code: TEMP_NFC_SCOREBOARD")
        print(f"   Beschrijving: {data['description']}")
        print("\n🔍 Gebruik scanner.py om een echte NFC code te scannen")
        return result.data[0] if result.data else None
        
    except Exception as e:
        if 'duplicate key' in str(e).lower():
            print("ℹ️  SCOREBOARD token bestaat al")
            # Get existing record
            result = supabase.table('special_nfc_codes').select('*').eq('code_type', 'SCOREBOARD').execute()
            if result.data:
                print(f"   TEMP code: {result.data[0].get('nfc_codes', [])}")
            return result.data[0] if result.data else None
        else:
            print(f"❌ Error: {e}")
            return None

if __name__ == '__main__':
    add_scoreboard_token()
