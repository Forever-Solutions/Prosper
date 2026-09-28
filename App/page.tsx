import Link from "next/link";

// Public landing page. Section 27 (Canon): Prosper begins with "Tell me about what
// you're building," not a wall of forms — the copy here reflects that from the first
// screen, without yet implementing the conversational flow (that is Phase 3 / PARIS).
export default function HomePage() {
  return (
    <main className="container">
      <h1>Prosper</h1>
      <p>
        Know where you are. Know what is holding you back. Know what can help.
        Know what to do next.
      </p>
      <p>
        <Link href="/signup" className="btn">Tell Prosper about your business</Link>
      </p>
      <p>
        Already here? <Link href="/login">Log in</Link>
      </p>
    </main>
  );
}
