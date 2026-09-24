// Prosper — Supabase service-role client
// Source: Supabase Database Migration & RLS Specification v1.0, Section 52; Master
// Implementation Prompt Section 19-20.
//
// DANGER: this client BYPASSES ROW LEVEL SECURITY ENTIRELY. It must be used only inside
// trusted server-side code that has already performed its own authentication and
// authorization checks (Forge diagnosis/matching writes, Thread context-event writes,
// Cadence follow-up/outcome writes, admin verification actions). It must NEVER be
// imported into any file that can execute in the browser, and SUPABASE_SERVICE_ROLE_KEY
// must never be exposed to the client (see .env.example).

import "server-only";
import { createClient as createSupabaseClient } from "@supabase/supabase-js";
import type { Database } from "@/types/database";

export function createServiceClient() {
  return createSupabaseClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_ROLE_KEY!,
    { auth: { autoRefreshToken: false, persistSession: false } }
  );
}
