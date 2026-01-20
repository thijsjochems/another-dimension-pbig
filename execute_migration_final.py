"""
Execute SQL via PostgREST SQL endpoint
Using the actual REST endpoint that Supabase exposes
"""

import os
import sys
import requests
from dotenv import load_dotenv

load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL")
SERVICE_ROLE_KEY = os.getenv("SERVICE_ROLE_KEY")

# Read SQL
with open("SQL/migration_multi_nfc_support.sql", 'r', encoding='utf-8') as f:
    sql = f.read()

print("🚀 Executing SQL via PostgREST")
print("=" * 60)

# Split into statements
statements = [s.strip() for s in sql.split(';') if s.strip() and not s.strip().startswith('--')]

print(f"📋 {len(statements)} statements\n")

# Try using pg_stat_statements extension via RPC
# First, let's see what RPC functions are available
headers = {
    "apikey": SERVICE_ROLE_KEY,
    "Authorization": f"Bearer {SERVICE_ROLE_KEY}",
    "Content-Type": "application/json",
    "Prefer": "return=representation"
}

success = 0
failed = 0

# For each DDL statement, we need to execute it via a custom RPC function
# Since that doesn't exist, let's create a workaround using the Python client
# with admin privileges

from supabase import create_client

supabase = create_client(SUPABASE_URL, SERVICE_ROLE_KEY)

print("💡 Since direct SQL execution isn't available via REST,")
print("   I'll execute the migration using the web UI automation.\n")

# Open the SQL editor with the migration pre-filled
import urllib.parse
import webbrowser

# URL encode the SQL
encoded_sql = urllib.parse.quote(sql)

# Supabase SQL editor doesn't support pre-filled SQL via URL
# So we'll copy to clipboard and open the editor
print("📋 Copying SQL to clipboard...")

try:
    import subprocess
    process = subprocess.Popen(['clip'], stdin=subprocess.PIPE, shell=True)
    process.communicate(sql.encode('utf-8'))
    print("✅ SQL copied to clipboard!")
except:
    print("❌ Could not copy to clipboard")

# Open SQL editor
sql_editor_url = "https://supabase.com/dashboard/project/eiynfrgezfyncoqaemfr/sql/new"
print(f"\n🌐 Opening SQL Editor...")
print(f"   URL: {sql_editor_url}")

import subprocess
subprocess.run(['cmd', '/c', 'start', sql_editor_url], shell=True)

print("\n" + "=" * 60)
print("✅ READY TO EXECUTE")
print("=" * 60)
print("\n📋 Steps:")
print("   1. SQL Editor should open in your browser")
print("   2. Press Ctrl+V to paste the SQL (already in clipboard)")
print("   3. Click the green 'RUN' button")
print("   4. Come back here and I'll verify it worked")
print("\n⏳ Waiting for you to complete these steps...")
print("   Press ENTER when done...")

input()

print("\n📊 Verifying migration...")
os.system("python run_migration.py --verify")
