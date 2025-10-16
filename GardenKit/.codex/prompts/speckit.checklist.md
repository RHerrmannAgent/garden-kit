---
description: Build a purpose-driven garden planning checklist (requirements quality or execution prep) based on user intent.
---

## User Input

```text
$ARGUMENTS
```

Interpret the user’s request (e.g., “Spring planting day prep”, “Irrigation safety review”). If not specified, default to “Garden Plan Readiness”.

## Workflow

1. **Locate context**
   - Run `.specify/scripts/powershell/check-prerequisites.ps1 -Json` to obtain `FEATURE_DIR` and available docs.
   - Required: `spec.md`, `plan.md`. Optional: `tasks.md`, `site-study.md`, `layout-guide.md`, `planting-calendar.md`, `care-guide.md`.

2. **Clarify scope (optional)**
   - If the user input leaves key dimensions unclear (audience, phase, focus area), ask up to two quick questions (multiple choice or ≤5 word answer). Examples:
     * “Who will run this checklist? (A) Home gardener (B) Volunteer crew lead (C) Professional contractor”
     * “Focus on (A) Planning quality (B) Workday execution (C) Safety & compliance”
   - Skip questions when the request is explicit.

3. **Extract signals**
   - From `spec.md`: priorities, success criteria, assumptions needing validation.
   - From `plan.md`: phasing checkpoints, constitution gates, resource plan.
   - From `tasks.md` (if available): specific task IDs relevant to the checklist scope.
   - From supporting docs: measurements, seasonal notes, maintenance cues, hazards.

4. **Define checklist structure**
   - Use `.specify/templates/checklist-template.md`.
   - Title format: `[Checklist Type] Checklist: [GARDEN PLAN NAME]`.
   - Create category headings aligned with scope (e.g., “Pre-Planting Verification”, “Safety & Access”, “Seasonal Readiness”, “Documentation Updates”).
   - Each item is an observable question about the quality/completeness of plan inputs or readiness steps — NOT the execution itself.
   - Number items `CHK###` sequentially.

5. **Craft items**
   - Each checklist entry must reference the relevant document/section (e.g., spec, plan phase, task ID).
   - Focus on confirming that decisions are recorded, measurements exist, risks are mitigated, and constitution principles are satisfied. Examples:
     * “CHK001 Confirm sun exposure notes in `site-study.md` cover each planned bed (Observe Before You Design).”
     * “CHK005 Verify Phase 1 tasks include irrigation pressure test before planting (Steward Soil, Water, and Time).”
     * “CHK009 Has the resource plan documented accessible tool storage for volunteer crew (Zones With Purpose)?”
   - Avoid execution steps like “lay mulch” or “install trellis”.

6. **Write file**
   - Save checklist under `FEATURE_DIR/checklists/` with a descriptive filename (snake_case), e.g., `spring_planting_readiness.md`.
   - Include Purpose, Created date (ISO), and reference to the relevant document(s).

7. **Report**
   - Provide path, item count, categories, and call out any high-risk gaps noticed while compiling the checklist.
   - Suggest who should run the checklist and when (e.g., “Run during Phase 1 gate review before moving to planting”).
