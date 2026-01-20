"""
Execute SQL migration with actual database password
"""

import os
import sys
from dotenv import load_dotenv
import psycopg2

load_dotenv()

DB_PASSWORD = os.getenv("DB_PASSWORD")
PROJECT_ID = "eiynfrgezfyncoqaemfr"

if not DB_PASSWORD:
    print("❌ DB_PASSWORD not found in .env")
    sys.exit(1)

# Read SQL
with open("SQL/migration_multi_nfc_support.sql", 'r', encoding='utf-8') as f:
    sql = f.read()

# Split into statements
statements = [s.strip() for s in sql.split(';') if s.strip() and not s.strip().startswith('--')]

print("🚀 Executing SQL Migration with Database Password")
print("=" * 60)
print(f"📋 {len(statements)} statements\n")

# Try connection with actual database password
hosts = [
    ("db.eiynfrgezfyncoqaemfr.supabase.co", 5432, "postgres"),
    ("aws-0-eu-central-1.pooler.supabase.com", 6543, f"postgres.{PROJECT_ID}"),
    ("aws-0-eu-central-1.pooler.supabase.com", 5432, "postgres"),
]

conn = None
for host, port, user in hosts:
    try:
        print(f"🔌 Trying {host}:{port}...")
        conn = psycopg2.connect(
            host=host,
            port=port,
            dbname="postgres",
            user=user,
            password=DB_PASSWORD,
            connect_timeout=5
        )
        print(f"   ✅ Connected!\n")
        break
    except Exception as e:
        print(f"   ❌ {str(e)[:80]}")
        continue

if not conn:
    print("\n❌ All connection attempts failed")
    print("💡 The hostname may be region-specific")
    print("   Check the connection string in Supabase dashboard")
    sys.exit(1)

# Execute statements
cur = conn.cursor()
success = 0
failed = 0

for i, stmt in enumerate(statements, 1):
    if stmt.upper().startswith('SELECT'):
        print(f"{i}. Skipping SELECT verification...")
        continue
    
    print(f"{i}. Executing: {stmt[:60]}...")
    
    try:
        cur.execute(stmt)
        conn.commit()
        print(f"   ✅")
        success += 1
    except Exception as e:
        error_msg = str(e)[:100]
        if "already exists" in error_msg or "duplicate" in error_msg.lower():
            print(f"   ⚠️  Already exists (OK)")
            success += 1
        else:
            print(f"   ❌ {error_msg}")
            failed += 1

cur.close()
conn.close()

print("\n" + "=" * 60)
print(f"✅ Success: {success}")
print(f"❌ Failed: {failed}")

if failed == 0:
    print("\n🎉 Migration completed successfully!")
    print("\n📊 Verifying...")
    os.system("python run_migration.py --verify")
