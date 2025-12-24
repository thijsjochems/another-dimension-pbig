# Supabase Edge Function Setup Guide
## Agent Chat Functionaliteit

Deze guide helpt je stap voor stap de Agent Chat functionaliteit op te zetten met Supabase Edge Functions.

---

## 📋 Wat je nodig hebt

- ✅ Supabase account (heb je al)
- ✅ Supabase CLI geïnstalleerd
- ✅ OpenAI API key (voor AI antwoorden)

---

## STAP 1: Supabase CLI Installeren

### Windows (PowerShell als Administrator):

```powershell
# Download Supabase CLI
irm https://raw.githubusercontent.com/supabase/cli/main/install.ps1 | iex
```

### Verificatie:
```powershell
supabase --version
# Moet versie nummer tonen
```

---

## STAP 2: Inloggen op Supabase

```powershell
supabase login
```

Dit opent je browser om in te loggen. Nadat je ingelogd bent, krijg je een access token.

---

## STAP 3: Project Linken

```powershell
# Ga naar je project directory
cd "C:\Users\thijs\OneDrive - Another Dimension\Documenten\Projects\another-dimension-pbig"

# Link naar je Supabase project
supabase link --project-ref eiynfrgezfyncoqaemfr
```

Je wordt gevraagd om je database wachtwoord (die je bij setup hebt ingesteld).

---

## STAP 4: OpenAI API Key Verkrijgen

1. Ga naar https://platform.openai.com/api-keys
2. Maak een nieuwe API key aan
3. Kopieer de key (deze zie je maar 1 keer!)

**Kosten:** ~$0.002 per gesprek met gpt-4o-mini (super goedkoop)

---

## STAP 5: Secrets Configureren

**VEILIGE METHODE** - Gebruik een `.env` file:

1. **Maak een `.env` file** in je project root (staat al in `.gitignore`!)
2. **Vul je keys in** in `.env`:

```env
OPENAI_API_KEY=sk-proj-jouwkeyhere
SERVICE_ROLE_KEY=jouwsecretkey
SUPABASE_PROJECT_REF=eiynfrgezfyncoqaemfr
```

3. **Deploy secrets vanuit `.env` file**:

```powershell
# Deploy alle secrets vanuit .env file
supabase secrets set --project-ref eiynfrgezfyncoqaemfr --env-file .env
```

**⚠️ BELANGRIJK:**
- `.env` wordt NIET gecommit naar Git (staat in `.gitignore`)
- Zo blijven je keys privé en uit je terminal history
- Never run commands met keys erin - altijd via `.env` file!

---

## STAP 6: Database Kolommen Toevoegen

We voegen 2 kolommen toe aan de `games` tabel:
1. **status** - om game lifecycle te beheren (active/completed)
2. **visited_agents** - om bij te houden welke agents bezocht zijn

```sql
-- Run dit in Supabase SQL Editor (https://supabase.com/dashboard/project/eiynfrgezfyncoqaemfr/sql/new):

ALTER TABLE games 
ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'active',
ADD COLUMN IF NOT EXISTS visited_agents INTEGER[] DEFAULT '{}';

COMMENT ON COLUMN games.status IS 'Game status: active, completed, abandoned';
COMMENT ON COLUMN games.visited_agents IS 'Array van agent IDs die bezoeker heeft bezocht';

-- Index voor snelle queries
CREATE INDEX IF NOT EXISTS idx_games_status ON games(status);
CREATE INDEX IF NOT EXISTS idx_games_created_at ON games(created_at DESC);
```

**Verificatie:**
```sql
-- Check of kolommen toegevoegd zijn
SELECT column_name, data_type, column_default 
FROM information_schema.columns 
WHERE table_name = 'games' 
AND column_name IN ('status', 'visited_agents');
```

---

## STAP 7: Edge Function Deployen

```powershell
# Deploy de agent-chat functie
supabase functions deploy agent-chat

# Als alles goed gaat zie je:
# ✓ Deployed Function agent-chat
# URL: https://eiynfrgezfyncoqaemfr.supabase.co/functions/v1/agent-chat
```

