"""Check laatste game"""
import os
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()

supabase = create_client(
    os.getenv("SUPABASE_URL"),
    os.getenv("SERVICE_ROLE_KEY")
)

print("=" * 80)
print("LAATSTE 10 GAMES")
print("=" * 80)

games = supabase.table('games').select('*').order('created_at', desc=False).limit(10).execute()

for game in games.data:
    print(f"\nGame ID: {game['id']}")
    print(f"  Status: {game['status']}")
    print(f"  Created: {game['created_at']}")
    print(f"  Scenario: {game.get('scenario_id', 'N/A')}")

print("\n" + "=" * 80)
print("ACTIVE GAMES")
print("=" * 80)

active_games = supabase.table('games').select('*').eq('status', 'active').execute()
print(f"Aantal active games: {len(active_games.data)}")

if active_games.data:
    for game in active_games.data:
        print(f"\n✅ Game ID: {game['id']}")
        print(f"   Status: {game['status']}")
        print(f"   Created: {game['created_at']}")
else:
    print("\n❌ Geen active games!")
    print("\nMogelijke oorzaken:")
    print("1. Game startup code zet status niet naar 'active'")
    print("2. Er is een database trigger die status automatisch wijzigt")
    print("3. Frontend code stuurt verkeerde status parameter")
