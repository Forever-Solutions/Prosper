-- Prosper MVP — Migration 008: goals
-- Source: Supabase Database Migration & RLS Specification v1.0, Section 12

create table public.goals (
  id uuid primary key default gen_random_uuid(),
  builder_context_id uuid not null references public.builder_contexts(id) on delete cascade,
  title text not null,
  description text,
  priority integer,
  status text not null default 'active',
  target_date date,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
