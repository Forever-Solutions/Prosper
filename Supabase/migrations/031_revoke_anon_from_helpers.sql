-- Prosper MVP — Migration 031: correct 030's mistargeted revoke
--
-- Verified directly via pg_proc.proacl: current_builder_id, current_profile_id, is_admin,
-- is_reviewer_or_admin, is_opportunity_staff, has_role, get_current_builder,
-- get_builder_context each carried an explicit `anon=X` grant that predates 030 — Supabase
-- applies ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT EXECUTE ON FUNCTIONS TO anon,
-- authenticated at creation time, which is a direct per-role grant, not a PUBLIC grant.
-- 030 revoked from `public` (the pseudo-role), which does not touch a direct `anon` grant.
-- This revokes from `anon` specifically, leaving `authenticated` untouched.

revoke execute on function public.current_profile_id() from anon;
revoke execute on function public.current_builder_id() from anon;
revoke execute on function public.has_role(public.user_role) from anon;
revoke execute on function public.is_admin() from anon;
revoke execute on function public.is_reviewer_or_admin() from anon;
revoke execute on function public.is_opportunity_staff() from anon;
revoke execute on function public.get_current_builder() from anon;
revoke execute on function public.get_builder_context() from anon;
