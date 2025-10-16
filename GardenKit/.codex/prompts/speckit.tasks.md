---
description: Produce an actionable, phase-oriented garden task list from the approved plan.
---

## User Input

```text
$ARGUMENTS
```

Honor any user guidance before generating tasks.

## Workflow

1. **Prerequisite check**
   - Run `.specify/scripts/powershell/check-prerequisites.ps1 -Json -RequireTasks:$false -IncludeTasks:$false`.
   - Parse `FEATURE_DIR`, `PLAN_FILE`, and `AVAILABLE_DOCS`. Confirm `plan.md`, `site-study.md`, `layout-guide.md`, `planting-calendar.md`, and `care-guide.md` exist; note which artifacts are missing.

2. **Load context**
   - `plan.md`: phasing roadmap, zone priorities, resource plan, constitution check.
   - `spec.md`: goals, zone descriptions, success criteria, clarifications.
   - `site-study.md`: measurements, hazards, outstanding questions.
   - `layout-guide.md`: dimensions, materials, irrigation notes.
   - `planting-calendar.md`: seasonal sequencing, inputs.
   - `care-guide.md`: maintenance cadence, validation checkpoints.
   - `structures/` (if present): construction details for beds, trellises, water systems.

3. **Draft task structure**
   - Use `.specify/templates/tasks-template.md` as the blueprint.
   - Phases should cover:
     * Phase 0 – Site Study & Clarifications
     * Phase 1 – Infrastructure & Hardscape
     * Phase 2 – Planting Foundations (priority zone)
     * Phase 3 – Habitat & Experience Layers (next zones)
     * Phase 4 – Care, Calibration, Expansion
   - Add extra phases only if the plan introduces additional zones or specialised work (e.g., greenhouse build).

4. **Generate tasks**
   - Every task follows the checklist format: `- [ ] T### [P?] [Zone/Phase] Description with location or document reference`.
   - Derive IDs sequentially (T001, T002…).
   - `[P]` only when tasks can happen simultaneously without resource conflicts.
   - `[Zone/Phase]` uses labels like `P0`, `P1 Z1`, `P3 Z2`, etc.
   - Descriptions must cite physical locations, dimensions, or document updates so another assistant can execute without questions.
   - Include validation/observation tasks (soil moisture checks, irrigation tests, bloom audits) where indicated by the plan or care guide.
   - Update supporting documents as part of the task when the action changes recorded information (e.g., “log spacing in layout-guide.md”).

5. **Dependencies & sequencing**
   - Ensure Phase 0 completes before construction.
   - Hardscape (Phase 1) blocks planting tasks.
  - Zones later than P2 must depend on completion of required infrastructure.
   - Call out parallel opportunities in dedicated sections of the template.

6. **Quality checks**
   - No placeholder text or generic tasks (“Do planting”)—each item must be measurable.
   - Tasks align with constitution principles (observations, purposeful zones, seasonal rhythm, stewardship, phased delivery).
   - Paths and dimensions remain consistent with layout-guide.
   - Use consistent units and language (prefer metric unless plan dictates otherwise).

7. **Write output**
   - Save `tasks.md` (UTF-8) in `FEATURE_DIR`.
   - Reply with:
     * Path to `tasks.md`
     * Task counts per phase
     * Notable parallel opportunities
     * Remaining clarifications (if any)
     * Suggested next step (e.g., begin Phase 0 execution or run `/speckit.checklist` for prep day)
