import { describe, expect, it } from "vitest";
import { diagnosisResultSchema, parisResponseSchema } from "@/lib/validation/schemas";

// These tests exist to prove the AI-output validation pipeline (Application & AI Service
// Contract Specification v1.0, Section 32) actually rejects malformed model output rather
// than silently persisting it — the single most important safety property of Forge/PARIS.

describe("diagnosisResultSchema", () => {
  it("accepts a well-formed diagnosis result", () => {
    const result = diagnosisResultSchema.safeParse({
      possibleConstraints: [
        {
          type: "infrastructure",
          title: "Unreliable electricity",
          description: "Generator fuel costs may be limiting production capacity.",
          source: "ai_identified",
          confidence: "medium",
          evidence: ["Builder mentioned frequent power outages"],
          severity: "medium",
        },
      ],
      explanation: "Based on what you've told me, power reliability may be a factor.",
    });

    expect(result.success).toBe(true);
  });

  it("rejects a diagnosis with an invalid source value", () => {
    const result = diagnosisResultSchema.safeParse({
      possibleConstraints: [
        {
          type: "infrastructure",
          title: "Unreliable electricity",
          description: "x",
          source: "forge_guessed", // not in the allowed enum — must fail closed
          confidence: "medium",
          evidence: [],
        },
      ],
      explanation: "x",
    });

    expect(result.success).toBe(false);
  });

  it("rejects a diagnosis missing required evidence array", () => {
    const result = diagnosisResultSchema.safeParse({
      possibleConstraints: [
        {
          type: "infrastructure",
          title: "Unreliable electricity",
          description: "x",
          source: "ai_identified",
          confidence: "medium",
          // evidence intentionally omitted
        },
      ],
      explanation: "x",
    });

    expect(result.success).toBe(false);
  });
});

describe("parisResponseSchema", () => {
  it("accepts a minimal valid PARIS response", () => {
    const result = parisResponseSchema.safeParse({
      message: "Tell me about what you're building.",
    });

    expect(result.success).toBe(true);
  });

  it("rejects an unknown nextStep type (must fail closed on new/unlisted steps)", () => {
    const result = parisResponseSchema.safeParse({
      message: "x",
      nextStep: { type: "submit_application" },
    });

    expect(result.success).toBe(false);
  });
});
