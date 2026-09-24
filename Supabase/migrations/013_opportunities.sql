-- Prosper MVP — Migration 013: opportunities
-- Source: Supabase Database Migration & RLS Specification v1.0, Section 17

create table public.opportunities (
  id uuid primary key default gen_random_uuid(),
  partner_id uuid references public.partners(id) on delete set null,
  title text not null,
  description text not null,
  category text,
  geography text,
  eligibility_summary text,
  requirements text,
  benefit_summary text,
  application_url text,
  contact_information text,
  deadline timestamptz,
  status public.opportunity_status not null default 'draft',
  verification_status public.verification_status not null default 'unverified',
  source_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
