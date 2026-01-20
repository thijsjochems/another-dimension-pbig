"""
Execute SQL via Supabase Management API
This uses the official Supabase Platform API to run SQL
"""

import os
import sys
import requests
from dotenv import load_dotenv

load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL")
SERVICE_ROLE_KEY = os.getenv("SERVICE_ROLE_KEY")
PROJECT_ID = "eiynfrgezfyncoqaemfr"

# Read SQL
with open("SQL/migration_multi_nfc_support.sql", 'r', encoding='utf-8') as f:
    sql = f.read()

print("🚀 Executing SQL via Supabase Management API")
print("=" * 60)

# Split into statements
statements = [s.strip() for s in sql.split(';') if s.strip() and not s.strip().startswith('--')]

print(f"📋 {len(statements)} statements to execute\n")

# Use the SQL editor endpoint directly via PostgREST
# Supabase exposes a query endpoint we can use
headers = {
    "apikey": SERVICE_ROLE_KEY,
    "Authorization": f"Bearer {SERVICE_ROLE_KEY}",
    "Content-Type": "application/json"
}

success = 0
failed = 0

for i, stmt in enumerate(statements, 1):
    if stmt.upper().startswith('SELECT'):
        print(f"{i}. Skipping SELECT verification...")
        continue
        
    print(f"{i}. Executing {stmt[:50]}...")
    
    # Try using the SQL REST endpoint
    url = f"{SUPABASE_URL}/rest/v1/rpc/query"
    
    try:
        response = requests.post(
            url,
            headers=headers,
            json={"query": stmt}
        )
        
        if response.status_code in [200, 201, 204]:
            print(f"   ✅")
            success += 1
        else:
            # Try alternative: use pg_stat_statements or direct postgres wire protocol
            # Since REST doesn't work, let's use psycopg2 with the correct connection string
            print(f"   ⚠️ REST failed, trying psycopg2...")
            
            import psycopg2
            
            # Try different hostname formats
            hosts_to_try = [
                f"db.{PROJECT_ID}.supabase.co",
                f"{PROJECT_ID}.supabase.co",
                f"aws-0-eu-central-1.pooler.supabase.com"
            ]
            
            for host in hosts_to_try:
                try:
                    conn = psycopg2.connect(
                        host=host,
                        port=5432 if 'db.' in host else 6543,
                        dbname="postgres",
                        user="postgres" if 'db.' in host else f"postgres.{PROJECT_ID}",
                        password=SERVICE_ROLE_KEY,
                        connect_timeout=3
                    )
                    
                    cur = conn.cursor()
                    cur.execute(stmt)
                    conn.commit()
                    cur.close()
                    conn.close()
                    
                    print(f"   ✅ Success via {host}")
                    success += 1
                    break
                    
                except Exception as e:
                    if host == hosts_to_try[-1]:
                        print(f"   ❌ All hosts failed")
                        failed += 1
                    continue
                    
    except Exception as e:
        print(f"   ❌ {str(e)[:80]}")
        failed += 1

print("\n" + "=" * 60)
print(f"✅ Success: {success}")
print(f"❌ Failed: {failed}")

if failed > 0:
    print("\n💡 Trying PostgreSQL with alternative connection...")
    import subprocess
    
    # Get the actual database password from Supabase settings
    print("\n🔍 Need actual database password (not service role key)")
    print("   Service role key != database password for direct postgres connection")
    print(f"\n   Get it from: https://supabase.com/dashboard/project/{PROJECT_ID}/settings/database")
    print("   Look for 'Database Password' and add to .env as DB_PASSWORD")
