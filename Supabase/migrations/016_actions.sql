-- Prosper MVP — Migration 016: actions
-- Source: Supabase Database Migration & RLS Specification v1.0, Section 20

create table public.actions (
  id uuid primary key default gen_random_uuid(),
  builder_id uuid not null references public.builders(id) on delete cascade,
  opportunity_id uuid references public.opportunities(id) on delete set null,
  recommendation_id uuid references public.recommendations(id) on delete set null,
  title text not null,
  description text,
  status public.action_status not null default 'not_started',
  priority integer,
  due_date timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
