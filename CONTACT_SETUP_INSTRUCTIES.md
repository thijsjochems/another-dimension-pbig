# Contact Formulier Setup Instructies

## 📋 Overzicht
Het systeem bestaat uit 3 delen:
1. **Supabase tabel** (✅ aangemaakt)
2. **HTML formulier** (✅ gereed op /contact)
3. **n8n workflow** (⏳ moet je importeren)

---

## 🚀 n8n Workflow Importeren

### Stap 1: Import de workflow
1. Open je n8n instance
2. Klik rechtsboven op "Add workflow" → "Import from File"
3. Upload `n8n-contact-workflow.json`
4. De workflow wordt geladen met 5 nodes:
   - Webhook (trigger)
   - Supabase Insert
   - Send Email (naar lead)
   - Notify Thijs (naar jou)
   - Respond to Webhook

### Stap 2: Configureer Supabase credentials
1. Klik op de **"Supabase Insert"** node
2. Klik bij Credentials op "Create New"
3. Vul in:
   - **Supabase URL**: https://jouw-project.supabase.co
   - **Service Key**: Haal deze op uit Supabase → Settings → API → service_role key (⚠️ geheim!)
4. Test de connectie en sla op

### Stap 3: Configureer Email credentials (SMTP)
Je hebt twee opties:

#### Optie A: Gmail SMTP (makkelijkste)
1. Ga naar je Google Account → Security
2. Schakel "2-Step Verification" in
3. Ga naar "App passwords" → Generate new app password
4. Kies "Mail" en "Other" (typ: n8n)
5. In n8n bij de **"Send Email"** node:
   - Host: `smtp.gmail.com`
   - Port: `587`
   - User: `thijs@anotherdimension.nl`
   - Password: [Het app password dat Google gaf]
   - Security: `STARTTLS`

#### Optie B: Outlook/Microsoft 365 SMTP
1. In n8n:
   - Host: `smtp.office365.com`
   - Port: `587`
   - User: `thijs@anotherdimension.nl`
   - Password: [Je normale password]
   - Security: `STARTTLS`

⚠️ **BELANGRIJK**: Gebruik hetzelfde SMTP account voor BEIDE email nodes:
- "Send Email" (naar lead)
- "Notify Thijs" (naar jou)

### Stap 4: Activeer de webhook
1. Klik op de **"Webhook"** node
2. Je ziet bovenaan een URL zoals:
   ```
   https://jouw-n8n.com/webhook/beurs-contact
   ```
3. **KOPIEER DEZE URL**
4. Klik rechtsboven op "Activate" om de workflow actief te zetten

### Stap 5: Update het formulier met webhook URL
1. Open `templates/contact-form.html`
2. Zoek regel ~320:
   ```javascript
   const response = await fetch('YOUR_N8N_WEBHOOK_URL_HERE', {
   ```
3. Vervang `'YOUR_N8N_WEBHOOK_URL_HERE'` door je webhook URL:
   ```javascript
   const response = await fetch('https://jouw-n8n.com/webhook/beurs-contact', {
   ```
4. Sla op

---

## 🧪 Testen

### Test de flow end-to-end:
1. Ga naar `http://127.0.0.1:5000/contact`
2. Vul het formulier in met testgegevens
3. Verstuur

**Als het goed gaat:**
- ✅ Je ziet "Bedankt!" op het scherm
- ✅ Data staat in Supabase `contacts` tabel
- ✅ Lead krijgt bevestigingsmail
- ✅ Jij krijgt notificatie email

### Troubleshooting:
- **"Er ging iets fout"** → Check n8n workflow logs (klik op workflow → Executions)
- **Geen email ontvangen** → Check SPAM folder, of test SMTP credentials in n8n
- **Data niet in Supabase** → Check service key en tabel naam ("contacts")

---

## 🎨 QR Code Genereren

Zodra alles werkt, maak je een QR code aan:

### Online tools:
- https://www.qr-code-generator.com/
- https://www.qrcode-monkey.com/

### QR Code URL:
```
https://jouw-domein.nl/contact
```
Of als je de app lokaal draait op de beurs tablet:
```
http://localhost:5000/contact
```

### QR Code toevoegen aan service pagina's:
1. Download de QR code als PNG (zwart-wit of in AD kleuren: #54FCBC)
2. Sla op in `static/images/qr-contact.png`
3. Update de 4 service pagina templates:
   - powerbi-portfolio.html
   - powerbi-training.html
   - ai-automation.html
   - ai-training.html

Zoek in elke template:
```html
<div class="qr-placeholder">
    QR CODE<br>PLACEHOLDER
</div>
```

Vervang door:
```html
<img src="{{ url_for('static', filename='images/qr-contact.png') }}" 
     alt="Scan voor contact" 
     style="width: 200px; height: 200px;">
```

---

## 📊 Leads Bekijken

### In Supabase:
1. Ga naar Table Editor → `contacts`
2. Zie alle leads met timestamps en interesses

### Snelle rapportage:
```sql
-- Aantal leads per dag
SELECT * FROM contacts_summary;

-- Alle leads van vandaag
SELECT * FROM contacts 
WHERE DATE(created_at) = CURRENT_DATE
ORDER BY created_at DESC;

-- Top interesses
SELECT 
    COUNT(CASE WHEN interesse_powerbi_training THEN 1 END) as pbi_training,
    COUNT(CASE WHEN interesse_ai_training THEN 1 END) as ai_training,
    COUNT(CASE WHEN interesse_samenwerken THEN 1 END) as samenwerken
FROM contacts;
```

---

## 🔒 Security Checklist

- ✅ Supabase RLS enabled (alleen authenticated users kunnen lezen)
- ✅ n8n webhook public (nodig voor formulier submit)
- ✅ SMTP credentials veilig opgeslagen in n8n
- ✅ Email validatie in formulier + database constraint
- ⚠️ **Service key NOOIT committen naar git** (staat niet in code, alleen in n8n)

---

## 📱 URLs

- **Formulier**: http://127.0.0.1:5000/contact
- **n8n Webhook**: [krijg je na activeren workflow]
- **Supabase Dashboard**: https://supabase.com/dashboard

---

## 🎯 Volgende Stappen (Optioneel)

1. **Custom domein** voor de app (bijv. beurs.anotherdimension.nl)
2. **CRM integratie** via n8n (Pipedrive, HubSpot, etc.)
3. **WhatsApp notificaties** via n8n + Twilio
4. **Auto-response na X dagen** als je nog niet hebt gereageerd
5. **Lead scoring** op basis van interesses

---

Klaar! 🚀
