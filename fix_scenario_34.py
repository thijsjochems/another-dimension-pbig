"""
Update scenario 34 - Focus op Dubbele Records ipv Many-to-Many relatie
"""
from db_helper import supabase

scenario_id = 34

# Nieuwe beschrijvingen
nieuwe_beschrijving = """De Power BI Developer importeert data uit twee verschillende bronnen: een oude Excel export en een nieuwe SQL database. Hij wil ze samenvoegen in één tabel voor historische analyse. In Power Query voegt hij beide datasets samen met "Append Queries", maar vergeet te checken of er overlap is tussen de periode's. 

Het blijkt dat de laatste 3 maanden in BEIDE bronnen zitten - in de oude Excel (die nog niet was uitgeschakeld) én in de nieuwe SQL database. Door de Append ontstaan er dubbele records voor deze periode in het Semantisch Model. Alle measures tellen deze records nu dubbel: omzet, aantal orders, klanten - alles is te hoog.

Hij had in Power Query moeten filteren op datumbereik, of een DISTINCT moeten toepassen, of de overlap moeten detecteren met "Group By". De duplicaten zijn onzichtbaar in de visuals (geen waarschuwing), maar de totalen kloppen niet. Dit is realistisch: bij data-integratie tussen oude en nieuwe systemen ontstaan vaak onbedoelde duplicaten."""

nieuwe_situatie = """De Power BI Developer krijgt de opdracht om historische data toe te voegen aan het dashboard. De oude data zit in Excel files, de nieuwe data komt uit SQL. Hij voegt beide samen in Power Query met "Append Queries". Het lijkt te werken: alle rijen zijn er, de kolommen kloppen.

Hij publiceert het rapport en Finance is blij: "Eindelijk historische data!" Maar een week later belt de CFO: "Deze cijfers kloppen niet - Q3 omzet is veel te hoog!" De Developer checkt de brondata: Excel klopt, SQL klopt. Hij checkt de DAX measures: geen fouten. Hij kijkt naar de relaties: alles lijkt goed.

Wat hij niet ziet: de laatste 3 maanden zitten in BEIDE bronnen. Door de Append Query zijn deze records nu DUBBEL in het model geladen. Alle totalen voor die periode zijn daardoor x2 te hoog. De duplicaten zijn lastig te vinden omdat individuele records er normaal uitzien - alleen de totalen zijn fout."""

print("=" * 80)
print("🔄 SCENARIO 34 UPDATEN")
print("=" * 80)

# Update in database
result = supabase.table('scenarios').update({
    'beschrijving': nieuwe_beschrijving,
    'situatie_beschrijving': nieuwe_situatie
}).eq('id', scenario_id).execute()

print(f"\n✅ Scenario 34 succesvol geüpdatet!")
print(f"\n📋 NIEUWE VERSIE:")
print(f"   Naam: De Onzichtbare Duplicaten")
print(f"   Dader: Power BI Developer")
print(f"   Wapen: Dubbele Records")
print(f"   Locatie: Semantisch Model")
print(f"\n💡 VERHAAL:")
print(f"   Developer voegt oude Excel data samen met nieuwe SQL data")
print(f"   Append Query in Power Query zonder overlap check")
print(f"   Laatste 3 maanden zitten in beide bronnen → dubbele records")
print(f"   Measures tellen alles x2 → cijfers kloppen niet")

print("\n" + "=" * 80)
