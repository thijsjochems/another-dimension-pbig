import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

const MAX_BODY_SIZE_BYTES = 16 * 1024

interface ContactPayload {
  naam?: string
  bedrijf?: string
  email?: string
  telefoon?: string
  interesse_powerbi_training?: boolean
  interesse_powerbi_rapportage?: boolean
  interesse_ai_training?: boolean
  interesse_ai_automation?: boolean
  interesse_samenwerken?: boolean
  interesse_overig?: string
  bron?: string
  website?: string
}

function sanitizeText(input: unknown, maxLength: number): string {
  if (typeof input !== 'string') return ''
  return input.replace(/\s+/g, ' ').trim().slice(0, maxLength)
}

function normalizeEmail(input: unknown): string {
  return sanitizeText(input, 320).toLowerCase()
}

function isValidEmail(email: string): boolean {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  const allowedOrigins = (Deno.env.get('ALLOWED_ORIGINS') ?? '')
    .split(',')
    .map((part) => part.trim())
    .filter((part) => part.length > 0)

  const requestOrigin = req.headers.get('origin') ?? ''
  if (allowedOrigins.length > 0 && requestOrigin && !allowedOrigins.includes(requestOrigin)) {
    return new Response(JSON.stringify({ success: false, error: 'Origin not allowed' }), {
      status: 403,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  }

  if (req.method !== 'POST') {
    return new Response(JSON.stringify({ success: false, error: 'Method not allowed' }), {
      status: 405,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  }

  try {
    const contentLength = Number(req.headers.get('content-length') ?? '0')
    if (contentLength > MAX_BODY_SIZE_BYTES) {
      return new Response(JSON.stringify({ success: false, error: 'Payload te groot' }), {
        status: 413,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    const body: ContactPayload = await req.json()

    const honeypot = sanitizeText(body.website, 200)
    if (honeypot) {
      return new Response(JSON.stringify({ success: true }), {
        status: 200,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    const naam = sanitizeText(body.naam, 120)
    const bedrijf = sanitizeText(body.bedrijf, 120) || 'Onbekend'
    const email = normalizeEmail(body.email)
    const telefoon = sanitizeText(body.telefoon, 40)
    const interesse_overig = sanitizeText(body.interesse_overig, 1200)
    const bron = sanitizeText(body.bron, 80) || 'github_qr'

    if (!naam || naam.length < 2) {
      return new Response(JSON.stringify({ success: false, error: 'Naam is verplicht' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    if (!isValidEmail(email)) {
      return new Response(JSON.stringify({ success: false, error: 'Ongeldig e-mailadres' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    const hasInterest = Boolean(
      body.interesse_powerbi_training ||
      body.interesse_powerbi_rapportage ||
      body.interesse_ai_training ||
      body.interesse_ai_automation ||
      body.interesse_samenwerken ||
      interesse_overig
    )

    if (!hasInterest) {
      return new Response(JSON.stringify({ success: false, error: 'Interesse ontbreekt' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? ''
    const serviceRoleKey = Deno.env.get('SERVICE_ROLE_KEY') ?? ''

    if (!supabaseUrl || !serviceRoleKey) {
      throw new Error('Missing Supabase env vars')
    }

    const supabase = createClient(supabaseUrl, serviceRoleKey)

    const fiveMinutesAgoIso = new Date(Date.now() - 5 * 60 * 1000).toISOString()
    const { data: recentLead, error: recentLeadError } = await supabase
      .from('contacts')
      .select('id')
      .eq('email', email)
      .gte('created_at', fiveMinutesAgoIso)
      .limit(1)
      .maybeSingle()

    if (recentLeadError) {
      throw recentLeadError
    }

    if (recentLead) {
      return new Response(JSON.stringify({ success: false, error: 'Probeer het over een paar minuten opnieuw' }), {
        status: 429,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    const { error: insertError } = await supabase
      .from('contacts')
      .insert({
        naam,
        bedrijf,
        email,
        telefoon,
        interesse_powerbi_training: Boolean(body.interesse_powerbi_training),
        interesse_powerbi_rapportage: Boolean(body.interesse_powerbi_rapportage),
        interesse_ai_training: Boolean(body.interesse_ai_training),
        interesse_ai_automation: Boolean(body.interesse_ai_automation),
        interesse_samenwerken: Boolean(body.interesse_samenwerken),
        interesse_overig,
        bron,
      })

    if (insertError) {
      throw insertError
    }

    return new Response(JSON.stringify({ success: true }), {
      status: 200,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  } catch (error) {
    console.error('contact-submit error', error)
    return new Response(JSON.stringify({ success: false, error: 'Serverfout' }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  }
})