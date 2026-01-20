"""
Execute SQL migration via Supabase REST API
Uses the PostgREST /rpc endpoint to execute SQL statements
"""

import os
import sys
from dotenv import load_dotenv
import requests
import json

# Load environment variables
load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL")  # https://eiynfrgezfyncoqaemfr.supabase.co
SERVICE_ROLE_KEY = os.getenv("SERVICE_ROLE_KEY")

if not SUPABASE_URL or not SERVICE_ROLE_KEY:
    print("❌ SUPABASE_URL or SERVICE_ROLE_KEY not found in .env")
    sys.exit(1)

# Read SQL migration file
sql_file = "SQL/migration_multi_nfc_support.sql"
try:
    with open(sql_file, 'r', encoding='utf-8') as f:
        migration_sql = f.read()
except FileNotFoundError:
    print(f"❌ Migration file not found: {sql_file}")
    sys.exit(1)

print("📄 Migration SQL loaded")
print(f"   File: {sql_file}")
print(f"   Size: {len(migration_sql)} characters\n")

# Split SQL into individual statements
statements = [s.strip() for s in migration_sql.split(';') if s.strip() and not s.strip().startswith('--')]
print(f"📋 Found {len(statements)} SQL statements\n")

# Execute via Supabase REST API
# Note: We'll need to execute each statement individually
print("🔧 Executing SQL via Supabase API...")
print("=" * 60)

headers = {
    "apikey": SERVICE_ROLE_KEY,
    "Authorization": f"Bearer {SERVICE_ROLE_KEY}",
    "Content-Type": "application/json",
    "Prefer": "return=minimal"
}

# Try executing via direct query (if schema allows)
# This uses the pg_catalog.pg_exec_sql function if available
success_count = 0
error_count = 0

for i, statement in enumerate(statements, 1):
    print(f"\n{i}. Executing statement (length: {len(statement)})...")
    
    # Try using SQL editor endpoint
    # Supabase typically exposes a /rest/v1/rpc/exec_sql endpoint
    url = f"{SUPABASE_URL}/rest/v1/rpc/exec_sql"
    
    payload = {
        "query": statement
    }
    
    try:
        response = requests.post(url, headers=headers, json=payload)
        
        if response.status_code in [200, 201, 204]:
            print(f"   ✅ Success")
            success_count += 1
        else:
            print(f"   ❌ Failed: {response.status_code}")
            print(f"   Response: {response.text[:200]}")
            error_count += 1
            
    except Exception as e:
        print(f"   ❌ Error: {str(e)}")
        error_count += 1

print("\n" + "=" * 60)
print(f"\n📊 Migration Results:")
print(f"   ✅ Successful: {success_count}")
print(f"   ❌ Failed: {error_count}")

if error_count == len(statements):
    print("\n⚠️  All statements failed via REST API.")
    print("\n💡 Alternative: Manual execution required")
    print(f"   1. Go to: https://supabase.com/dashboard/project/{SUPABASE_URL.split('//')[1].split('.')[0]}/sql/new")
    print(f"   2. Copy-paste content from: {sql_file}")
    print(f"   3. Click 'Run' to execute migration")
    print(f"\n   Then verify with: python run_migration.py --verify")
elif error_count > 0:
    print("\n⚠️  Some statements failed. Please check errors above.")
else:
    print("\n🎉 Migration completed successfully!")
    print("\nVerifying migration...")
    os.system("python run_migration.py --verify")