---

## STAP 8: Chat Interface Hosten

Je hebt 2 opties:

### Optie A: GitHub Pages (Gratis, Makkelijk)

1. Upload `chat-interface.html` naar GitHub repo
2. Hernoem naar `index.html`
3. Enable GitHub Pages in repo settings
4. Chat draait op: `https://yourusername.github.io/reponame/`

### Optie B: Supabase Storage (Ook Gratis)

```powershell
# Upload naar Supabase Storage
supabase storage create chat-interface
supabase storage upload chat-interface chat-interface.html
```

Maak bucket public en gebruik de URL.

---

## STAP 9: Chat Interface Configureren

Open `chat-interface.html` en pas deze regels aan:

```javascript
// Regel 160-161:
const SUPABASE_URL = 'https://eiynfrgezfyncoqaemfr.supabase.co';
const SUPABASE_ANON_KEY = 'JE_PUBLISHABLE_KEY_HIER'; // Haal uit Supabase Dashboard
```

Je publishable key vind je: **Project Settings > API Keys > Publishable key** (was: anon key)

---

## STAP 10: NFC Tags Programmeren

Nu kun je NFC tags programmeren met URLs zoals:

```
https://jouwchatdomain.com/?game=ABC123&agent=1
https://jouwchatdomain.com/?game=ABC123&agent=2
https://jouwchatdomain.com/?game=ABC123&agent=3
```

**Let op:** De `game` parameter moet de huidige actieve `game_id` zijn. Dit moet dynamisch zijn!

---

## STAP 11: Testen

### Test 1: Check of function live is
```powershell
curl "https://eiynfrgezfyncoqaemfr.supabase.co/functions/v1/agent-chat"
```

### Test 2: Test met POST request
```powershell
curl -X POST "https://eiynfrgezfyncoqaemfr.supabase.co/functions/v1/agent-chat" `
  -H "Authorization: Bearer JE_PUBLISHABLE_KEY" `
  -H "Content-Type: application/json" `
  -d '{\"game_id\":\"1\",\"agent_id\":1,\"message\":\"Hallo\"}'
```

Als het werkt krijg je een AI response terug!

---

## STAP 12: Game ID Dynamisch Maken

**Probleem:** NFC tags zijn statisch, maar game_id verandert elk spel.

**Oplossing:** We maken een redirect URL:

```
NFC Tag URL: https://chat.com/agent/1
                ↓
         Redirect naar: https://chat.com/?game=ABC123&agent=1
```

Dit kun je implementeren met:
1. Een simpel Flask endpoint die current game_id ophaalt
2. Of een Supabase Edge Function die redirect doet

---

## 🎉 Klaar!

Nu heb je:
- ✅ Edge Function die draait
- ✅ AI chat antwoorden
- ✅ Chat interface
- ✅ Database logging
- ✅ Alles voor ~$0 per maand (binnen free tiers)

---

## 🐛 Troubleshooting

### Error: "Function not found"
```powershell
# Check of function deployed is
supabase functions list
```

### Error: "OpenAI API key not configured"
```powershell
# Check secrets
supabase secrets list
```

### Error: "CORS error"
De Edge Function heeft al CORS headers. Check of je de juiste SUPABASE_ANON_KEY (publishable key) gebruikt.

### Logs bekijken:
```powershell
supabase functions logs agent-chat
```

---

## 💡 Volgende Stappen

1. **Scenario hints toevoegen** aan `scenario_hints` tabel
2. **Agent karakters verrijken** met betere prompts
3. **Chat history** tonen in interface
4. **NFC redirect** implementeren voor dynamische game_id
5. **Hint tracking** visualiseren op laptop scherm

---

## 📚 Nuttige Links

- [Supabase Edge Functions Docs](https://supabase.com/docs/guides/functions)
- [OpenAI API Docs](https://platform.openai.com/docs)
- [Supabase CLI Reference](https://supabase.com/docs/reference/cli)

---

**Vragen? Check de logs of stuur me de error!**
