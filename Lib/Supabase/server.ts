// Prosper — Supabase server client (Server Components, Route Handlers, Server Actions)
// Source: Supabase Database Migration & RLS Specification v1.0, Section 52 ("The service
// role must remain server-side... The service role is not a substitute for proper
// authorization"). This client uses the anon key and the caller's session — it is still
// subject to RLS. It is NOT the service-role client; use lib/supabase/service.ts for the
// small set of trusted server operations (Forge/Thread/Cadence writes) that must
// deliberately bypass RLS.

import { createServerClient, type CookieOptions } from "@supabase/ssr";
import { cookies } from "next/headers";
import type { Database } from "@/types/database";

export function createClient() {
  const cookieStore = cookies();

  return createServerClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        get(name: string) {
          return cookieStore.get(name)?.value;
        },
        set(name: string, value: string, options: CookieOptions) {
          try {
            cookieStore.set({ name, value, ...options });
          } catch {
            // Called from a Server Component with no request/response context.
            // Safe to ignore when middleware.ts is refreshing the session.
          }
        },
        remove(name: string, options: CookieOptions) {
          try {
            cookieStore.set({ name, value: "", ...options });
          } catch {
            // See note above.
          }
        },
      },
    }
  );
}
