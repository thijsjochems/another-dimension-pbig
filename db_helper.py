#!/usr/bin/env python3
"""
Database helper script voor directe Supabase toegang
Gebruik: python db_helper.py <command> [args]
"""

import sys
import json
from dotenv import load_dotenv
import os

load_dotenv()

from supabase import create_client

SUPABASE_URL = os.getenv("SUPABASE_URL")
SERVICE_ROLE_KEY = os.getenv("SERVICE_ROLE_KEY")

supabase = create_client(SUPABASE_URL, SERVICE_ROLE_KEY)

def query_table(table_name, limit=100):
    """SELECT * FROM table"""
    response = supabase.table(table_name).select("*").limit(limit).execute()
    print(json.dumps(response.data, indent=2, ensure_ascii=False))

def execute_sql_file(sql_file):
    """Execute SQL from file"""
    with open(sql_file, 'r', encoding='utf-8') as f:
        sql = f.read()
    
    # Split by semicolon and execute each statement
    statements = [s.strip() for s in sql.split(';') if s.strip() and not s.strip().startswith('--')]
    
    for stmt in statements:
        if stmt.upper().startswith('SELECT'):
            # For SELECT, use postgrest
            print(f"Executing: {stmt[:100]}...")
            response = supabase.rpc('exec_sql', {'query': stmt}).execute()
            print(json.dumps(response.data, indent=2, ensure_ascii=False))
        else:
            # For INSERT/UPDATE/DELETE, execute directly
            print(f"Executing: {stmt[:100]}...")
            response = supabase.rpc('exec_sql', {'query': stmt}).execute()
            print("✓ Success")

def insert_record(table_name, data_json):
    """Insert record into table"""
    data = json.loads(data_json)
    response = supabase.table(table_name).insert(data).execute()
    print(json.dumps(response.data, indent=2, ensure_ascii=False))

def update_nfc(table_name, id_value, nfc_code):
    """Update NFC code for a record - adds to nfc_codes array"""
    # Get current nfc_codes
    response = supabase.table(table_name).select("nfc_codes").eq("id", id_value).execute()
    
    if not response.data:
        print(f"❌ Record not found: {table_name} id={id_value}")
        return
    
    current_codes = response.data[0].get('nfc_codes', [])
    
    # Add new code if not already in array
    if nfc_code not in current_codes:
        current_codes.append(nfc_code)
        response = supabase.table(table_name).update({"nfc_codes": current_codes, "nfc_code": nfc_code}).eq("id", id_value).execute()
        print(f"✅ Updated {table_name} id={id_value}")
        print(f"   NFC codes: {current_codes}")
        print(json.dumps(response.data, indent=2, ensure_ascii=False))
    else:
        print(f"⚠️  Code {nfc_code} already exists in {table_name} id={id_value}")
        print(f"   Current codes: {current_codes}")

def remove_nfc(table_name, id_value, nfc_code):
    """Remove specific NFC code from array"""
    response = supabase.table(table_name).select("nfc_codes").eq("id", id_value).execute()
    
    if not response.data:
        print(f"❌ Record not found: {table_name} id={id_value}")
        return
    
    current_codes = response.data[0].get('nfc_codes', [])
    
    if nfc_code in current_codes:
        current_codes.remove(nfc_code)
        # Update primary nfc_code to first in array (or null if empty)
        primary_code = current_codes[0] if current_codes else None
        response = supabase.table(table_name).update({"nfc_codes": current_codes, "nfc_code": primary_code}).eq("id", id_value).execute()
        print(f"✅ Removed {nfc_code} from {table_name} id={id_value}")
        print(f"   Remaining codes: {current_codes}")
        print(json.dumps(response.data, indent=2, ensure_ascii=False))
    else:
        print(f"⚠️  Code {nfc_code} not found in {table_name} id={id_value}")
        print(f"   Current codes: {current_codes}")

def list_nfc(table_name, id_value):
    """List all NFC codes for a record"""
    response = supabase.table(table_name).select("id, naam, nfc_code, nfc_codes").eq("id", id_value).execute()
    
    if not response.data:
        print(f"❌ Record not found: {table_name} id={id_value}")
        return
    
    print(json.dumps(response.data[0], indent=2, ensure_ascii=False))

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage:")
        print("  python db_helper.py query <table>")
        print("  python db_helper.py exec <sql_file>")
        print("  python db_helper.py insert <table> '<json>'")
        print("  python db_helper.py update_nfc <table> <id> <nfc_code>")
        print("  python db_helper.py remove_nfc <table> <id> <nfc_code>")
        print("  python db_helper.py list_nfc <table> <id>")
        sys.exit(1)
    
    command = sys.argv[1]
    
    if command == "query":
        query_table(sys.argv[2])
    elif command == "exec":
        execute_sql_file(sys.argv[2])
    elif command == "insert":
        insert_record(sys.argv[2], sys.argv[3])
    elif command == "update_nfc":
        update_nfc(sys.argv[2], sys.argv[3], sys.argv[4])
    elif command == "remove_nfc":
        remove_nfc(sys.argv[2], sys.argv[3], sys.argv[4])
    elif command == "list_nfc":
        list_nfc(sys.argv[2], sys.argv[3])
    else:
        print(f"Unknown command: {command}")
        sys.exit(1)
