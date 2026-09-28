-- Prosper MVP — Migration 010: skills
-- Source: Supabase Database Migration & RLS Specification v1.0, Section 14

create table public.skills (
  id uuid primary key default gen_random_uuid(),
  builder_id uuid not null references public.builders(id) on delete cascade,
  name text not null,
  level text,
  verified boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
