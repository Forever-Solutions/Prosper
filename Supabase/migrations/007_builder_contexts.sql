-- Prosper MVP — Migration 007: builder_contexts
-- Source: Supabase Database Migration & RLS Specification v1.0, Section 10-11
-- Note: one current primary context per Builder is enforced at the application layer,
-- not the database layer, to preserve room for future historical context_versions (Section 11).

create table public.builder_contexts (
  id uuid primary key default gen_random_uuid(),
  builder_id uuid not null references public.builders(id) on delete cascade,
  enterprise_id uuid references public.enterprises(id) on delete set null,
  summary text,
  current_situation text,
  operating_context text,
  market_context text,
  capability_context text,
  constraint_summary text,
  goal_summary text,
  confidence_score numeric check (confidence_score >= 0 and confidence_score <= 1),
  last_reviewed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
