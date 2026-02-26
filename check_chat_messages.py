"""Check chat messages in Supabase"""
import os
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()

supabase = create_client(
    os.getenv("SUPABASE_URL"),
    os.getenv("SERVICE_ROLE_KEY")
)

# Check 1: Zijn er berichten?
print("=" * 80)
print("LAATSTE 20 CHAT BERICHTEN")
print("=" * 80)
result = supabase.table('chat_messages').select('*').order('created_at', desc=True).limit(20).execute()

if result.data:
    for msg in result.data:
        print(f"\nGame {msg['game_id']} | Agent {msg['agent_id']} | Msg #{msg['message_number']}")
        print(f"Sender: {msg['sender']}")
        print(f"Message: {msg['message'][:80]}...")
        print(f"Time: {msg['created_at']}")
        print("-" * 80)
else:
    print("❌ GEEN BERICHTEN GEVONDEN")
    print("De Edge Function slaat nog geen berichten op.")
    print("→ Function moet ge-deployed worden met nieuwe code")

# Check 2: Per game/agent statistieken
print("\n" + "=" * 80)
print("BERICHTEN PER GAME/AGENT")
print("=" * 80)
if result.data:
    from collections import defaultdict
    stats = defaultdict(lambda: {'count': 0, 'first': None, 'last': None})
    
    for msg in result.data:
        key = (msg['game_id'], msg['agent_id'])
        stats[key]['count'] += 1
        if stats[key]['first'] is None or msg['created_at'] < stats[key]['first']:
            stats[key]['first'] = msg['created_at']
        if stats[key]['last'] is None or msg['created_at'] > stats[key]['last']:
            stats[key]['last'] = msg['created_at']
    
    for (game_id, agent_id), data in stats.items():
        print(f"Game {game_id} | Agent {agent_id}: {data['count']} berichten")
        print(f"  Eerste: {data['first']}")
        print(f"  Laatste: {data['last']}")
else:
    print("Geen data om te tellen")
