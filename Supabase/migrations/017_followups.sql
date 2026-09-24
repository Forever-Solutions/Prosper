-- Prosper MVP — Migration 017: follow_ups
-- Source: Supabase Database Migration & RLS Specification v1.0, Section 21

create table public.follow_ups (
  id uuid primary key default gen_random_uuid(),
  action_id uuid not null references public.actions(id) on delete cascade,
  scheduled_for timestamptz not null,
  channel public.followup_channel not null default 'in_app',
  status public.followup_status not null default 'scheduled',
  message text,
  completed_at timestamptz,
  created_at timestamptz not null default now()
);
