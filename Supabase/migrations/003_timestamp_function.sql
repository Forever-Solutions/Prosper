-- Prosper MVP — Migration 003: updated_at trigger function
-- Source: Supabase Database Migration & RLS Specification v1.0, Section 6

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;
