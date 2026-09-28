-- Prosper MVP — Migration 028: seed data
-- Source: Supabase Database Migration & RLS Specification v1.0, Section 58
-- "Seed data exists only for development, testing, demonstrations. It must never be
-- represented as real partner data. Every development opportunity should clearly be
-- marked as DEMO / TEST DATA unless sourced from an actual verified programme."
--
-- Per Master Implementation Prompt Section 54 ("No invented traction"), no fictional
-- Builders, profiles, users, testimonials or pilot results are seeded here. Only
-- clearly-labelled demo partners/opportunities are created, since those are needed to
-- exercise the opportunity-matching pipeline in development before real partner data
-- exists. This migration is safe to skip entirely in a production deployment.

insert into public.partners (name, type, description, verification_status)
values
  (
    'DEMO Partner — Example Enterprise Support Fund',
    'development_partner',
    'DEMO / TEST DATA — not a real institution. Used only to exercise opportunity matching in development.',
    'verified'
  ),
  (
    'DEMO Partner — Example Equipment Finance Cooperative',
    'financial_institution',
    'DEMO / TEST DATA — not a real institution. Used only to exercise opportunity matching in development.',
    'verified'
  );

insert into public.opportunities (
  partner_id, title, description, category, geography,
  eligibility_summary, requirements, benefit_summary,
  status, verification_status, source_url
)
select
  p.id,
  'DEMO — Small Enterprise Equipment Support',
  'DEMO / TEST DATA. A fictional programme used only for development/testing of the '
    || 'opportunity matching pipeline. Do not present this to a real Builder.',
  'equipment',
  'Nasarawa, Nigeria',
  'DEMO ELIGIBILITY: registered or informal MSME with fewer than 10 employees.',
  'DEMO REQUIREMENTS: proof of ongoing trade or production activity.',
  'DEMO BENEFIT: partial equipment financing or in-kind equipment support.',
  'published',
  'verified',
  null
from public.partners p
where p.name = 'DEMO Partner — Example Enterprise Support Fund';
