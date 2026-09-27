-- Prosper MVP — Migration 029: function hardening
-- Added in response to the live Supabase security advisor run after 001-028 were applied.
-- Two real findings:
--
-- 1. set_updated_at() had a mutable search_path (WARN) — fixed by pinning it.
--
-- 2. create_context_event(p_builder_id, ...) and the four trigger-only functions
--    (enforce_constraint_transition, enforce_skill_verification,
--    enforce_recommendation_update, handle_new_user) were directly callable by the
--    `anon` and `authenticated` roles via PostgREST RPC (e.g. POST /rest/v1/rpc/
--    create_context_event). create_context_event took a client-supplied builder_id with
--    NO check that the caller owned it — this is precisely the ID-substitution
--    vulnerability the Supabase spec's RLS test matrix (Section 62) exists to catch.
--    None of these five functions are meant to be called directly by a client: the four
--    trigger functions only run as triggers (which does not require caller EXECUTE
--    privilege), and create_context_event is meant to be called only by trusted
--    server-side code using the service-role key. All five have EXECUTE revoked from
--    anon/authenticated below.
--
-- The remaining SECURITY DEFINER helpers (current_profile_id, current_builder_id,
-- has_role, is_admin, is_reviewer_or_admin, is_opportunity_staff, get_current_builder,
-- get_builder_context) are safe to leave callable by `authenticated`: none of them take
-- a client-supplied ID, they only ever resolve information about auth.uid() itself, and
-- RLS policies rely on being able to call them as the `authenticated` role — revoking
-- their EXECUTE grant would break every RLS policy that uses them.

alter function public.set_updated_at() set search_path = public;

revoke execute on function public.create_context_event(uuid, text, text, jsonb) from anon, authenticated;
revoke execute on function public.enforce_constraint_transition() from anon, authenticated;
revoke execute on function public.enforce_skill_verification() from anon, authenticated;
revoke execute on function public.enforce_recommendation_update() from anon, authenticated;
revoke execute on function public.handle_new_user() from anon, authenticated;
