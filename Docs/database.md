# Database

Full schema definition: `supabase/migrations/`. Canonical source:
`Supabase Database Migration & RLS Specification v1.0`.

## Migration order (as implemented — see docs/decisions.md D-001 for why this differs
## from the spec's Section 59 numbering after 022)

| # | File | Purpose |
|---|------|---------|
| 001 | extensions | `pgcrypto` |
| 002 | enums | all 15 enum types |
| 003 | timestamp_function | `set_updated_at()` |
| 004–022 | one table per file | profiles → audit_log, per spec Sections 7–26 |
| 023 | user_roles | supporting table, see D-001 |
| 024 | indexes | per spec Section 28 |
| 025 | updated_at_triggers | per spec Section 29 |
| 026 | functions | ownership/role helpers + get_current_builder/get_builder_context/create_context_event + handle_new_user |
| 027 | rls | RLS policies for every table + column-protection triggers |
| 028 | seed | demo-only partners/opportunities, clearly marked |

## RLS test matrix — NOT YET RUN

Section 61 of the Supabase spec requires each of these to be explicitly tested against a
real Supabase project before this foundation is considered done. **None of these have
been run** (no live Supabase project existed when this scaffold was produced):

- Builder A reads own profile → allow
- Builder A reads Builder B profile → deny
- Builder A edits own enterprise → allow
- Builder A edits Builder B enterprise → deny
- Builder A reads own context → allow
- Builder A reads Builder B context → deny
- Builder reads a published+verified opportunity → allow
- Builder reads a draft opportunity → deny
- Builder reads a published-but-unverified opportunity → deny (the AND, not OR — this is
  the single most important case to test; see the comment above
  `opportunities_select_published_verified` in `027_rls.sql`)
- Builder creates own action → allow
- Builder modifies another Builder's action → deny
- Builder reads another Builder's conversation → deny
- Builder edits audit log → deny
- Admin verifies opportunity → allow
- Builder attempts to verify opportunity → deny
- **ID substitution attack** (Section 62): authenticate as Builder A, attempt every
  sensitive query using Builder B's UUID in place of Builder A's — every one must still
  fail, proving the database enforces ownership rather than trusting client-supplied IDs.

Do not mark Phase 1 complete until every row in this table has actually been run against
a live project and passes.

## Column-level protections

Three `BEFORE UPDATE` triggers exist because plain RLS row policies cannot express
"this specific column may only change under these conditions": see
`enforce_constraint_transition`, `enforce_skill_verification`, and
`enforce_recommendation_update` in `027_rls.sql`, and D-002/D-003 in `docs/decisions.md`.
