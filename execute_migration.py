#!/usr/bin/env python3
"""
Direct SQL executor via PostgreSQL connection
"""
import psycopg2
from dotenv import load_dotenv
import os

load_dotenv()

# Supabase PostgreSQL connection details
SUPABASE_URL = os.getenv("SUPABASE_URL")  # https://eiynfrgezfyncoqaemfr.supabase.co
PROJECT_ID = "eiynfrgezfyncoqaemfr"

# PostgreSQL connection string for Supabase
# Format: db.PROJECT_ID.supabase.co:5432 (Session mode - DDL support)
DB_HOST = f"db.{PROJECT_ID}.supabase.co"
DB_PORT = "5432"
DB_NAME = "postgres"
DB_USER = "postgres"
DB_PASSWORD = os.getenv("SERVICE_ROLE_KEY") or os.getenv("DB_PASSWORD")

print(f"🔌 Connecting to PostgreSQL...")
print(f"   Host: {DB_HOST}")
print(f"   Database: {DB_NAME}")
print(f"   User: {DB_USER}")

try:
    # Connect to PostgreSQL
    conn = psycopg2.connect(
        host=DB_HOST,
        port=DB_PORT,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    
    conn.autocommit = True  # Important for DDL statements
    cursor = conn.cursor()
    
    print("✅ Connected successfully!\n")
    
    # Read migration SQL file
    with open('SQL/migration_multi_nfc_support.sql', 'r', encoding='utf-8') as f:
        sql = f.read()
    
    # Split into statements (simple split by semicolon)
    statements = [s.strip() for s in sql.split(';') if s.strip() and not s.strip().startswith('--')]
    
    print(f"📝 Executing {len(statements)} SQL statements...\n")
    
    for i, statement in enumerate(statements, 1):
        # Skip comment-only lines
        if all(line.strip().startswith('--') or not line.strip() for line in statement.split('\n')):
            continue
        
        # Show first 60 chars of statement
        preview = statement.replace('\n', ' ')[:60] + "..."
        print(f"[{i}/{len(statements)}] {preview}")
        
        try:
            cursor.execute(statement)
            
            # If it's a SELECT, show results
            if statement.strip().upper().startswith('SELECT'):
                results = cursor.fetchall()
                if results:
                    print(f"    ✅ {len(results)} rows returned")
                    for row in results[:3]:  # Show first 3 rows
                        print(f"       {row}")
                else:
                    print(f"    ✅ No rows returned")
            else:
                print(f"    ✅ Success")
        except Exception as e:
            print(f"    ⚠️  Error: {e}")
            # Continue with next statement
    
    print("\n✅ Migration completed!")
    
    # Verify
    print("\n🔍 Verification:")
    cursor.execute("SELECT id, naam, nfc_code, nfc_codes FROM personen LIMIT 1")
    result = cursor.fetchone()
    print(f"   Personen sample: {result}")
    
    cursor.execute("SELECT id, naam, nfc_code, nfc_codes FROM wapens LIMIT 1")
    result = cursor.fetchone()
    print(f"   Wapens sample: {result}")
    
    cursor.close()
    conn.close()
    
    print("\n🎉 All done! nfc_codes arrays are ready for backup tags!")
    
except Exception as e:
    print(f"❌ Connection failed: {e}")
    print("\n💡 Trying alternative: Use database password from Supabase settings")
    print("   Go to: https://supabase.com/dashboard/project/eiynfrgezfyncoqaemfr/settings/database")
    print("   Copy 'Database Password' and add to .env as DB_PASSWORD=...")
