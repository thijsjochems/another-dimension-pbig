import os
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()
url = os.getenv("SUPABASE_URL")
key = os.getenv("SUPABASE_SERVICE_ROLE_KEY") or os.getenv("SERVICE_ROLE_KEY")
if not url or not key:
    raise SystemExit("SUPABASE_URL or SERVICE_ROLE_KEY missing")

client = create_client(url, key)

with open("SQL/add_clue_state_and_phased_hints.sql", "r", encoding="utf-8") as f:
    sql = f.read()

print("Executing migration via rpc('exec_sql')...")
response = client.rpc("exec_sql", {"query": sql}).execute()
print("Done.")
print(response.data)
