# Supabase Credentials Vinden

## Stap 1: Ga naar je Supabase project
1. Open https://supabase.com
2. Log in met je account
3. Selecteer je project (of maak een nieuw project aan als je dat nog niet hebt gedaan)

## Stap 2: Ga naar Project Settings
1. Klik linksonder op het **tandwiel icoon** (⚙️ Settings)
2. Klik op **API** in het linker menu

## Stap 3: Kopieer de credentials

### Project URL
- Zoek naar **"Project URL"** bovenaan de pagina
- Kopieer de URL (bijv. `https://abcdefghijk.supabase.co`)
- Plak deze in je `.env` file bij `SUPABASE_URL=`

### Project API Key
- Scroll naar beneden naar **"Project API keys"**
- Kopieer de **"anon public"** key (dit is een lange string met letters en cijfers)
- Plak deze in je `.env` file bij `SUPABASE_KEY=`

## Je .env file moet er zo uitzien:

```
SUPABASE_URL=https://jouwproject.supabase.co
SUPABASE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOi.....(heel lange key)

FLASK_ENV=development
FLASK_DEBUG=True
SECRET_KEY=een-willekeurige-secret-key-123
```

## Stap 4: Genereer een SECRET_KEY
Voer dit uit in PowerShell (met venv actief):
```powershell
python -c "import secrets; print(secrets.token_urlsafe(32))"
```

Plak de output bij `SECRET_KEY=` in je `.env` file.

## Klaar!
Nu kun je Flask starten met `python app.py`
