"""Check agents in database"""
import os
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()

supabase = create_client(
    os.getenv("SUPABASE_URL"),
    os.getenv("SERVICE_ROLE_KEY")
)

result = supabase.table('agents').select('*').execute()

print("=" * 80)
print("AGENTS MET TONE OF VOICE")
print("=" * 80)
for a in result.data:
    print(f"\nID {a['id']} | {a['naam']}")
    print(f"NFC: {a['nfc_code']}")
    if a.get('achtergrond'):
        print(f"\nAchtergrond:")
        print(f"  {a['achtergrond'][:200]}...")
    if a.get('tone_of_voice'):
        print(f"\nTone of Voice:")
        print(f"  {a['tone_of_voice'][:200]}...")
    print("-" * 80)
