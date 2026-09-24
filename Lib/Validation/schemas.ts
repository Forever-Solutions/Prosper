// Prosper — AI output validation schemas
// Source: Application & AI Service Contract Specification v1.0, Sections 7, 11, 14, 17,
// 21, 25, 32.
//
// "The application must validate this output against a schema... Invalid AI output must
// not be written to the database." Every schema here corresponds 1:1 to a "Conceptual"
// type in that document. Nothing here is authoritative on its own — passing schema
// validation is necessary but not sufficient; business-rule and safety validation
// (documented alongside each Forge/PARIS service module) still apply before persistence.

import { z } from "zod";

const confidenceLevel = z.enum(["high", "medium", "low"]);

// Section 14 — ContextUpdate
export const contextUpdateSchema = z.object({
  field: z.string(),
  previousValue: z.unknown().optional(),
  newValue: z.unknown(),
  source: z.enum(["builder", "conversation", "ai_inference", "admin", "system"]),
  confidence: confidenceLevel.optional(),
  requiresConfirmation: z.boolean(),
});
export type ContextUpdate = z.infer<typeof contextUpdateSchema>;

// Section 11 — PARIS output
export const parisResponseSchema = z.object({
  message: z.string(),
  extractedContext: z
    .array(
      z.object({
        field: z.string(),
        value: z.unknown(),
        confidence: confidenceLevel,
        source: z.literal("user_message"),
      })
    )
    .optional(),
  questions: z.array(z.string()).optional(),
  suggestedUpdates: z.array(contextUpdateSchema).optional(),
  requiresConfirmation: z.boolean().optional(),
  nextStep: z
    .object({
      type: z.enum([
        "continue_conversation",
        "confirm_context",
        "review_diagnosis",
        "view_opportunities",
        "create_action",
      ]),
    })
    .optional(),
});
export type ParisResponse = z.infer<typeof parisResponseSchema>;

// Section 17-19 — Forge diagnosis output
export const diagnosisResultSchema = z.object({
  possibleConstraints: z.array(
    z.object({
      type: z.string(),
      title: z.string(),
      description: z.string(),
      source: z.enum([
        "builder_stated",
        "ai_identified",
        "admin_identified",
        "system_observed",
      ]),
      confidence: confidenceLevel,
      evidence: z.array(z.string()),
      severity: z.enum(["low", "medium", "high"]).optional(),
    })
  ),
  explanation: z.string(),
  questionsToConfirm: z.array(z.string()).optional(),
});
export type DiagnosisResult = z.infer<typeof diagnosisResultSchema>;

// Section 21 — opportunity matching output
export const opportunityMatchSchema = z.object({
  opportunityId: z.string().uuid(),
  relevance: z.enum(["high", "medium", "low"]),
  reasons: z.array(z.string()),
  possibleGaps: z.array(z.string()),
  eligibilityConfidence: confidenceLevel,
  suggestedNextStep: z.string(),
});
export type OpportunityMatch = z.infer<typeof opportunityMatchSchema>;

// Section 25 — action planning output
export const actionPlanSchema = z.object({
  opportunityId: z.string().uuid().optional(),
  actions: z.array(
    z.object({
      title: z.string(),
      description: z.string(),
      priority: z.enum(["low", "medium", "high"]),
      suggestedDueDate: z.string().optional(),
      dependency: z.string().optional(),
    })
  ),
});
export type ActionPlan = z.infer<typeof actionPlanSchema>;
