-- Prosper MVP — Migration 023: user_roles
-- SUPPORTING TABLE NOT ENUMERATED IN THE SUPABASE SPEC'S CORE ENTITY LIST.
-- Justification (per Master Implementation Prompt Section 16: "If implementation requires
-- a minor supporting table, document why it exists"):
--
-- The Supabase spec (Section 27, "User Role Storage") requires that the user's application
-- role be available securely to server-side authorization and RLS policies, and explicitly
-- forbids placing administrative authority in a client-editable column. A dedicated table
-- with no client insert/update/delete policy (service-role writes only) is the smallest
-- reliable way to satisfy that requirement. See docs/decisions.md, entry D-001.
--
-- This migration is inserted here (renumbering the spec's 023-027 to 024-028) because the
-- RLS policies in 026_rls.sql and the helper functions in 027_functions.sql depend on it.

create table public.user_roles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  role public.user_role not null default 'builder',
  granted_by uuid references auth.users(id),
  created_at timestamptz not null default now(),
  unique (user_id, role)
);
