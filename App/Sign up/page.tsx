"use client";

import { useState } from "react";
import { createClient } from "@/lib/supabase/client";

// Phase 1 scope: prove authentication works end-to-end. Onboarding (Phase 2) will
// replace this bare form with the progressive Builder Context conversation described
// in the Product Canon Section 6 and PRD.
export default function SignupPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [status, setStatus] = useState<"idle" | "sending" | "sent" | "error">("idle");
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setStatus("sending");
    setErrorMessage(null);

    const supabase = createClient();
    const { error } = await supabase.auth.signUp({
      email,
      password,
      options: { emailRedirectTo: `${window.location.origin}/auth/callback` },
    });

    if (error) {
      // Error Handling contract (Application & AI Service Contract Spec, Section 33):
      // preserve input, explain simply, never expose internal details.
      setStatus("error");
      setErrorMessage("We couldn't create your account right now. Please try again.");
      return;
    }

    setStatus("sent");
  }

  if (status === "sent") {
    return (
      <main className="container">
        <h1>Check your email</h1>
        <p>We sent a confirmation link to {email}.</p>
      </main>
    );
  }

  return (
    <main className="container">
      <h1>Tell Prosper about your business</h1>
      <form onSubmit={handleSubmit}>
        <label htmlFor="email">Email</label>
        <input
          id="email"
          className="field"
          type="email"
          required
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />
        <label htmlFor="password">Password</label>
        <input
          id="password"
          className="field"
          type="password"
          minLength={8}
          required
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />
        {errorMessage && <p role="alert">{errorMessage}</p>}
        <button className="btn" type="submit" disabled={status === "sending"}>
          {status === "sending" ? "Creating account…" : "Continue"}
        </button>
      </form>
    </main>
  );
}
