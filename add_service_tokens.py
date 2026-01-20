"""
Add service NFC tokens to special_nfc_codes table
Voor homepage service knoppen
"""
from db_helper import supabase

def add_service_tokens():
    """Add NFC tokens voor alle homepage services"""
    
    services = [
        {
            'code_type': 'AI_AUTOMATION',
            'description': 'AI Automation service info',
            'nfc_code': 'TEMP_NFC_AI_AUTOMATION',
            'nfc_codes': ['TEMP_NFC_AI_AUTOMATION']
        },
        {
            'code_type': 'AI_TRAINING',
            'description': 'AI Training service info',
            'nfc_code': 'TEMP_NFC_AI_TRAINING',
            'nfc_codes': ['TEMP_NFC_AI_TRAINING']
        },
        {
            'code_type': 'POWERBI_PORTFOLIO',
            'description': 'Power BI Portfolio service info',
            'nfc_code': 'TEMP_NFC_POWERBI_PORTFOLIO',
            'nfc_codes': ['TEMP_NFC_POWERBI_PORTFOLIO']
        },
        {
            'code_type': 'POWERBI_TRAINING',
            'description': 'Power BI Training service info',
            'nfc_code': 'TEMP_NFC_POWERBI_TRAINING',
            'nfc_codes': ['TEMP_NFC_POWERBI_TRAINING']
        }
    ]
    
    for service in services:
        try:
            result = supabase.table('special_nfc_codes').insert(service).execute()
            print(f"✅ {service['code_type']} token toegevoegd")
            print(f"   TEMP code: {service['nfc_code']}")
        except Exception as e:
            if 'duplicate key' in str(e).lower():
                print(f"ℹ️  {service['code_type']} token bestaat al")
            else:
                print(f"❌ Error voor {service['code_type']}: {e}")
    
    print("\n📋 Alle service tokens:")
    result = supabase.table('special_nfc_codes').select('*').execute()
    for item in result.data:
        print(f"   - {item['code_type']}: {item.get('nfc_code', 'N/A')}")

if __name__ == '__main__':
    add_service_tokens()
