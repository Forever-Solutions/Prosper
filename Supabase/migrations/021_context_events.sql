-- Prosper MVP — Migration 021: context_events
-- Source: Supabase Database Migration & RLS Specification v1.0, Section 25

create table public.context_events (
  id uuid primary key default gen_random_uuid(),
  builder_id uuid not null references public.builders(id) on delete cascade,
  event_type text not null,
  source text not null,
  data jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);
