-- Prosper MVP — Migration 027: Row Level Security
-- Source: Supabase Database Migration & RLS Specification v1.0, Sections 31-51, 61
-- Every policy uses the ownership-chain helper functions from 026_functions.sql rather
-- than trusting any client-supplied ID (Section 32).

-- =========================================================================
-- Enable RLS everywhere (Section 31)
-- =========================================================================
alter table public.profiles enable row level security;
alter table public.builders enable row level security;
alter table public.enterprises enable row level security;
alter table public.builder_contexts enable row level security;
alter table public.goals enable row level security;
alter table public.constraints enable row level security;
alter table public.skills enable row level security;
alter table public.products_services enable row level security;
alter table public.partners enable row level security;
alter table public.opportunities enable row level security;
alter table public.opportunity_eligibility enable row level security;
alter table public.recommendations enable row level security;
alter table public.actions enable row level security;
alter table public.follow_ups enable row level security;
alter table public.outcomes enable row level security;
alter table public.conversations enable row level security;
alter table public.messages enable row level security;
alter table public.context_events enable row level security;
alter table public.audit_log enable row level security;
alter table public.user_roles enable row level security;

-- =========================================================================
-- profiles (Section 33)
-- =========================================================================
create policy "profiles_select_own" on public.profiles
  for select using (user_id = auth.uid());

create policy "profiles_select_staff" on public.profiles
  for select using (public.is_reviewer_or_admin());

create policy "profiles_insert_own" on public.profiles
  for insert with check (user_id = auth.uid());

create policy "profiles_update_own" on public.profiles
  for update using (user_id = auth.uid()) with check (user_id = auth.uid());

-- =========================================================================
-- builders (Section 34)
-- =========================================================================
create policy "builders_select_own" on public.builders
  for select using (profile_id = public.current_profile_id());

create policy "builders_select_staff" on public.builders
  for select using (public.is_reviewer_or_admin());

create policy "builders_insert_own" on public.builders
  for insert with check (profile_id = public.current_profile_id());

create policy "builders_update_own" on public.builders
  for update using (profile_id = public.current_profile_id())
  with check (profile_id = public.current_profile_id());

-- =========================================================================
-- enterprises (Section 35)
-- =========================================================================
create policy "enterprises_select_own" on public.enterprises
  for select using (builder_id = public.current_builder_id());

create policy "enterprises_select_staff" on public.enterprises
  for select using (public.is_reviewer_or_admin());

create policy "enterprises_insert_own" on public.enterprises
  for insert with check (builder_id = public.current_builder_id());

create policy "enterprises_update_own" on public.enterprises
  for update using (builder_id = public.current_builder_id())
  with check (builder_id = public.current_builder_id());

create policy "enterprises_delete_own" on public.enterprises
  for delete using (builder_id = public.current_builder_id());

-- =========================================================================
-- builder_contexts (Section 36) — Builders may read/create/update, never delete.
-- =========================================================================
create policy "builder_contexts_select_own" on public.builder_contexts
  for select using (builder_id = public.current_builder_id());

create policy "builder_contexts_select_staff" on public.builder_contexts
  for select using (public.is_reviewer_or_admin());

create policy "builder_contexts_insert_own" on public.builder_contexts
  for insert with check (builder_id = public.current_builder_id());

create policy "builder_contexts_update_own" on public.builder_contexts
  for update using (builder_id = public.current_builder_id())
  with check (builder_id = public.current_builder_id());

-- =========================================================================
-- goals (Section 37) — inherit access through builder_contexts
-- =========================================================================
create policy "goals_select_own" on public.goals
  for select using (
    builder_context_id in (
      select id from public.builder_contexts where builder_id = public.current_builder_id()
    )
  );

create policy "goals_insert_own" on public.goals
  for insert with check (
    builder_context_id in (
      select id from public.builder_contexts where builder_id = public.current_builder_id()
    )
  );

