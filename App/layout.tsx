import type { Metadata } from "next";
import "./globals.css";

// Tone per Master Implementation Prompt Section 37: human, clear, intelligent,
// trustworthy, accessible, optimistic, Nigerian, professional. Avoid charity/pity
// aesthetics and political campaign aesthetics.
export const metadata: Metadata = {
  title: "Prosper",
  description:
    "Know where you are. Know what is holding you back. Know what can help. Know what to do next.",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
