"""Check database constraints en chat_messages cleanup"""
import os
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()

supabase = create_client(
    os.getenv("SUPABASE_URL"),
    os.getenv("SERVICE_ROLE_KEY")
)

print("=" * 80)
print("1. HUIDIGE SITUATIE: Chat messages per game")
print("=" * 80)

# Get chat messages grouped by game
messages = supabase.table('chat_messages').select('game_id, agent_id, message_number, created_at').order('game_id', desc=False).execute()

if messages.data:
    games_with_chats = {}
    for msg in messages.data:
        game_id = msg['game_id']
        if game_id not in games_with_chats:
            games_with_chats[game_id] = {'count': 0, 'agents': set()}
        games_with_chats[game_id]['count'] += 1
        games_with_chats[game_id]['agents'].add(msg['agent_id'])
    
    for game_id, data in games_with_chats.items():
        print(f"Game {game_id}: {data['count']} berichten, agents: {sorted(data['agents'])}")
else:
    print("Geen chat berichten")

print("\n" + "=" * 80)
print("2. GAMES met status")
print("=" * 80)

games = supabase.table('games').select('id, status, created_at').order('id', desc=False).limit(10).execute()

for game in games.data:
    chat_count = len([m for m in messages.data if m['game_id'] == game['id']]) if messages.data else 0
    print(f"Game {game['id']}: status={game['status']}, chats={chat_count}")

print("\n" + "=" * 80)
print("3. TEST: Wat gebeurt er met oude 'completed' games?")
print("=" * 80)

completed_games = supabase.table('games').select('id').eq('status', 'completed').execute()
if completed_games.data:
    completed_ids = [g['id'] for g in completed_games.data]
    old_chats = [m for m in messages.data if m['game_id'] in completed_ids] if messages.data else []
    print(f"Completed games: {len(completed_ids)}")
    print(f"Chats van completed games: {len(old_chats)}")
    
    if len(old_chats) > 0:
        print("\n⚠️  PROBLEEM: Chat berichten van oude games worden NIET verwijderd")
        print("   → Database groeit onbeperkt (garbage collection nodig)")
    else:
        print("\n✅ Chat berichten van completed games zijn leeg")
else:
    print("Geen completed games")

print("\n" + "=" * 80)
print("CONCLUSIE:")
print("=" * 80)
print("Als completed games nog chats hebben:")
print("  → Er is GEEN automatische cleanup")
print("  → Chat_messages tabel groeit onbeperkt")
print("  → Oplossing 1: Database trigger ON DELETE CASCADE")
print("  → Oplossing 2: Cleanup functie in app.py")
print("  → Oplossing 3: TTL policy (bijv. verwijder chats ouder dan 30 dagen)")
print("=" * 80)
