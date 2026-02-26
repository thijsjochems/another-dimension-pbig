"""Check game 181 status"""
import os
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()

supabase = create_client(
    os.getenv("SUPABASE_URL"),
    os.getenv("SERVICE_ROLE_KEY")
)

game_181 = supabase.table('games').select('*').eq('id', 181).execute()

if game_181.data:
    game = game_181.data[0]
    print(f"Game 181:")
    print(f"  Status: {game['status']}")
    print(f"  Created: {game['created_at']}")
    print(f"  Completed: {game.get('completed', 'N/A')}")
    print(f"  Aborted: {game.get('aborted', 'N/A')}")
    
    chats = supabase.table('chat_messages').select('*').eq('game_id', 181).execute()
    print(f"\n  Chat berichten: {len(chats.data)}")
    
    if game['status'] == 'completed':
        print("\n⚠️  Game is 'completed' maar chats staan er nog!")
        print("  → Chats worden NIET automatisch verwijderd bij game completion")
    elif game['status'] == 'active':
        print("\n✅ Game is nog active, chats horen er te zijn")
