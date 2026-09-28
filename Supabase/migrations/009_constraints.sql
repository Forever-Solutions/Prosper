-- Prosper MVP — Migration 009: constraints
-- Source: Supabase Database Migration & RLS Specification v1.0, Section 13

create table public.constraints (
  id uuid primary key default gen_random_uuid(),
  builder_context_id uuid not null references public.builder_contexts(id) on delete cascade,
  type text not null,
  title text not null,
  description text,
  source public.constraint_source not null,
  confidence numeric check (confidence >= 0 and confidence <= 1),
  status public.constraint_status not null default 'possible',
  severity integer check (severity >= 1 and severity <= 5),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
