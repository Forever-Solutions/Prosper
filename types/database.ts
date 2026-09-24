// Placeholder Supabase database types.
//
// Once a real Supabase project exists, replace this file by running:
//   npx supabase login
//   npx supabase link --project-ref <project-ref>
//   npm run db:types
//
// Until then this minimal hand-written type unblocks the typed client in
// lib/supabase/{client,server,service}.ts without lying about a full schema.

export type Database = {
  public: {
    Tables: Record<string, { Row: Record<string, unknown> }>;
    Enums: Record<string, string>;
  };
};
