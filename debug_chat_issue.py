import os
from supabase import create_client
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Initialize Supabase with service role key (bypasses RLS)
supabase = create_client(
    os.getenv("SUPABASE_URL"),
    os.getenv("SERVICE_ROLE_KEY")
)

print("=" * 80)
print("1. CHECK: Zijn er chat berichten?")
print("=" * 80)
messages_result = supabase.table('chat_messages').select('*').execute()
print(f"Aantal berichten: {len(messages_result.data)}")

if len(messages_result.data) > 0:
    print("\n✅ Er zijn berichten!")
    for msg in messages_result.data[:5]:
        print(f"  - Game: {msg['game_id']}, Agent: {msg['agent_id']}, Sender: {msg['sender']}")
else:
    print("\n❌ Geen berichten gevonden")

print("\n" + "=" * 80)
print("2. CHECK: Zijn er actieve games?")
print("=" * 80)
games_result = supabase.table('games').select('id, status, created_at').eq('status', 'active').execute()
print(f"Actieve games: {len(games_result.data)}")

if len(games_result.data) > 0:
    for game in games_result.data:
        print(f"  Game ID: {game['id']}")
        print(f"  Status: {game['status']}")
        print(f"  Created: {game['created_at']}")
else:
    print("❌ Geen actieve games")

print("\n" + "=" * 80)
print("3. CHECK: RLS policies op chat_messages")
print("=" * 80)
print("  (Skip - niet beschikbaar via Python)")

print("\n" + "=" * 80)
print("4. TEST: Kan ik handmatig een bericht invoegen?")
print("=" * 80)

try:
    # Get laatste game
    test_game = supabase.table('games').select('id').order('created_at', desc=False).limit(1).execute()
    
    if len(test_game.data) > 0:
        game_id = test_game.data[0]['id']
        
        test_insert = supabase.table('chat_messages').insert({
            'game_id': game_id,
            'agent_id': 1,
            'message': 'TEST BERICHT VIA PYTHON',
            'sender': 'player',
            'message_number': 999,
        }).execute()
        
        print(f"✅ Handmatige insert gelukt!")
        print(f"   Inserted ID: {test_insert.data[0]['id']}")
        
        # Cleanup test message
        supabase.table('chat_messages').delete().eq('message_number', 999).execute()
        print("   (Test bericht weer verwijderd)")
    else:
        print("❌ Geen games gevonden om mee te testen")
        
except Exception as e:
    print(f"❌ Handmatige insert MISLUKT: {e}")

print("\n" + "=" * 80)
print("CONCLUSIE:")
print("=" * 80)
print("Als handmatige insert lukt maar Edge Function niet werkt:")
print("→ Check Supabase Dashboard > Edge Functions > agent-chat > Logs")
print("→ Kijk naar errors tijdens laatste chat sessie")
print("=" * 80)
