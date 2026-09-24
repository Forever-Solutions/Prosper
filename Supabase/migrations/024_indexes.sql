-- Prosper MVP — Migration 024: indexes
-- Source: Supabase Database Migration & RLS Specification v1.0, Section 28
-- (renumbered from the spec's 023 due to the insertion of 023_user_roles.sql)

create index idx_profiles_user_id on public.profiles(user_id);
create index idx_builders_profile_id on public.builders(profile_id);
create index idx_enterprises_builder_id on public.enterprises(builder_id);
create index idx_enterprises_sector on public.enterprises(sector);
create index idx_enterprises_location on public.enterprises(location);
create index idx_context_builder_id on public.builder_contexts(builder_id);
create index idx_context_enterprise_id on public.builder_contexts(enterprise_id);
create index idx_constraints_context_id on public.constraints(builder_context_id);
create index idx_constraints_status on public.constraints(status);
create index idx_opportunities_status on public.opportunities(status);
create index idx_opportunities_verification on public.opportunities(verification_status);
create index idx_opportunities_deadline on public.opportunities(deadline);
create index idx_recommendations_builder on public.recommendations(builder_id);
create index idx_actions_builder on public.actions(builder_id);
create index idx_actions_status on public.actions(status);
create index idx_actions_due_date on public.actions(due_date);
create index idx_followups_action on public.follow_ups(action_id);
create index idx_followups_scheduled on public.follow_ups(scheduled_for);
create index idx_outcomes_action on public.outcomes(action_id);
create index idx_conversations_builder on public.conversations(builder_id);
create index idx_messages_conversation on public.messages(conversation_id);
create index idx_context_events_builder on public.context_events(builder_id);
create index idx_context_events_created on public.context_events(created_at);
create index idx_audit_entity on public.audit_log(entity_type, entity_id);
create index idx_audit_created on public.audit_log(created_at);
create index idx_user_roles_user_id on public.user_roles(user_id);
