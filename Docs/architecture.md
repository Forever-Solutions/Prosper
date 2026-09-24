# Architecture

Full detail: `Technical Architecture & Implementation Plan v1.0`,
`Application & AI Service Contract Specification v1.0`.

## Service boundaries (Section 29 of the Application & AI Service Contract spec)

```
lib/
  supabase/    client.ts (browser, RLS-bound) · server.ts (SSR, RLS-bound) ·
               service.ts (service-role, BYPASSES RLS — trusted server code only)
  paris/       [Phase 3] conversation, prompts, schemas
  thread/      [Phase 3] context retrieval/update, context events
  forge/       [Phase 4-5] diagnosis, matching, recommendations, actions
  cadence/     [Phase 6] follow-ups, outcomes
  opportunities/ [Phase 5] queries, matching, verification
  auth/        permission helpers
  validation/  schemas.ts — Zod schemas for every AI ↔ application contract
```

`lib/paris`, `lib/thread`, `lib/forge`, `lib/cadence`, `lib/opportunities`, `lib/auth` are
currently empty directories — placeholders for Phase 2 onward. Only `lib/supabase` and
`lib/validation` have real content in this Phase 0/1 scaffold.

## Request pipeline (every AI-powered operation, once built)

Auth check → Authorization check → Input validation → Context retrieval (Thread) → AI
request (PARIS/Forge) → AI response → Schema validation (`lib/validation/schemas.ts`) →
Business rule validation → Safety validation → Human confirmation where required →
Database persistence → Context event → User response.

No AI response is written to the database without passing schema validation first — see
`tests/schemas.test.ts` for what "fail closed" looks like for a malformed diagnosis or
PARIS response.

## What Phase 0/1 does NOT include

PARIS, Thread, Forge and Cadence are not implemented. `/dashboard` is a placeholder that
only proves authenticated access to the caller's own profile works under RLS. See the
README status checklist.
