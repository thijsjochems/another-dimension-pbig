import os
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()
url = os.getenv('SUPABASE_URL')
key = os.getenv('SUPABASE_KEY')
client = create_client(url, key)

scenarios = client.table('scenarios').select('*').order('id').execute().data or []
personen = {r['id']: r.get('naam','') for r in (client.table('personen').select('id,naam').execute().data or [])}
wapens = {r['id']: r.get('naam','') for r in (client.table('wapens').select('id,naam').execute().data or [])}
locaties = {r['id']: r.get('naam','') for r in (client.table('locaties').select('id,naam').execute().data or [])}

print(f"Total scenarios: {len(scenarios)}")
print('-'*140)
for s in scenarios:
    sid = s.get('id')
    naam = s.get('naam','')
    persoon = personen.get(s.get('persoon_id') or s.get('dader_id'), '')
    wapen = wapens.get(s.get('wapen_id'), '')
    locatie = locaties.get(s.get('locatie_id'), '')
    situatie = (s.get('situatie_beschrijving') or '').strip()
    beschrijving = (s.get('beschrijving') or s.get('verhaal') or '').strip()

    print(f"#{sid:>2} | {naam}")
    print(f"  combo: {persoon} | {wapen} | {locatie}")
    print(f"  situatie_len={len(situatie):>4} | beschrijving_len={len(beschrijving):>4}")
    print(f"  situatie: {situatie[:260].replace(chr(10),' ')}")
    print(f"  beschrijving: {beschrijving[:260].replace(chr(10),' ')}")
    print('-'*140)
