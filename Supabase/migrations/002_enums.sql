-- Prosper MVP — Migration 002: Enums
-- Source: Supabase Database Migration & RLS Specification v1.0, Section 4

create type public.builder_type as enum (
  'artisan','trader','farmer','service_provider','creative',
  'professional','technology_worker','manufacturer','startup',
  'msme','cooperative','student','other'
);

create type public.enterprise_stage as enum (
  'idea','early','operating','growing','established','scaling'
);

create type public.constraint_source as enum (
  'builder_stated','ai_identified','admin_identified','system_observed'
);

create type public.constraint_status as enum (
  'possible','confirmed','rejected','resolved'
);

create type public.opportunity_status as enum (
  'draft','published','paused','expired','closed'
);

create type public.verification_status as enum (
  'unverified','under_review','verified','rejected','expired'
);

create type public.partner_type as enum (
  'government','financial_institution','corporate','foundation','ngo',
  'development_partner','training_provider','buyer','supplier',
  'professional_service','investor','other'
);

create type public.recommendation_status as enum (
  'generated','viewed','saved','dismissed','acted_on','expired'
);

create type public.action_status as enum (
  'not_started','in_progress','completed','blocked','cancelled'
);

create type public.followup_channel as enum (
  'in_app','email','manual'
);

create type public.followup_status as enum (
  'scheduled','sent','completed','skipped','failed'
);

create type public.outcome_type as enum (
  'completed','partially_completed','unsuccessful','blocked',
  'referred','no_response','other'
);

create type public.conversation_session_type as enum (
  'onboarding','context','diagnosis','opportunity','action','general'
);

create type public.message_role as enum (
  'user','assistant','system'
);

create type public.user_role as enum (
  'builder','opportunity_manager','reviewer','admin'
);
