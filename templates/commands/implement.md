---
description: Execute the garden plan by following every task in tasks.md with tool and safety validation.
scripts:
  sh: scripts/bash/check-prerequisites.sh --json --require-tasks --include-tasks --require-tools
  ps: scripts/powershell/check-prerequisites.ps1 -Json -RequireTasks -IncludeTasks -RequireTools
---

## Gardener Input

```text
$ARGUMENTS
```

Incorporate any special instructions (weather window, volunteer availability, accessibility requirements) before beginning.

---

## Outline

1. **Run `{SCRIPT}`**  
   - Execute from the repository root.  
   - Parse `FEATURE_DIR` and `AVAILABLE_DOCS`. All paths must be absolute.

2. **Checklist Review**  
   - If `FEATURE_DIR/checklists/` exists, evaluate each checklist:  
     - Count total, completed, and incomplete items.  
     - Display a table similar to:  
       ```
       | Checklist | Total | Completed | Incomplete | Status |
       |-----------|-------|-----------|------------|--------|
       | soil-health.md | 14 | 14 | 0 | ✅ PASS |
       | safety.md      | 9  | 6  | 3 | ⚠️ FAIL |
       ```  
   - If any checklist has incomplete items, pause and ask the gardener whether to continue. Respect their decision (`yes` to proceed, `no`/`stop` to halt).

3. **Load Execution Context**  
   - Required: `tasks.md`, `plan.md`, `tools.md`.  
   - Optional (use when present): `spec.md`, `site-research.md`, `existing-plant-inventory.md`, `planting-schema.md`, `seasonal-calendar.md`, `monthly-care-plan.md`, `quickstart.md`.  
   - Parse tool availability to prevent conflicts and honour preservation notes from the plant inventory.

4. **Tool & Safety Verification**  
   - Before each phase, confirm required tools exist and are ready.  
   - If a task requires a missing tool, stop and prompt the gardener to update `tools.md` or adjust the plan.  
   - Reinforce PPE and safety reminders from the constitution and `quickstart.md`.

5. **Execute Tasks Phase by Phase**  
   - Follow the sequence defined in `tasks.md`: Phase 0 (Site Preparation), Phase 1 (Structural Build), Scenario phases, Stewardship.  
   - Respect dependencies—do not start a task until all prerequisite tasks are complete.  
   - For `[P]` tasks, verify parallel work does not contend for the same tools or space. If it does, re-sequence or run sequentially.

6. **Progress Tracking & Logging**  
   - After completing a task, mark it as `[X]` in `tasks.md` and note any observations (yield, soil moisture, wildlife sightings) in the relevant artefact (`seasonal-calendar.md`, `monthly-care-plan.md`, or `plan.md`).  
   - If a task cannot be completed, record the reason and suggest a follow-up action (including updates to `existing-plant-inventory.md` when removals or relocations occur).

7. **Observation & Feedback Loop**  
   - Periodically revisit success criteria from the vision. Capture photo references or notes when criteria are met (or miss the mark).  
   - Update `tools.md` when equipment is serviced, borrowed, or returned.

8. **Completion Validation**  
   - Ensure all tasks are checked off.  
   - Confirm the garden matches the scenarios and requirements in `spec.md` and `plan.md`.  
  - Verify stewardship notes or follow-up tasks are logged for future seasons.  
   - Report final status with highlights, issues, and next steps for ongoing care.

---

## Safety Reminders

- Use protective gear during cutting, digging, or chemical handling.  
- Schedule breaks and hydration—gardening can be strenuous.  
- Respect wildlife habitats and avoid disturbing nests or beneficial insects.  
- Clean tools after use and store them according to `tools.md` guidance.
