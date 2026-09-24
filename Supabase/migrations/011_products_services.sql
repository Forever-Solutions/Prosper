-- Prosper MVP — Migration 011: products_services
-- Source: Supabase Database Migration & RLS Specification v1.0, Section 15

create table public.products_services (
  id uuid primary key default gen_random_uuid(),
  enterprise_id uuid not null references public.enterprises(id) on delete cascade,
  name text not null,
  description text,
  category text,
  price_range text,
  capacity text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
