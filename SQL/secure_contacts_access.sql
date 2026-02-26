-- Harden contacts table so public users cannot access it directly.
-- Use this after deploying the contact-submit Edge Function.

begin;

-- Ensure RLS is enabled
alter table if exists public.contacts enable row level security;

-- Remove previously broad/open policies if they exist
DROP POLICY IF EXISTS "Enable insert for all users" ON public.contacts;
DROP POLICY IF EXISTS "Enable read for authenticated users only" ON public.contacts;
DROP POLICY IF EXISTS "contacts_insert_public" ON public.contacts;
DROP POLICY IF EXISTS "contacts_select_authenticated" ON public.contacts;
DROP POLICY IF EXISTS "contacts_no_direct_anon" ON public.contacts;
DROP POLICY IF EXISTS "contacts_no_direct_authenticated" ON public.contacts;

-- Block direct table access for public roles
revoke all on table public.contacts from anon;
revoke all on table public.contacts from authenticated;

-- Optional: explicitly deny all through RLS too (defense in depth)
create policy "contacts_no_direct_anon"
  on public.contacts
  for all
  to anon
  using (false)
  with check (false);

create policy "contacts_no_direct_authenticated"
  on public.contacts
  for all
  to authenticated
  using (false)
  with check (false);

commit;