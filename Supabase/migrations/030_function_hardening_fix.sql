-- Prosper MVP — Migration 030: correct 029's incomplete revoke
--
-- 029 revoked EXECUTE from `anon, authenticated` specifically, but every function is
-- also granted EXECUTE via Postgres's default `PUBLIC` grant, and a PUBLIC grant applies
-- to every role regardless of per-role revokes. The security advisor re-run after 029
-- proved this: identical findings, because PUBLIC still granted access. Revoking from
-- PUBLIC directly closes this for real.

revoke execute on function public.create_context_event(uuid, text, text, jsonb) from public;
revoke execute on function public.enforce_constraint_transition() from public;
revoke execute on function public.enforce_skill_verification() from public;
revoke execute on function public.enforce_recommendation_update() from public;
revoke execute on function public.handle_new_user() from public;

-- Also revoke PUBLIC (i.e. close anon access) from the 8 identity/role helpers. They are
-- harmless if called by anon (they only ever resolve auth.uid()'s own state, never take a
-- client-supplied ID), but there is no reason an unauthenticated request needs them either.
revoke execute on function public.current_profile_id() from public;
revoke execute on function public.current_builder_id() from public;
revoke execute on function public.has_role(public.user_role) from public;
revoke execute on function public.is_admin() from public;
revoke execute on function public.is_reviewer_or_admin() from public;
revoke execute on function public.is_opportunity_staff() from public;
revoke execute on function public.get_current_builder() from public;
revoke execute on function public.get_builder_context() from public;

-- Re-grant those 8 to `authenticated` only: RLS policies evaluate as that role and call
-- these functions directly, so this grant must exist or every policy using them breaks.
grant execute on function public.current_profile_id() to authenticated;
grant execute on function public.current_builder_id() to authenticated;
grant execute on function public.has_role(public.user_role) to authenticated;
grant execute on function public.is_admin() to authenticated;
grant execute on function public.is_reviewer_or_admin() to authenticated;
grant execute on function public.is_opportunity_staff() to authenticated;
grant execute on function public.get_current_builder() to authenticated;
grant execute on function public.get_builder_context() to authenticated;
