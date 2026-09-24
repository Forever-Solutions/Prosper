-- Prosper MVP — Migration 012: partners
-- Source: Supabase Database Migration & RLS Specification v1.0, Section 16

create table public.partners (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  type public.partner_type not null,
  description text,
  website text,
  contact_information text,
  verification_status public.verification_status not null default 'unverified',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
