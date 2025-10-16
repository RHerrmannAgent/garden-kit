---
description: Coordinate on-the-ground execution of the garden plan using tasks.md, supporting docs, and checklists.
---

## User Input

```text
$ARGUMENTS
```

Incorporate user guidance (e.g., “we only have 4 hours today”, “focus on Phase 2”) when planning execution.

## Workflow

1. **Verify readiness**
   - Run `.specify/scripts/powershell/check-prerequisites.ps1 -Json -RequireTasks -IncludeTasks`.
   - If `tasks.md` or `plan.md` missing, instruct the user to complete earlier steps (/speckit.plan, /speckit.tasks).
   - If `FEATURE_DIR/checklists/` exists, scan each checklist and report completion status. If any remain open, ask the user whether to proceed (`yes`/`no`). Halt on “no/stop”.

2. **Load execution context**
   - Read `tasks.md` and group tasks by phase (P0–P4, additional zones if present).
   - From `plan.md`, pull phasing notes, resource plan, and constitution check commentary.
   - From `site-study.md`, gather measurements, hazards, access constraints.
   - From `layout-guide.md`, capture dimensions, materials, and irrigation notes tied to upcoming phases.
   - From `planting-calendar.md` and `care-guide.md`, extract seasonal timing, inputs, and validation checks relevant to the current work window.

3. **Plan the work session**
   - Determine which phases or tasks align with user constraints (time, crew size, weather).
   - For the selected scope:
     * List prerequisites that must already be complete.
     * Identify materials, tools, and documents to stage (include quantities from layout-guide).
     * Surface safety considerations (utilities, slopes, wildlife) from site-study.
     * Highlight observation checkpoints (soil moisture tests, irrigation verification, photo documentation).
   - Mark tasks eligible for parallel work (those tagged `[P]`) and suggest crew assignments.

4. **Execution guidance**
   - Present tasks in the order they should be tackled, grouped by phase.
   - For each task, include:
     * Task ID, description, `[P]` status, zone.
     * Required inputs (materials, tools).
     * Expected duration if available from plan; otherwise classify as short (<30 min), medium, or long (>2h) based on complexity.
     * References to source documents (plan sections, layout-guide pages) so crews can confirm details.
   - Encourage updating `tasks.md` by toggling `- [ ]` to `- [x]` once complete, and adding quick notes (e.g., “completed 2025-04-10, used 6 bags compost”).

5. **Post-session wrap-up**
   - Remind the user to:
     * Record observations or deviations in `care-guide.md` and `site-study.md`.
     * Update budget/labor tracking in plan.md resource table if actuals differ.
     * Capture follow-up tasks for the next session (e.g., lingering `[ ]` items, weather delays).

6. **Report back**
   - Summarize selected phases, total tasks scheduled, parallel opportunities, and key risks.
  - Note any blockers identified (e.g., missing materials, unanswered clarifications).
   - Recommend next commands (e.g., rerun `/speckit.tasks` after major changes, `/speckit.checklist` before the next phase).
