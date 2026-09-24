-- Prosper MVP — Migration 014: opportunity_eligibility
-- Source: Supabase Database Migration & RLS Specification v1.0, Section 18

create table public.opportunity_eligibility (
  id uuid primary key default gen_random_uuid(),
  opportunity_id uuid not null references public.opportunities(id) on delete cascade,
  criterion_type text not null,
  criterion_value text not null,
  operator text not null default 'equals',
  created_at timestamptz not null default now()
);
