---
description: Generate an actionable, season-aware tasks.md for the garden based on existing artefacts.
scripts:
  sh: scripts/bash/check-prerequisites.sh --json --require-tools
  ps: scripts/powershell/check-prerequisites.ps1 -Json -RequireTools
---

## Gardener Input

```text
$ARGUMENTS
```

Use any additional context to adjust task phasing (volunteer availability, deadlines, etc.).

---

## Outline

1. **Setup**  
   - Run `{SCRIPT}` from the repository root.  
   - Parse `FEATURE_DIR` and `AVAILABLE_DOCS`. All paths must be absolute.

2. **Verify Required Artefacts**  
   - Must have: `plan.md`, `spec.md`, `tools.md`.  
   - Optionally use: `site-research.md`, `existing-plant-inventory.md`, `planting-schema.md`, `seasonal-calendar.md`, `monthly-care-plan.md`, `quickstart.md`.  
   - If `tools.md` is missing or incomplete, halt with an error—tasks cannot be generated without a tool inventory.

3. **Extract Planning Context**  
   - From `plan.md`: site preparation, phases, dependencies, seasonal strategy, tool inventory summary.  
   - From `spec.md`: Garden Scenarios with priorities (P1, P2, P3…).  
   - From `existing-plant-inventory.md`: legacy specimens to protect, relocate, or remove; root zone restrictions.  
   - From `planting-schema.md`: specific plants, spacing, succession notes.  
   - From `seasonal-calendar.md`: timing cues and observation checkpoints.  
   - From `monthly-care-plan.md`: detailed month-by-month tasks, responsible parties, contingency notes.  
   - From `tools.md`: availability, quantities, maintenance state (used to flag conflicts).

4. **Generate Tasks**  
   - Use `.gardify/templates/tasks-template.md` as the scaffold.  
   - Convert plan phases into checklist phases (Site Preparation, Structural Build, Scenario phases, Stewardship).  
   - Within each phase, produce tasks in the required format:  
     ```
     - [ ] T### [P?] [Phase/Scenario] Description (location, required tools)
     ```  
   - Indicate required tools in the description. If the tool is in limited supply, note scheduling constraints.  
   - Include validation steps (soil tests, irrigation flushes, observation walks) only when requested in `plan.md` or `spec.md`.

5. **Dependencies & Parallelism**  
   - Explicitly call out dependencies between phases/scenarios.  
   - Suggest parallel opportunities only when tools and space allow (cross-check `tools.md`).  
   - Highlight conflicts (e.g., two tasks requiring the only wheelbarrow) so gardeners can re-sequence or source another tool.

6. **Report**  
   - Provide the path to `tasks.md`, total task count, counts per phase/scenario, and summary of tool conflicts or warnings.  
   - Confirm checklist format compliance.

---

## Task Generation Rules

**CRITICAL**: Tasks must respect physical constraints and tool availability.

### Checklist Format (REQUIRED)

- Checkbox: `- [ ]`
- Task ID: sequential `T001`, `T002`, …
- Optional `[P]` tag when work can run in parallel without tool/location conflicts.
- Phase/Scenario label: `PH0`, `PH1`, `SC1`, etc.
- Description: action + location + required tool(s) + references to artefacts.

Example:
```
- [ ] T010 [P] SC1 Direct sow lettuce in Bed A2 (requires fine rake, uses spacing from planting-schema.md)
```

### Phase Structure

1. **Phase 0 – Site Preparation**: Soil work, grading, path layout, irrigation testing.  
2. **Phase 1 – Structural Build**: Raised beds, pergolas, water systems.  
3. **Scenarios (P1, P2, P3, …)**: One phase per Garden Scenario. Each must be independently observable.  
4. **Stewardship**: Ongoing care, observation logs, maintenance, volunteer coordination.

### Tool Awareness

- Before adding a task, confirm the required tool exists in `tools.md`.  
- If not available, either:  
  - Add a preceding task to acquire/repair the tool.  
  - Flag the tool as missing and halt for gardener input.  
- When a tool is scarce, stagger tasks or mark them as mutually exclusive.

### Timing & Seasonality

- Align tasks with `seasonal-calendar.md` and the detailed `monthly-care-plan.md`.  
- Note best-by dates (e.g., “Complete before last frost”, “Perform after soil warms to 10°C”).  
- Include observation tasks to verify success criteria (pollinator counts, harvest weights).

### Safety & Stewardship

- Honour protections from `existing-plant-inventory.md` (root zones, preservation notes).  
- Incorporate safety reminders from `quickstart.md` or constitution (PPE, wildlife etiquette).  
- Log clean-up tasks and updates to `tools.md` when equipment is serviced or stored.

---

## Reporting Expectations

When the command finishes:
- Print the absolute path to `tasks.md`.  
- Summarise task totals, tool conflicts, and first-phase readiness.  
- Highlight any unresolved clarifications preventing implementation.  
- Confirm readiness for `/gardenkit.implement`.