create policy "goals_update_own" on public.goals
  for update using (
    builder_context_id in (
      select id from public.builder_contexts where builder_id = public.current_builder_id()
    )
  );

create policy "goals_delete_own" on public.goals
  for delete using (
    builder_context_id in (
      select id from public.builder_contexts where builder_id = public.current_builder_id()
    )
  );

-- =========================================================================
-- constraints (Section 38) — status transitions are further restricted by
-- enforce_constraint_transition() below; RLS only establishes ownership.
-- =========================================================================
create policy "constraints_select_own" on public.constraints
  for select using (
    builder_context_id in (
      select id from public.builder_contexts where builder_id = public.current_builder_id()
    )
  );

create policy "constraints_select_staff" on public.constraints
  for select using (public.is_reviewer_or_admin());

-- Builders may only directly create constraints they are stating themselves.
-- AI-identified / admin-identified constraints are written by trusted server code
-- using the service role, which bypasses RLS entirely.
create policy "constraints_insert_own_stated" on public.constraints
  for insert with check (
    source = 'builder_stated'
    and builder_context_id in (
      select id from public.builder_contexts where builder_id = public.current_builder_id()
    )
  );

create policy "constraints_update_own" on public.constraints
  for update using (
    builder_context_id in (
      select id from public.builder_contexts where builder_id = public.current_builder_id()
    )
  );

create policy "constraints_update_staff" on public.constraints
  for update using (public.is_reviewer_or_admin());

-- =========================================================================
-- skills (Section 39) — verified flag is protected by a trigger, not RLS alone.
-- =========================================================================
create policy "skills_select_own" on public.skills
  for select using (builder_id = public.current_builder_id());

create policy "skills_select_staff" on public.skills
  for select using (public.is_reviewer_or_admin());

create policy "skills_insert_own" on public.skills
  for insert with check (builder_id = public.current_builder_id());

create policy "skills_update_own" on public.skills
  for update using (builder_id = public.current_builder_id())
  with check (builder_id = public.current_builder_id());

create policy "skills_delete_own" on public.skills
  for delete using (builder_id = public.current_builder_id());

-- =========================================================================
-- products_services (Section 40) — inherit access from the owning enterprise
-- =========================================================================
create policy "products_services_select_own" on public.products_services
  for select using (
    enterprise_id in (select id from public.enterprises where builder_id = public.current_builder_id())
  );

create policy "products_services_select_staff" on public.products_services
  for select using (public.is_reviewer_or_admin());

create policy "products_services_insert_own" on public.products_services
  for insert with check (
    enterprise_id in (select id from public.enterprises where builder_id = public.current_builder_id())
  );

create policy "products_services_update_own" on public.products_services
  for update using (
    enterprise_id in (select id from public.enterprises where builder_id = public.current_builder_id())
  );

create policy "products_services_delete_own" on public.products_services
  for delete using (
    enterprise_id in (select id from public.enterprises where builder_id = public.current_builder_id())
  );

-- =========================================================================
-- partners (Section 43) — readable by any authenticated user for opportunity
-- discovery context; writes restricted to opportunity staff.
-- =========================================================================
create policy "partners_select_authenticated" on public.partners
  for select using (auth.role() = 'authenticated');

create policy "partners_insert_staff" on public.partners
  for insert with check (public.is_opportunity_staff());

create policy "partners_update_staff" on public.partners
  for update using (public.is_opportunity_staff());

-- =========================================================================
-- opportunities (Section 41-42) — THE MOST SECURITY-CRITICAL POLICY IN THIS FILE.
-- A Builder may read an opportunity only when BOTH status = 'published' AND
-- verification_status = 'verified'. This must remain an AND, never an OR.
-- =========================================================================
create policy "opportunities_select_published_verified" on public.opportunities
  for select using (
    status = 'published' and verification_status = 'verified'
  );

