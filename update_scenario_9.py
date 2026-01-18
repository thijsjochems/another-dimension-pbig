from supabase import create_client
import os
from dotenv import load_dotenv

load_dotenv()

client = create_client(os.getenv('SUPABASE_URL'), os.getenv('SUPABASE_KEY'))

beschrijving = """Begin februari 2026 ging de migratie naar het nieuwe ERP systeem live. De Database Beheerder testte de nieuwe connectie - queries draaiden perfect, data kwam binnen. Maar in de hectiek van de go-live zag niemand dat het nieuwe systeem een underscore gebruikte: "Sales_Amount" in plaats van "SalesAmount". De Power BI Developer was die week op een klantproject. Niemand checkte het dashboard. Vanaf 1 februari toonde het dashboard geen omzetcijfers meer. Januari werkte nog, februari was leeg. In maart vroeg Sales: "Waarom hebben we Q1 nog geen omzetcijfers?" Het bleek: twee kolommen in het model - "SalesAmount" (oud systeem, tot januari) en "Sales_Amount" (nieuw systeem, vanaf februari). De measure wees alleen naar de oude naam."""

situatie_beschrijving = """Dashboard toont omzet tot en met januari 2026. Sinds februari toont de rapportage geen omzet meer. Q1 cijfers zijn incompleet - alleen januari zichtbaar. Zou dit te maken kunnen hebben met de implementatie van het nieuwe bronsysteem?"""

result = client.table('scenarios').update({
    'persoon_id': 3,
    'wapen_id': 6,
    'locatie_id': 3,
    'naam': 'De Bronsysteem Migratie',
    'beschrijving': beschrijving,
    'situatie_beschrijving': situatie_beschrijving
}).eq('id', 9).execute()

print('✅ Scenario 9 updated:', result.data[0]['naam'])
