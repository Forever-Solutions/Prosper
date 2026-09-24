-- Prosper MVP — Migration 020: messages
-- Source: Supabase Database Migration & RLS Specification v1.0, Section 24

create table public.messages (
  id uuid primary key default gen_random_uuid(),
  conversation_id uuid not null references public.conversations(id) on delete cascade,
  role public.message_role not null,
  content text not null,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);
