import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";

// Phase 1 placeholder: proves that an authenticated request can reach a protected
// route and read the caller's own profile under RLS. Phase 2 replaces this with the
// real Builder Home (Master Implementation Prompt Section 28: "Where am I? What is
// happening? What can help? What should I do next?").
export default async function DashboardPage() {
  const supabase = createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    redirect("/login");
  }

  const { data: profile } = await supabase
    .from("profiles")
    .select("*")
    .eq("user_id", user.id)
    .single();

  return (
    <main className="container">
      <h1>Welcome{profile?.full_name ? `, ${profile.full_name}` : ""}</h1>
      <p>
        Your account is set up. The Builder onboarding conversation (Phase 2/3) will
        appear here next.
      </p>
    </main>
  );
}
