-- Prosper MVP — Migration 015: recommendations
-- Source: Supabase Database Migration & RLS Specification v1.0, Section 19

create table public.recommendations (
  id uuid primary key default gen_random_uuid(),
  builder_id uuid not null references public.builders(id) on delete cascade,
  opportunity_id uuid not null references public.opportunities(id) on delete cascade,
  reason text not null,
  confidence numeric check (confidence >= 0 and confidence <= 1),
  status public.recommendation_status not null default 'generated',
  generated_by text not null default 'forge',
  created_at timestamptz not null default now()
);
