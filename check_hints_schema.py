from supabase import create_client
import os
from dotenv import load_dotenv

load_dotenv()
client = create_client(os.getenv('SUPABASE_URL'), os.getenv('SUPABASE_KEY'))

# Check schema
result = client.table('scenario_hints').select('*').limit(1).execute()
if result.data:
    print('Kolommen:', result.data[0].keys())
else:
    print('Geen data, maar tabel bestaat')