create policy "opportunities_select_staff" on public.opportunities
  for select using (public.is_opportunity_staff());

create policy "opportunities_insert_staff" on public.opportunities
  for insert with check (public.is_opportunity_staff());

create policy "opportunities_update_staff" on public.opportunities
  for update using (public.is_opportunity_staff());

create policy "opportunities_delete_admin" on public.opportunities
  for delete using (public.is_admin());

-- =========================================================================
-- opportunity_eligibility (Section 41-42) — visible only when the parent
-- opportunity is visible.
-- =========================================================================
create policy "opportunity_eligibility_select_published_verified" on public.opportunity_eligibility
  for select using (
    opportunity_id in (
      select id from public.opportunities
      where status = 'published' and verification_status = 'verified'
    )
  );

create policy "opportunity_eligibility_select_staff" on public.opportunity_eligibility
  for select using (public.is_opportunity_staff());

create policy "opportunity_eligibility_insert_staff" on public.opportunity_eligibility
  for insert with check (public.is_opportunity_staff());

create policy "opportunity_eligibility_update_staff" on public.opportunity_eligibility
  for update using (public.is_opportunity_staff());

create policy "opportunity_eligibility_delete_staff" on public.opportunity_eligibility
  for delete using (public.is_opportunity_staff());

-- =========================================================================
-- recommendations (Section 44) — Builders read their own only; they cannot
-- create arbitrary recommendations. Status updates (viewed/saved/dismissed)
-- are further restricted by enforce_recommendation_update() below.
-- =========================================================================
create policy "recommendations_select_own" on public.recommendations
  for select using (builder_id = public.current_builder_id());

create policy "recommendations_select_staff" on public.recommendations
  for select using (public.is_reviewer_or_admin());

create policy "recommendations_update_own_status" on public.recommendations
  for update using (builder_id = public.current_builder_id())
  with check (builder_id = public.current_builder_id());

-- =========================================================================
-- actions (Section 45)
-- =========================================================================
create policy "actions_select_own" on public.actions
  for select using (builder_id = public.current_builder_id());

create policy "actions_select_staff" on public.actions
  for select using (public.is_reviewer_or_admin());

create policy "actions_insert_own" on public.actions
  for insert with check (builder_id = public.current_builder_id());

create policy "actions_update_own" on public.actions
  for update using (builder_id = public.current_builder_id())
  with check (builder_id = public.current_builder_id());

-- =========================================================================
-- follow_ups (Section 46) — Builders may only read; Cadence writes through
-- trusted server-side logic using the service role (bypasses RLS).
-- =========================================================================
create policy "follow_ups_select_own" on public.follow_ups
  for select using (
    action_id in (select id from public.actions where builder_id = public.current_builder_id())
  );

create policy "follow_ups_select_staff" on public.follow_ups
  for select using (public.is_reviewer_or_admin());

-- =========================================================================
-- outcomes (Section 47) — Builders may create and read outcomes for their own
-- actions only; outcomes are otherwise immutable from the client.
-- =========================================================================
create policy "outcomes_select_own" on public.outcomes
  for select using (
    action_id in (select id from public.actions where builder_id = public.current_builder_id())
  );

create policy "outcomes_select_staff" on public.outcomes
  for select using (public.is_reviewer_or_admin());

create policy "outcomes_insert_own" on public.outcomes
  for insert with check (
    action_id in (select id from public.actions where builder_id = public.current_builder_id())
  );

-- =========================================================================
-- conversations (Section 48)
-- =========================================================================
create policy "conversations_select_own" on public.conversations
  for select using (builder_id = public.current_builder_id());

create policy "conversations_insert_own" on public.conversations
  for insert with check (builder_id = public.current_builder_id());

create policy "conversations_update_own" on public.conversations
  for update using (builder_id = public.current_builder_id())
  with check (builder_id = public.current_builder_id());

