"""
Execute SQL via Supabase Management API
Uses the /sql endpoint that can run DDL statements
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

# Supabase Management API endpoint
# https://supabase.com/docs/reference/api/introduction
management_api_url = f"https://api.supabase.com/v1/projects/{PROJECT_ID}/database/query"

headers = {
    "Authorization": f"Bearer {SERVICE_ROLE_KEY}",
    "Content-Type": "application/json",
    "apikey": SERVICE_ROLE_KEY
}

# Try executing the full SQL
payload = {
    "query": sql
}

print(f"📤 Sending SQL to Management API...\n")

try:
    response = requests.post(management_api_url, headers=headers, json=payload)
    
    print(f"Status: {response.status_code}")
    print(f"Response: {response.text[:500]}")
    
    if response.status_code in [200, 201]:
        print("\n✅ Migration executed successfully!")
        print("\n📊 Verifying...")
        os.system("python run_migration.py --verify")
    else:
        print("\n❌ Failed via Management API")
        print("\n💡 Trying alternative: Split into individual statements...")
        
        # Split and try one by one
        statements = [s.strip() for s in sql.split(';') if s.strip() and not s.strip().startswith('--')]
        
        success = 0
        failed = 0
        
        for i, stmt in enumerate(statements, 1):
            if stmt.upper().startswith('SELECT'):
                continue
            
            print(f"\n{i}. {stmt[:60]}...")
            
            payload = {"query": stmt + ";"}
            resp = requests.post(management_api_url, headers=headers, json=payload)
            
            if resp.status_code in [200, 201]:
                print(f"   ✅")
                success += 1
            else:
                print(f"   ❌ {resp.text[:100]}")
                failed += 1
        
        print(f"\n✅ Success: {success}")
        print(f"❌ Failed: {failed}")
        
except Exception as e:
    print(f"❌ Error: {str(e)}")
    print("\n💡 Fallback: Use SQL Editor in Supabase dashboard")
