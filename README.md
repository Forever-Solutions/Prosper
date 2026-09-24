# Prosper

Economic Opportunity & Enterprise Enablement Ecosystem — Forever Solutions Technologies
Nigeria Limited. Powered by Forge. Initial geographic context: Nasarawa, Nigeria.

> Know where you are. Know what is holding you back. Know what can help. Know what to do next.

This repository implements the Prosper MVP per the canonical specification package (see
`docs/`). **This is Phase 0/1 only** — repository foundation and technical foundation
(Next.js + Supabase + auth + migrations + RLS + a running application shell). It does
**not** yet implement PARIS, Thread, Forge or Cadence — those are Phase 3 onward.

## Status

- [x] Phase 0 — repository, configuration, docs, environment
- [x] Phase 1 — Next.js + Supabase + auth + migrations + RLS + running shell
- [ ] Phase 2 — Builder / Enterprise / Builder Context
- [ ] Phase 3 — PARIS
- [ ] Phase 4 — Forge diagnosis
- [ ] Phase 5 — Opportunities
- [ ] Phase 6 — Actions / Cadence
- [ ] Phase 7 — Admin
- [ ] Phase 8 — Hardening
- [ ] Phase 9 — Pilot

## Setup

See `docs/setup.md`.

## Architecture

See `docs/architecture.md` for the service-boundary map and `docs/database.md` for the
schema and RLS model.

## Canonical documents

This implementation is governed by, in source-of-truth order:

1. Prosper Naming & Brand Architecture Canon — **not yet supplied to the implementer**;
   see `docs/decisions.md`, D-000.
2. Prosper MVP PRD v1.0
3. Technical Architecture & Implementation Plan v1.0
4. MVP Build Specification v1.0
5. Supabase Database Migration & RLS Specification v1.0
6. Application & AI Service Contract Specification v1.0
7. Claude Master Implementation Prompt v1.0

Do not reinterpret these documents when extending this codebase. If you find a
contradiction, add it to `docs/decisions.md` rather than resolving it silently.
