"""Test Edge Function direct"""
import os
import requests
from dotenv import load_dotenv

load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_ANON_KEY = os.getenv("SUPABASE_KEY")

print("=" * 80)
print("TEST EDGE FUNCTION DIRECT")
print("=" * 80)

# Test 1: Zonder game_id (zoals frontend doet)
print("\n1. Test ZONDER game_id (auto-detect)")
print("-" * 80)

response1 = requests.post(
    f"{SUPABASE_URL}/functions/v1/agent-chat",
    headers={
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {SUPABASE_ANON_KEY}',
        'apikey': SUPABASE_ANON_KEY
    },
    json={
        'agent_id': 1,
        'message': 'Test bericht zonder game_id'
    }
)

print(f"Status: {response1.status_code}")
print(f"Response: {response1.text}")

# Test 2: Met expliciete game_id 
print("\n\n2. Test MET game_id (explicit)")
print("-" * 80)

response2 = requests.post(
    f"{SUPABASE_URL}/functions/v1/agent-chat",
    headers={
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {SUPABASE_ANON_KEY}',
        'apikey': SUPABASE_ANON_KEY
    },
    json={
        'game_id': '179',  # De active game die we net zagen
        'agent_id': 1,
        'message': 'Test bericht met game_id'
    }
)

print(f"Status: {response2.status_code}")
print(f"Response: {response2.text}")

print("\n" + "=" * 80)
print("CONCLUSIE:")
print("Als Test 1 faalt maar Test 2 werkt:")
print("→ Auto-detect is kapot, frontend moet game_id meesturen")
print("=" * 80)
