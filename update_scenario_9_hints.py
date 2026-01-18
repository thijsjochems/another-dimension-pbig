from supabase import create_client
import os
from dotenv import load_dotenv

load_dotenv()
client = create_client(os.getenv('SUPABASE_URL'), os.getenv('SUPABASE_KEY'))

# Verwijder oude hints
client.table('scenario_hints').delete().eq('scenario_id', 9).execute()
print('🗑️ Oude hints verwijderd')

# Schoonmaker
client.table('scenario_hints').insert({
    'scenario_id': 9,
    'agent_id': 1,
    'hint_tekst': 'Begin februari werkte de Database Beheerder vaak tot laat. Irritant - er lagen overal chipszakjes.',
    'hint_volgorde': 1
}).execute()
print('✅ Schoonmaker hint toegevoegd')

# Receptionist
client.table('scenario_hints').insert({
    'scenario_id': 9,
    'agent_id': 2,
    'hint_tekst': 'De Power BI Developer was op wintersport in februari. Frankrijk dacht ik. Of Italië. Of Oostenrijk. Een van die drie.',
    'hint_volgorde': 1
}).execute()
print('✅ Receptionist hint toegevoegd')

# Stagiair
client.table('scenario_hints').insert({
    'scenario_id': 9,
    'agent_id': 3,
    'hint_tekst': 'De Database Beheerder had me om hulp gevraagd met de ERP migratie. Ik moest checken of alle connecties werkten. In de database queries zag ik dat het nieuwe systeem underscores gebruikt - Sales_Amount in plaats van SalesAmount. Ik dacht: hopelijk heeft iemand de Power BI measures ook aangepast. Maar de Developer was op wintersport...',
    'hint_volgorde': 1
}).execute()
print('✅ Stagiair hint toegevoegd')

print('\n🎉 Alle hints voor scenario 9 toegevoegd!')
