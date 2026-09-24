-- Prosper MVP — Migration 005: builders
-- Source: Supabase Database Migration & RLS Specification v1.0, Section 8
-- Note: a profile has one primary Builder record in MVP (enforced by unique profile_id).

create table public.builders (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null unique references public.profiles(id) on delete cascade,
  builder_type public.builder_type not null,
  status text not null default 'active',
  bio text,
  primary_activity text,
  location text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
