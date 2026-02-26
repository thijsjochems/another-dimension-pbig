"""Check game 179 details"""
import os
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()

supabase = create_client(
    os.getenv("SUPABASE_URL"),
    os.getenv("SERVICE_ROLE_KEY")
)

print("=" * 80)
print("ALLE GAMES (laatste 5)")
print("=" * 80)
all_games = supabase.table('games').select('*').order('created_at', desc=False).limit(5).execute()
print(f"Totaal aantal games: query returned {len(all_games.data)} results")

for game in all_games.data:
    print(f"\nGame ID: {game['id']}")
    print(f"  Status: {game['status']}")
    print(f"  Created: {game['created_at']}")
    print(f"  Scenario: {game.get('scenario_id', 'N/A')}")

print("\n" + "=" * 80)
print("SPECIFIEKE CHECK: Game 179")
print("=" * 80)
try:
    game_179 = supabase.table('games').select('*').eq('id', 179).execute()
    if game_179.data:
        print(f"✅ Game 179 bestaat!")
        game = game_179.data[0]
        print(f"  Status: {game['status']}")
        print(f"  Created: {game['created_at']}")
        print(f"  Scenario ID: {game.get('scenario_id', 'N/A')}")
        print(f"  Visited agents: {game.get('visited_agents', [])}")
    else:
        print("❌ Game 179 bestaat niet!")
except Exception as e:
    print(f"❌ Error: {e}")

print("\n" + "=" * 80)
print("CONCLUSIE:")
print("Als game bestaat maar status != 'active':")
print("→ Check welke waarden status kolom kan hebben")
print("=" * 80)
