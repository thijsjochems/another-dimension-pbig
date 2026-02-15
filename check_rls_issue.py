"""Check game status en RLS"""
import os
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()

# Test 1: Met SERVICE_ROLE_KEY (bypasses RLS)
print("=" * 80)
print("1. CHECK MET SERVICE_ROLE_KEY (zonder RLS)")
print("=" * 80)

supabase_admin = create_client(
    os.getenv("SUPABASE_URL"),
    os.getenv("SERVICE_ROLE_KEY")
)

games_admin = supabase_admin.table('games').select('id, status, created_at, visited_agents').eq('status', 'active').execute()
print(f"Gevonden games (admin): {len(games_admin.data)}")
for game in games_admin.data:
    print(f"  ID: {game['id']}")
    print(f"  Status: {game['status']}")
    print(f"  Created: {game['created_at']}")
    print(f"  Visited: {game.get('visited_agents', [])}")

# Test 2: Met ANON_KEY (zoals Edge Function)
print("\n" + "=" * 80)
print("2. CHECK MET ANON_KEY (met RLS - zoals Edge Function)")
print("=" * 80)

try:
    supabase_anon = create_client(
        os.getenv("SUPABASE_URL"),
        os.getenv("SUPABASE_KEY")
    )
    
    games_anon = supabase_anon.table('games').select('id, status').eq('status', 'active').execute()
    print(f"Gevonden games (anon): {len(games_anon.data)}")
    
    if len(games_anon.data) == 0:
        print("\n❌ PROBLEEM GEVONDEN!")
        print("   Edge Function gebruikt ANON_KEY maar kan geen games zien")
        print("   → RLS blokkeert toegang tot games tabel")
        print("\n   OPLOSSING: Edge Function moet SERVICE_ROLE_KEY gebruiken")
    else:
        print(f"✅ ANON_KEY kan games zien: {len(games_anon.data)}")
        
except Exception as e:
    print(f"❌ Error met ANON_KEY: {e}")

print("\n" + "=" * 80)
print("EDGE FUNCTION CODE CHECK")
print("=" * 80)
print("Regel 29 in index.ts:")
print("  Deno.env.get('SERVICE_ROLE_KEY')")
print("\nMaar Supabase Edge Functions hebben deze env var:")
print("  SUPABASE_SERVICE_ROLE_KEY (met SUPABASE_ prefix!)")
print("\n⚠️  MOGELIJKE BUG: Verkeerde env var naam!")
print("=" * 80)
