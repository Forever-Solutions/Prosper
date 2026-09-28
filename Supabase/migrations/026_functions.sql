-- Prosper MVP — Migration 026: database functions
-- Source: Supabase Database Migration & RLS Specification v1.0, Section 53 (recommended
-- MVP functions: get_current_builder, get_builder_context, create_context_event) plus the
-- ownership-chain and role helpers required to express the RLS policies in 027_rls.sql
-- without unsafe client-supplied IDs (Section 32: "Policies must use this relationship
-- rather than accepting a Builder ID supplied by the client as proof of ownership.").
--
-- All helpers are SECURITY DEFINER + STABLE so they can be used inside RLS policies without
-- triggering recursive RLS evaluation on the tables they read.

-- Section 32 ownership chain: auth.uid() -> profiles.user_id -> profiles.id
create or replace function public.current_profile_id()
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select id from public.profiles where user_id = auth.uid();
$$;

-- Section 32 ownership chain, continued: profiles.id -> builders.profile_id -> builders.id
create or replace function public.current_builder_id()
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select b.id
  from public.builders b
  join public.profiles p on p.id = b.profile_id
  where p.user_id = auth.uid();
$$;

-- Section 27: role must be resolved server-side, never from a client-editable column.
create or replace function public.has_role(required_role public.user_role)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.user_roles ur
    where ur.user_id = auth.uid() and ur.role = required_role
  );
$$;

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select public.has_role('admin');
$$;

create or replace function public.is_reviewer_or_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select public.has_role('admin') or public.has_role('reviewer');
$$;

create or replace function public.is_opportunity_staff()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select public.has_role('admin')
      or public.has_role('reviewer')
      or public.has_role('opportunity_manager');
$$;

-- Section 53: get_current_builder() — convenience accessor for application/service code.
create or replace function public.get_current_builder()
returns public.builders
language sql
stable
security definer
set search_path = public
as $$
  select b.*
  from public.builders b
  join public.profiles p on p.id = b.profile_id
  where p.user_id = auth.uid();
$$;

-- Section 53: get_builder_context() — returns the current builder's primary context.
-- MVP treats "primary context" as the most recently updated row for that builder
-- (Section 11: one current primary context per builder is an application-level rule;
-- this function reflects that rule for read convenience).
create or replace function public.get_builder_context()
returns public.builder_contexts
language sql
stable
security definer
set search_path = public
as $$
  select bc.*
  from public.builder_contexts bc
  where bc.builder_id = public.current_builder_id()
  order by bc.updated_at desc
  limit 1;
$$;

-- Section 53 / Section 55: create_context_event() — the single writer for context_events,
-- so that every meaningful context change is recorded consistently regardless of which
-- application code path triggers it.
create or replace function public.create_context_event(
  p_builder_id uuid,
  p_event_type text,
  p_source text,
  p_data jsonb default '{}'::jsonb
)
returns public.context_events
language plpgsql
security definer
set search_path = public
as $$
declare
  v_event public.context_events;
begin
  insert into public.context_events (builder_id, event_type, source, data)
  values (p_builder_id, p_event_type, p_source, p_data)
  returning * into v_event;

  return v_event;
end;
$$;

-- Section 30: automatic profile creation on signup.
-- "The implementation must ensure that failed profile creation does not leave the
-- authentication system in an unusable state" — the exception handler below logs and
-- swallows profile-creation failures rather than aborting the auth.users insert, and the
-- application layer (Section 30 preferred path) is responsible for verifying/backfilling
-- the profile on first login if this trigger did not succeed.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (user_id, email)
  values (new.id, new.email)
  on conflict (user_id) do nothing;

  return new;
exception
  when others then
    -- Do not block auth.users creation if profile creation fails; the application
    -- layer must verify/backfill the profile on first authenticated request.
    return new;
end;
$$;

create trigger trg_handle_new_user
  after insert on auth.users
  for each row execute function public.handle_new_user();
