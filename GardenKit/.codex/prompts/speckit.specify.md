---
description: Create a garden vision specification from the gardener’s description.
---

## User Input

```text
$ARGUMENTS
```

You MUST factor in the user’s description (the text that followed `/speckit.specify`). If it is empty, stop with an error.

## Workflow

1. **Initialize plan workspace**
   - Run `.specify/scripts/powershell/create-new-feature.ps1 -Json "$ARGUMENTS"` from the repo root.
   - Parse the JSON once for: `BRANCH_NAME`, `SPEC_FILE`, and `FEATURE_DIR`.
   - All file operations use absolute paths.

2. **Load references**
   - Read `.specify/templates/spec-template.md`.
   - Read `.specify/memory/constitution.md` to align with GardenKit principles (Observe First, Zones with Purpose, Seasonal Rhythm, Stewardship, Grow Incrementally).

3. **Interpret the gardener’s description**
   - Extract goals (produce, leisure, habitat, etc.), aesthetic cues, time/budget constraints, household details, site hints (sun, slope, soil), and resources.
   - Translate ambiguous language into explicit, testable statements. When information is missing but critical, add an item to “Assumptions & Clarifications Needed”.
   - Limit `[NEEDS CLARIFICATION: …]` markers to a maximum of three, prioritized by impact (unsafe assumptions > scope > seasonal success > aesthetics).

4. **Draft the specification**
   - Complete every section of the template. Suggested guidance:
     * **Vision & Priorities**: Capture primary/secondary goals, style, time, and budget clearly.
     * **Site Snapshot**: Populate the table with measurements, sun, soil, water, constraints, existing assets; add bullets for observations.
     * **Zones & Experiences**: Define at least the top three zones with purpose, size, planting themes, infrastructure, success signals, and risks. Ensure each zone stands alone as an incremental step.
     * **Seasonal Rhythm & Crop Plan**: Outline tasks/plantings for each season; include inputs and notes.
     * **Resources & Stewardship**: Cover soil building, water strategy, wildlife/pest approach, tooling, and maintenance cadence.
     * **Assumptions & Clarifications Needed**: Record unanswered questions or assumptions that must be validated later.
     * **Success Criteria**: Provide measurable outcomes (harvest quantities, soil health targets, bloom continuity, labor hours, etc.).
   - Reference constitution principles explicitly when relevant (e.g., note that a phased plan respects “Grow Incrementally”).

5. **Quality check**
   - Ensure no section is left as placeholder text or “TBD”.
   - Verify all tables render correctly, all measurements use consistent units, and wording remains technology-agnostic.
   - Confirm the spec does not prescribe implementation details (materials, tool brands) unless required by the gardener’s request.
   - Validate that each success criterion is observable and time-bound.

6. **Write outputs**
   - Overwrite `SPEC_FILE` with the completed specification (UTF-8).
   - Summarize to the user: branch name, spec file path, notable assumptions/clarifications, and next recommended command (`/speckit.clarify` if clarification markers remain, otherwise `/speckit.plan`).

## Style Notes

- Write for gardeners and collaborators, not for software engineers.
- Keep tone encouraging yet precise; highlight why each decision supports the gardener’s goals.
- Favor metric units unless the user explicitly prefers otherwise; always include units.
- When making assumptions, state the basis (e.g., “Assuming raised beds acceptable because renter restrictions mentioned no digging”).
