# Setup

## Prerequisites

- Node.js 20+
- A Supabase project (free tier is sufficient for MVP)
- The Supabase CLI (`npm install -g supabase`) for running migrations

## 1. Install dependencies

```
npm install
```

## 2. Configure environment

```
cp .env.example .env.local
```

Fill in from your Supabase project's Settings → API page:

- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY` — server-side only, never commit, never expose to the
  browser (Master Implementation Prompt Section 20).

`AI_PROVIDER_API_KEY` is not required until Phase 3 (PARIS).

## 3. Run migrations

```
supabase login
supabase link --project-ref <your-project-ref>
supabase db push
```

This applies `supabase/migrations/001` through `028` in order. See `docs/database.md`
for what each migration does and why the numbering diverges slightly from the original
Supabase spec (one supporting table was added — see `docs/decisions.md`, D-001).

## 4. Generate real database types

```
npm run db:types
```

This overwrites the placeholder `types/database.ts` with real generated types once a
live Supabase project exists.

## 5. Run the app

```
npm run dev
```

Visit `http://localhost:3000`. Sign up, confirm the email, and you should land on
`/dashboard` — this is the Phase 1 acceptance check: authentication working end-to-end
under RLS, nothing more.

## 6. Run tests

```
npm test
```

**Note:** the schema-validation tests in `tests/schemas.test.ts` and the RLS test matrix
in `docs/database.md` have not been executed in the environment that produced this
scaffold (no network access to install dependencies or run a live Supabase instance).
Run them yourself before relying on this foundation — do not treat this scaffold as
verified until `npm test` passes and the RLS test matrix has been run against a real
Supabase project.
