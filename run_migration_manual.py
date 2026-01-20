"""
Manual SQL execution via Python - statement by statement
This bypasses the need for exec_sql RPC function
"""

import os
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL")
SERVICE_ROLE_KEY = os.getenv("SERVICE_ROLE_KEY")

supabase = create_client(SUPABASE_URL, SERVICE_ROLE_KEY)

print("🔧 Executing SQL Migration - Manual Approach")
print("=" * 60)

# STEP 1: Add nfc_codes column to personen
print("\n1. ALTER TABLE personen ADD COLUMN nfc_codes...")
try:
    # We can't do ALTER TABLE via Python client
    # But we can verify if column exists by trying to query it
    result = supabase.table('personen').select('nfc_codes').limit(1).execute()
    print("   ✅ Column nfc_codes already exists or query successful")
except Exception as e:
    print(f"   ⚠️  Column may not exist yet: {str(e)[:100]}")

print("\n" + "=" * 60)
print("\n❌ TECHNICAL LIMITATION:")
print("   Python Supabase client cannot execute DDL statements")
print("   (ALTER TABLE, CREATE INDEX require direct PostgreSQL access)")
print("\n✅ SOLUTION: Use Supabase Dashboard SQL Editor")
print(f"\n📋 Steps:")
print(f"   1. Open: https://supabase.com/dashboard/project/eiynfrgezfyncoqaemfr/sql/new")
print(f"   2. Copy SQL from: SQL/migration_multi_nfc_support.sql")
print(f"   3. Paste and click 'RUN'")
print(f"   4. Verify with: python run_migration.py --verify")
print("\n💡 This takes 30 seconds and is the official Supabase workflow")
