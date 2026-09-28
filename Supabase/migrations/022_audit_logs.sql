-- Prosper MVP — Migration 022: audit_log
-- Source: Supabase Database Migration & RLS Specification v1.0, Section 26
-- Audit logs are append-only: no update/delete policy is ever granted (see 025_rls.sql).

create table public.audit_log (
  id uuid primary key default gen_random_uuid(),
  actor_id uuid references auth.users(id),
  actor_role public.user_role,
  action text not null,
  entity_type text not null,
  entity_id uuid,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);
