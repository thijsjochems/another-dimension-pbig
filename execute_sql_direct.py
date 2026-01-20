"""
Execute SQL migration via Supabase Python client using raw SQL execution
"""

import os
import sys
from dotenv import load_dotenv
from supabase import create_client, Client

# Load environment variables
load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL")
SERVICE_ROLE_KEY = os.getenv("SERVICE_ROLE_KEY")

if not SUPABASE_URL or not SERVICE_ROLE_KEY:
    print("❌ SUPABASE_URL or SERVICE_ROLE_KEY not found in .env")
    sys.exit(1)

# Create Supabase client with service role key (admin access)
supabase: Client = create_client(SUPABASE_URL, SERVICE_ROLE_KEY)

# Read SQL migration file
sql_file = "SQL/migration_multi_nfc_support.sql"
try:
    with open(sql_file, 'r', encoding='utf-8') as f:
        migration_sql = f.read()
except FileNotFoundError:
    print(f"❌ Migration file not found: {sql_file}")
    sys.exit(1)

print("📄 SQL Migration loaded")
print(f"   File: {sql_file}")
print(f"   Size: {len(migration_sql)} characters\n")

# Split into individual statements for execution
statements = []
for line in migration_sql.split('\n'):
    line = line.strip()
    if line and not line.startswith('--'):
        statements.append(line)

full_sql = ' '.join(statements)

# Split by semicolon but keep statements together
sql_statements = [s.strip() + ';' for s in full_sql.split(';') if s.strip()]

print(f"📋 Found {len(sql_statements)} SQL statements\n")
print("🔧 Executing SQL migration...")
print("=" * 60)

success_count = 0
error_count = 0

# Execute each statement
for i, statement in enumerate(sql_statements, 1):
    # Skip SELECT verification queries (we'll run those manually after)
    if statement.strip().upper().startswith('SELECT'):
        print(f"{i}. Skipping verification query...")
        continue
    
    print(f"\n{i}. Executing: {statement[:80]}...")
    
    try:
        # Use PostgREST SQL function if available, or try direct table operations
        # For ALTER TABLE and CREATE INDEX, we need to use the underlying PostgreSQL connection
        
        # Try using supabase.postgrest.session for raw SQL
        # This might not work, but let's try
        response = supabase.table('_internal').select('*').execute()
        
        print(f"   ⚠️  Cannot execute DDL via Python client")
        print(f"   Statement: {statement[:100]}")
        error_count += 1
        
    except Exception as e:
        print(f"   ⚠️  Error: {str(e)[:100]}")
        error_count += 1

print("\n" + "=" * 60)
print("\n⚠️  The Supabase Python client cannot execute DDL statements")
print("   (ALTER TABLE, CREATE INDEX, etc.)")
print("\n💡 Using alternative method: Supabase CLI")

# Try using supabase CLI
print("\n🔧 Attempting via Supabase CLI...")
import subprocess

try:
    # Create temporary SQL file without verification queries
    temp_sql = '\n'.join([s for s in sql_statements if not s.strip().upper().startswith('SELECT')])
    
    with open('temp_migration.sql', 'w', encoding='utf-8') as f:
        f.write(temp_sql)
    
    # Execute via supabase db execute
    result = subprocess.run(
        ['supabase', 'db', 'execute', '--db-url', 
         f"postgresql://postgres:{SERVICE_ROLE_KEY}@db.eiynfrgezfyncoqaemfr.supabase.co:5432/postgres",
         temp_sql],
        capture_output=True,
        text=True,
        input=temp_sql
    )
    
    if result.returncode == 0:
        print("✅ Migration executed successfully via CLI!")
        print(result.stdout)
        
        # Cleanup
        os.remove('temp_migration.sql')
        
        # Verify
        print("\n📊 Verifying migration...")
        os.system("python run_migration.py --verify")
    else:
        print(f"❌ CLI execution failed: {result.stderr}")
        print(f"\n💡 Manual execution required:")
        print(f"   1. Go to: https://supabase.com/dashboard/project/eiynfrgezfyncoqaemfr/sql/new")
        print(f"   2. Copy-paste content from: {sql_file}")
        print(f"   3. Click 'Run'")
        
except Exception as e:
    print(f"❌ CLI not available: {str(e)}")
    print(f"\n💡 Manual execution required:")
    print(f"   1. Go to: https://supabase.com/dashboard/project/eiynfrgezfyncoqaemfr/sql/new")
    print(f"   2. Copy-paste content from: {sql_file}")
    print(f"   3. Click 'Run'")
