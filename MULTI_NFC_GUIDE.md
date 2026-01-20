# Multi-NFC Support Implementation

## ✅ WAT IS GEDAAN:

### 1. Database Migration (SQL/migration_multi_nfc_support.sql)
- Voegt `nfc_codes` JSONB kolom toe aan:
  - personen
  - wapens  
  - locaties
  - agents
  - special_nfc_codes
- Migreert bestaande `nfc_code` waarden naar array
- Maakt GIN indexes voor snelle JSONB lookups
- Behoudt oude `nfc_code` kolom voor backwards compatibility

### 2. Backend Updates (app.py)
- `get_nfc_mapping()` functie update:
  - Checkt BEIDE: oude `nfc_code` (single) EN nieuwe `nfc_codes` (array)
  - Query: `.or_(f'nfc_code.eq.{code},nfc_codes.cs.{{"{code}"}}')`
  - Werkt met single tags EN multi tags

### 3. Helper Script Updates (db_helper.py)
Nieuwe functies:
- `update_nfc(table, id, code)` - Voegt code toe aan array (als niet bestaand)
- `remove_nfc(table, id, code)` - Verwijdert specifieke code uit array
- `list_nfc(table, id)` - Toont alle codes voor een record

## 🚀 HOE TE GEBRUIKEN:

### Migration uitvoeren:
1. Ga naar: https://supabase.com/dashboard/project/eiynfrgezfyncoqaemfr/sql/new
2. Kopieer SQL/migration_multi_nfc_support.sql
3. Plak in SQL Editor en klik 'Run'
4. Verificatie: `python run_migration.py --verify`

### NFC Tags Toevoegen:
```bash
# Eerste tag toevoegen (migreert automatisch van oude nfc_code)
python db_helper.py update_nfc personen 4 0123456789

# Backup tags toevoegen
python db_helper.py update_nfc personen 4 9876543210
python db_helper.py update_nfc personen 4 5555555555

# Lijst alle tags
python db_helper.py list_nfc personen 4

# Tag verwijderen
python db_helper.py remove_nfc personen 4 5555555555
```

### Voorbeelden per type:
```bash
# Personen
python db_helper.py update_nfc personen 1 <nfc_code>  # Power BI Developer
python db_helper.py update_nfc personen 3 <nfc_code>  # Database Beheerder
python db_helper.py update_nfc personen 4 <nfc_code>  # Financial Controller

# Wapens (1-7)
python db_helper.py update_nfc wapens 1 <nfc_code>  # Inactieve Relatie
python db_helper.py update_nfc wapens 2 <nfc_code>  # Hidden Slicer
# ... etc

# Locaties
python db_helper.py update_nfc locaties 1 <nfc_code>  # OneDrive
python db_helper.py update_nfc locaties 2 <nfc_code>  # Power Query Editor
# ... etc

# Agents
python db_helper.py update_nfc agents 1 <nfc_code>  # Schoonmaker
python db_helper.py update_nfc agents 2 <nfc_code>  # Receptionist
python db_helper.py update_nfc agents 3 <nfc_code>  # Stagiair

# Special codes
python db_helper.py update_nfc special_nfc_codes 1 <nfc_code>  # START
python db_helper.py update_nfc special_nfc_codes 2 <nfc_code>  # EXIT
python db_helper.py update_nfc special_nfc_codes 3 <nfc_code>  # RESET
# ... etc
```

## 🎯 VOORDELEN:

1. **Redundantie**: 3-5 backup tags per item
2. **Geen downtime**: Tag kwijt? Backup tags werken nog
3. **Backwards compatible**: Oude single nfc_code blijft werken
4. **Future proof**: Makkelijk uitbreiden met meer tags

## 📊 DATABASE STRUCTUUR:

**Voor:**
```
personen.nfc_code = "3032948996"
```

**Na:**
```
personen.nfc_code = "3032948996"  // Primary (backwards compat)
personen.nfc_codes = ["3032948996", "backup1", "backup2"]  // Array
```

## 🔍 QUERY VOORBEELDEN:

```sql
-- Check of code voorkomt in array
SELECT * FROM personen WHERE nfc_codes ? '3032948996';

-- Alle codes voor een persoon
SELECT naam, nfc_codes FROM personen WHERE id = 1;

-- Tel aantal backup tags
SELECT naam, jsonb_array_length(nfc_codes) as num_tags 
FROM personen;
```

## ✅ VERIFICATIE:

Na migration:
```bash
python run_migration.py --verify
```

Test scan functionaliteit:
```bash
# Test met oude code (moet werken)
curl -X POST http://localhost:5000/api/game/scan \
  -H "Content-Type: application/json" \
  -d '{"nfc_code": "3032948996"}'

# Test met nieuwe backup code (moet ook werken)
curl -X POST http://localhost:5000/api/game/scan \
  -H "Content-Type: application/json" \
  -d '{"nfc_code": "backup_code_123"}'
```

## 🎮 GAME FLOW:

1. Speler scant tag → code naar `/api/game/scan`
2. Backend checkt: `nfc_code.eq.{code} OR nfc_codes.cs.{"{code}"}`
3. Als match: return persoon/wapen/locatie data
4. Werkt met ALLE codes in de array!

## 📝 BELANGRIJKE NOTES:

- Eerste code in array = primary code
- `update_nfc` voegt ALTIJD toe (duplicates vermijden)
- `remove_nfc` update primary naar eerste in resterende array
- Interface hoeft NIETS te weten van arrays - transparant!
