-- Prosper MVP — Migration 019: conversations
-- Source: Supabase Database Migration & RLS Specification v1.0, Section 23

create table public.conversations (
  id uuid primary key default gen_random_uuid(),
  builder_id uuid not null references public.builders(id) on delete cascade,
  session_type public.conversation_session_type not null default 'general',
  started_at timestamptz not null default now(),
  ended_at timestamptz,
  created_at timestamptz not null default now()
);
