-- Prosper MVP — Migration 018: outcomes
-- Source: Supabase Database Migration & RLS Specification v1.0, Section 22

create table public.outcomes (
  id uuid primary key default gen_random_uuid(),
  action_id uuid not null references public.actions(id) on delete cascade,
  type public.outcome_type not null,
  description text,
  result text,
  evidence text,
  created_at timestamptz not null default now()
);
