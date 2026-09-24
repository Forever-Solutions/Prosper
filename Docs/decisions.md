# Implementation decisions

Per Master Implementation Prompt Section 52 ("When requirements are ambiguous... choose
the smallest reasonable implementation, document the decision") and Section 53 ("When you
see a better idea... do not silently replace the approved design").

---

### D-000 — Naming & Brand Architecture Canon not supplied

**Status:** non-blocking, open.

The source-of-truth hierarchy (Master Implementation Prompt Section 3; Application & AI
Service Contract Specification Section 2) lists "Prosper Naming & Brand Architecture
Canon" as the highest-authority document. It was not included in the documents supplied
to the implementer. This is **non-blocking** for Phase 0/1 (no naming/brand decisions
were required to stand up auth, migrations, RLS, or the application shell). It becomes
relevant starting Phase 2+ for user-facing copy, visual identity, and any
Forge/PARIS/Thread/Cadence naming conventions in UI text. Until supplied, copy in this
codebase follows only the tone guidance already present in the Master Prompt (Section 37)
and the conversational examples in the PRD/Build Spec. Revisit all user-facing strings
once the Canon is available.

---

### D-001 — Added `user_roles` table (not in the Supabase spec's core entity list)

**Status:** resolved.

The Supabase spec (Section 27) requires that application role be resolvable securely by
RLS and server-side authorization, explicitly forbidding a client-editable column, but
does not specify the exact table shape. A dedicated `user_roles` table
(`user_id`, `role`, `granted_by`, `created_at`), writable only by `is_admin()`, is the
smallest addition that satisfies this requirement without inventing a broader
permissions system. This is the "minor supporting table" case anticipated by Master
Implementation Prompt Section 16.

**Consequence:** the migration numbering diverges from the Supabase spec's Section 59
listing after 022. The spec's 023–027 became this repo's 024–028, with `023_user_roles.sql`
inserted before indexes, and `026_functions.sql` moved before `027_rls.sql` (the spec listed
functions after RLS at 025/026, but the RLS policies here depend on the ownership-chain
and role helper functions, so functions must be created first). See
`supabase/migrations/` for the actual order.

---

### D-002 — Constraint status transitions and skill self-verification enforced by triggers, not application code alone

**Status:** resolved, flagged for review.

Sections 38–39 of the Supabase spec say the application "should prevent" invalid
constraint status transitions and self-verified skills, without mandating a database-
level mechanism. Two `BEFORE UPDATE` triggers (`enforce_constraint_transition`,
`enforce_skill_verification`) were added so these rules hold even if a future code path
forgets to check them — RLS alone cannot express "this column may only change under
these conditions." Master Implementation Prompt Section 17 ("Do not move all business
logic into PostgreSQL merely because Supabase supports it... belongs primarily in the
application/Forge layer") is a reasonable objection to this; the counter-argument is that
these two rules are security-adjacent (preventing a Builder from marking their own skill
"verified", preventing silent confirmation of AI inference) rather than ordinary business
logic, which is why they were pushed to the database. Reasonable to revisit.

---

### D-003 — Recommendation status updates restricted by trigger

**Status:** resolved.

Section 44 of the Supabase spec says Builders may read their own recommendations and
"must not be able to create arbitrary recommendations," but does not explicitly address
whether Builders may update a recommendation's `status` (e.g., marking one "saved" or
"dismissed" — a capability the Application & AI Service Contract Specification's Role
Responsibilities section grants: Builder "Can:... save opportunities"). An RLS `update`
policy plus a trigger (`enforce_recommendation_update`) was added: Builders may change
`status` only to `viewed`/`saved`/`dismissed`/`acted_on`, and may not touch `reason`,
`confidence`, `opportunity_id`, or `generated_by`.

---

### D-004 — Automatic profile creation implemented as a database trigger

**Status:** resolved, flagged for review.

Section 30 of the Supabase spec calls this the "preferred MVP approach" only as an
alternative to an application/server-action approach, and warns that "failed profile
creation must not leave the authentication system in an unusable state." Implemented as
`handle_new_user()` with an exception handler that swallows failures rather than aborting
`auth.users` insert. **This means a failed profile insert fails silently at the database
level** — the application layer must still verify/backfill the profile on first
authenticated request (see the comment in `026_functions.sql`). This has not been
load-tested; if profile creation via trigger proves unreliable in practice, switch to the
server-action approach the spec lists first.
