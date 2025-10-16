---
description: Resolve critical uncertainties in the garden vision (spec.md) before planning begins.
---

## User Input

```text
$ARGUMENTS
```

Weigh any user hints when choosing which clarifications to pursue.

## Purpose

Scan `spec.md` for gaps that would jeopardize phasing, planting choices, or maintenance planning, ask up to three focused questions, and write the answers back into the specification.

## Workflow

1. **Locate spec**
   - Run `.specify/scripts/powershell/check-prerequisites.ps1 -Json -PathsOnly`.
   - Parse `FEATURE_DIR` and `FEATURE_SPEC`.
   - Abort with guidance if the spec is missing (tell user to run `/speckit.specify` first).

2. **Load context**
   - Read `spec.md` and `.specify/memory/constitution.md`.
   - Build a quick assessment of coverage for these garden-specific categories:
     * Site measurements & constraints (dimensions, sun/shade, soil, utilities)
     * Gardener priorities (primary/secondary goals, time, budget)
     * Zone definitions (purpose, size, success signals)
     * Seasonal rhythm (per-season plan, succession, protection)
     * Resource stewardship (water strategy, soil building, wildlife/pest approach)
     * Maintenance commitments (labor hours, care cadence)
     * Assumptions & Clarifications section (presence/quality)

3. **Identify candidates**
   - Choose up to three high-impact uncertainties where assumptions would create rework or violate the constitution.
   - Favor safety, access, or resource limitations over aesthetic preferences.
   - Avoid questions about implementation details (materials, tool brands) unless explicitly required by the gardener.

4. **Ask questions (one at a time)**
   - Format each question for a short response:
     * Multiple choice (2–4 options) **or**
     * “Answer in ≤5 words” directive.
   - Provide enough context within the question so the gardener can answer quickly.
   - After asking, wait for the user’s reply before proceeding. Respect “skip” or “done”.

5. **Integrate answers immediately**
   - Ensure a `## Assumptions & Clarifications Needed` section exists; if missing, create it before the Clarifications list in the template.
   - Add a `### Clarifications (YYYY-MM-DD)` subheading for today if not present.
   - Record each exchange: `- Q: … → A: …`.
   - Update corresponding sections (Vision & Priorities, Site Snapshot, Zones & Experiences, Seasonal Rhythm, Resources, Success Criteria) so the answer removes ambiguity—no duplicate/conflicting statements should remain.
   - Remove or reword any `[NEEDS CLARIFICATION]` markers resolved by the answer.
   - Save the spec after each update.

6. **Validation**
   - Confirm no more than three questions were asked.
   - Ensure updates maintain template structure and uphold constitution principles.
   - Re-run a quick coverage check to confirm the clarified categories are now “Clear”.

7. **Report**
   - Summarize number of questions asked/answered, sections updated, and remaining open issues (if any).
   - Provide a table noting category status (Clear / Still Missing / Deferred).
   - Suggest the next command (usually `/speckit.plan` once critical gaps are resolved).
