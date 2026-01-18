"""
Voeg agent hints toe voor scenario 9: De Bronsysteem Migratie
"""
import os
from dotenv import load_dotenv
from supabase import create_client, Client

# Load environment variables
load_dotenv()

# Supabase connectie
url = os.getenv("SUPABASE_URL")
key = os.getenv("SUPABASE_KEY")
supabase: Client = create_client(url, key)

# Agent hints voor scenario 9
hints = [
    {
        'scenario_id': 9,
        'agent_id': 1,  # Schoonmaker
        'hint_text': 'Database Beheerder werkte vaak tot laat in februari. Was irritant, chipszakjes overal.'
    },
    {
        'scenario_id': 9,
        'agent_id': 2,  # Receptionist
        'hint_text': 'Power BI Developer was op wintersport. Frankrijk dacht ik. Of Italië. Of Oostenrijk.'
    },
    {
        'scenario_id': 9,
        'agent_id': 3,  # Stagiair
        'hint_text': 'Wilde iets vragen aan Admin. Admin had geen tijd voor me. Was druk bezig met het mappen van alle kolommen van de oude en de nieuwe applicatie.'
    }
]

# Voeg hints toe
result = supabase.table('scenario_hints').insert(hints).execute()

print(f"✅ {len(result.data)} hints toegevoegd voor scenario 9")
for hint in result.data:
    print(f"   - Agent {hint['agent_id']}: {hint['hint_text'][:50]}...")
