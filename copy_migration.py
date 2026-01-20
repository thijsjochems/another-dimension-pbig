"""
Copy SQL migration to clipboard for easy pasting in Supabase SQL Editor
"""

import os
import sys
from pathlib import Path

sql_file = "SQL/migration_multi_nfc_support.sql"

# Check if file exists
if not Path(sql_file).exists():
    print(f"❌ File not found: {sql_file}")
    sys.exit(1)

# Read SQL content
with open(sql_file, 'r', encoding='utf-8') as f:
    sql_content = f.read()

print("=" * 70)
print("📋 SQL MIGRATION - READY TO COPY")
print("=" * 70)
print()
print("📝 Instructions:")
print("   1. Open Supabase SQL Editor:")
print("      https://supabase.com/dashboard/project/eiynfrgezfyncoqaemfr/sql/new")
print()
print("   2. Copy the SQL below (Ctrl+A, Ctrl+C)")
print("   3. Paste in SQL Editor (Ctrl+V)")
print("   4. Click 'Run' button")
print()
print("=" * 70)
print("SQL MIGRATION CONTENT:")
print("=" * 70)
print()
print(sql_content)
print()
print("=" * 70)
print("✅ After execution, verify with: python run_migration.py --verify")
print("=" * 70)

# Try to copy to clipboard using Windows clip
try:
    import subprocess
    process = subprocess.Popen(['clip'], stdin=subprocess.PIPE, shell=True)
    process.communicate(sql_content.encode('utf-8'))
    print()
    print("✨ SQL copied to clipboard! Ready to paste in Supabase SQL Editor.")
except:
    print()
    print("💡 Please manually select and copy the SQL above.")
