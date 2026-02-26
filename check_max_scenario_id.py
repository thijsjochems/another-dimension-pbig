"""Check highest scenario ID in database"""
import os
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()

supabase = create_client(
    os.getenv("SUPABASE_URL"),
    os.getenv("SERVICE_ROLE_KEY")
)

# Check max scenario ID
result = supabase.table('scenarios').select('id, naam').order('id', desc=True).limit(10).execute()

print("=" * 80)
print("LAATSTE 10 SCENARIOS IN DATABASE")
print("=" * 80)
for s in result.data:
    print(f"ID {s['id']:3} | {s['naam']}")

if result.data:
    max_id = result.data[0]['id']
    print(f"\n→ Hoogste ID in database: {max_id}")
    print(f"→ Nieuwe scenarios krijgen automatisch ID: {max_id + 1}, {max_id + 2}, {max_id + 3}")
