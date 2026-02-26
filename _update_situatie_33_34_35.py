import os
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()
client = create_client(os.getenv('SUPABASE_URL'), os.getenv('SUPABASE_KEY'))

updates = {
    33: 'Iedereen ziet andere cijfers in hetzelfde dashboard. Voor sommige teams klopt alles, voor andere teams ontbreken records. Wat filtert hier stiekem mee?',
    34: 'Na het toevoegen van historische data schieten totalen ineens omhoog. De bronbestanden lijken op het oog correct, maar de uitkomst is structureel te hoog.',
    35: 'De nachtelijke import draait zonder error, maar het dashboard blijft oude cijfers tonen. Het proces lijkt gezond, toch loopt de data stilletjes achter.'
}

for scenario_id, text in updates.items():
    client.table('scenarios').update({'situatie_beschrijving': text}).eq('id', scenario_id).execute()

rows = client.table('scenarios').select('id,naam,situatie_beschrijving').in_('id', [33, 34, 35]).order('id').execute().data or []

print('Updated scenario situatie_beschrijving:')
for row in rows:
    situatie = (row.get('situatie_beschrijving') or '').strip()
    print(f"{row['id']} | {len(situatie)} chars | {row.get('naam')} | {situatie}")
