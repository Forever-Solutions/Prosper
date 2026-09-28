-- Prosper MVP — Migration 006: enterprises
-- Source: Supabase Database Migration & RLS Specification v1.0, Section 9

create table public.enterprises (
  id uuid primary key default gen_random_uuid(),
  builder_id uuid not null references public.builders(id) on delete cascade,
  name text,
  sector text,
  subsector text,
  stage public.enterprise_stage,
  description text,
  location text,
  employee_count integer check (employee_count >= 0),
  formal_status text,
  website text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