-- =========================================================================
-- messages (Section 49) — a Builder may only insert messages with role='user';
-- assistant/system messages are written server-side with the service role.
-- =========================================================================
create policy "messages_select_own" on public.messages
  for select using (
    conversation_id in (select id from public.conversations where builder_id = public.current_builder_id())
  );

create policy "messages_insert_own" on public.messages
  for insert with check (
    role = 'user'
    and conversation_id in (select id from public.conversations where builder_id = public.current_builder_id())
  );

-- =========================================================================
-- context_events (Section 50) — read-only from the client; all writes go
-- through public.create_context_event() or trusted server-side service-role code.
-- =========================================================================
create policy "context_events_select_own" on public.context_events
  for select using (builder_id = public.current_builder_id());

create policy "context_events_select_staff" on public.context_events
  for select using (public.is_reviewer_or_admin());

-- =========================================================================
-- audit_log (Section 51) — no Builder access at all; admin read-only.
-- Inserts happen exclusively through trusted server/service-role code.
-- =========================================================================
create policy "audit_log_select_admin" on public.audit_log
  for select using (public.is_admin());

-- =========================================================================
-- user_roles — admins manage roles; a user may see their own role assignments.
-- =========================================================================
create policy "user_roles_select_own" on public.user_roles
  for select using (user_id = auth.uid());

create policy "user_roles_select_admin" on public.user_roles
  for select using (public.is_admin());

create policy "user_roles_insert_admin" on public.user_roles
  for insert with check (public.is_admin());

create policy "user_roles_update_admin" on public.user_roles
  for update using (public.is_admin());

create policy "user_roles_delete_admin" on public.user_roles
  for delete using (public.is_admin());

-- =========================================================================
-- Column-level protections that RLS row policies cannot express on their own
-- =========================================================================

-- Section 38: constraint status may only move possible->confirmed, possible->rejected,
-- or confirmed->resolved when a non-staff Builder performs the update. Staff (reviewer/
-- admin) and the service role are exempt so admin correction workflows still work.
create or replace function public.enforce_constraint_transition()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if public.is_reviewer_or_admin() then
    return new;
  end if;

  if old.status = new.status then
    return new;
  end if;

  if (old.status = 'possible' and new.status in ('confirmed', 'rejected'))
     or (old.status = 'confirmed' and new.status = 'resolved') then
    return new;
  end if;

  raise exception 'Invalid constraint status transition: % -> %', old.status, new.status;
end;
$$;

create trigger trg_enforce_constraint_transition
  before update on public.constraints
  for each row execute function public.enforce_constraint_transition();

-- Section 39: a Builder must never self-promote skills.verified to true.
create or replace function public.enforce_skill_verification()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if public.is_reviewer_or_admin() then
    return new;
  end if;

  if new.verified is distinct from old.verified then
    new.verified = old.verified;
  end if;

  return new;
end;
$$;

create trigger trg_enforce_skill_verification
  before update on public.skills
  for each row execute function public.enforce_skill_verification();

-- Section 44: a Builder may only move a recommendation into viewed/saved/dismissed/
-- acted_on, and may not alter reason, confidence, opportunity_id or generated_by.
create or replace function public.enforce_recommendation_update()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if public.is_reviewer_or_admin() then
    return new;
  end if;

  if new.opportunity_id is distinct from old.opportunity_id
     or new.builder_id is distinct from old.builder_id
     or new.reason is distinct from old.reason
     or new.confidence is distinct from old.confidence
     or new.generated_by is distinct from old.generated_by then
    raise exception 'Builders may only update recommendation status';
  end if;

  if new.status not in ('viewed', 'saved', 'dismissed', 'acted_on') then
    raise exception 'Invalid Builder-initiated recommendation status: %', new.status;
  end if;

  return new;
end;
$$;

create trigger trg_enforce_recommendation_update
  before update on public.recommendations
  for each row execute function public.enforce_recommendation_update();
