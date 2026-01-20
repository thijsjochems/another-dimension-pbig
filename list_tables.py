#!/usr/bin/env python3
"""List all tables in Supabase database"""
from dotenv import load_dotenv
import os

load_dotenv()

from supabase import create_client

SUPABASE_URL = os.getenv("SUPABASE_URL")
SERVICE_ROLE_KEY = os.getenv("SERVICE_ROLE_KEY")

supabase = create_client(SUPABASE_URL, SERVICE_ROLE_KEY)

# Query PostgreSQL information_schema to get all tables
query = """
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name
"""

response = supabase.rpc('exec_sql', {'query': query}).execute()
print("Tables in database:")
for row in response.data:
    print(f"  - {row.get('table_name', row)}")
