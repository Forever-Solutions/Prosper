// Prosper — Supabase browser client
// Source: Application & AI Service Contract Specification v1.0, Section 30 (server-side
// AI rule) and Section 4 (application layer contract). This client uses the anon key
// only and is safe to use in Client Components; it is subject to RLS at all times.

import { createBrowserClient } from "@supabase/ssr";
import type { Database } from "@/types/database";

export function createClient() {
  return createBrowserClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  );
}
