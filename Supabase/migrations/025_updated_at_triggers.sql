-- Prosper MVP — Migration 025: updated_at triggers
-- Source: Supabase Database Migration & RLS Specification v1.0, Section 29
-- Applied to every mutable table with an updated_at column. Immutable event/log tables
-- (context_events, audit_log, messages, follow_ups, outcomes, recommendations,
-- opportunity_eligibility) intentionally do not receive this trigger.

create trigger trg_profiles_updated_at before update on public.profiles
  for each row execute function public.set_updated_at();

create trigger trg_builders_updated_at before update on public.builders
  for each row execute function public.set_updated_at();

create trigger trg_enterprises_updated_at before update on public.enterprises
  for each row execute function public.set_updated_at();

create trigger trg_builder_contexts_updated_at before update on public.builder_contexts
  for each row execute function public.set_updated_at();

create trigger trg_goals_updated_at before update on public.goals
  for each row execute function public.set_updated_at();

create trigger trg_constraints_updated_at before update on public.constraints
  for each row execute function public.set_updated_at();

create trigger trg_skills_updated_at before update on public.skills
  for each row execute function public.set_updated_at();

create trigger trg_products_services_updated_at before update on public.products_services
  for each row execute function public.set_updated_at();

create trigger trg_partners_updated_at before update on public.partners
  for each row execute function public.set_updated_at();

create trigger trg_opportunities_updated_at before update on public.opportunities
  for each row execute function public.set_updated_at();

create trigger trg_actions_updated_at before update on public.actions
  for each row execute function public.set_updated_at();
