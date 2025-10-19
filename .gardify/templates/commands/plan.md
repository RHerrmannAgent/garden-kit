---
description: Produce the garden layout plan and supporting artefacts using the planning template.
scripts:
  sh: scripts/bash/setup-plan.sh --json
  ps: scripts/powershell/setup-plan.ps1 -Json
agent_scripts:
  sh: scripts/bash/update-agent-context.sh __AGENT__
  ps: scripts/powershell/update-agent-context.ps1 -AgentType __AGENT__
---

## Gardener Input

```text
$ARGUMENTS
```

Incorporate any additional guidance the gardener provided here (tool preferences, budget, time horizon).

---

## Outline

1. **Initial Setup**  
   - Run `{SCRIPT}` from the repository root.  
   - Parse JSON output capturing `FEATURE_SPEC`, `IMPL_PLAN`, `SPECS_DIR`, and `BRANCH`. Paths must remain absolute.

2. **Gather Context**  
   - Read the existing garden vision (`FEATURE_SPEC`).  
   - Load `/memory/constitution.md` for guiding principles.  
  - Open the planning template (`IMPL_PLAN`) copied by the script.

3. **Plan Workflow**  
   Follow the template step-by-step:
   - Translate site conditions into the “Site Conditions & Research Highlights” section. Any unknowns become `NEEDS CLARIFICATION` markers.
   - Complete the Constitution Check using the garden’s principles; flag conflicts immediately.
   - Map out physical layout summaries and phases aligned with the vision scenarios.
   - **Create the Tool & Resource Inventory** table. This is mandatory. Populate it with everything the gardener has or can access. Save the same information into `tools.md` (see Phase 1 below).
   - Summarise planting schema, seasonal strategy, risks, and observation loops.

4. **Generate Supporting Artefacts**  
   - `site-research.md`: Consolidate soil data, climate notes, regulations, and observations. Resolve all `NEEDS CLARIFICATION` markers by the end of this document.  
   - `planting-schema.md`: Detail plant lists, layers, spacing, companion notes, and succession plans.  
   - `seasonal-calendar.md`: Outline care reminders and observations month-by-month.  
   - `tools.md`: Copy the final tool inventory table, adding any notes about maintenance status or borrowing needs.  
   - `quickstart.md`: Provide orientation for volunteers/visitors—include safety reminders and garden etiquette.  
   - Create or refresh any agent-specific context files by running the appropriate `{AGENT_SCRIPT}`.

5. **Re-run Constitution Check**  
   - After drafting the artefacts, re-evaluate whether all principles are upheld.  
   - Document any mitigation steps if a principle cannot be met immediately.

6. **Stop and Report**  
   - Planning ends once the plan template and artefacts above are produced.  
   - Report: branch name, `plan.md` path, generated artefacts, and outstanding clarifications (if any). Highlight readiness (or blockers) for `/gardenkit.tasks`.

---

## Phases & Deliverables

### Phase 0 – Research & Unknowns
1. Collect all `NEEDS CLARIFICATION` items from the site conditions section.  
2. For each unknown create a research prompt, e.g.,  
   ```
   Task: "Research companion planting for tomatoes in USDA zone 7."
   Task: "Confirm local guidelines for rainwater barrel placement."
   ```  
3. Consolidate findings into `site-research.md` using the structure:  
   - Discovery  
   - Rationale  
   - Alternatives considered  
   - Guidance for plan

**Output**: `site-research.md` with no unresolved unknowns.

### Phase 1 – Design Artefacts
**Prerequisite**: Phase 0 complete.

1. **Planting Schema (`planting-schema.md`)**  
   - Break down by zone or bed.  
   - Include botanical names, spacing, height, water needs, and companion notes.  
   - Reference succession planting or rotation where relevant.

2. **Seasonal Calendar (`seasonal-calendar.md`)**  
   - Create monthly or bi-weekly reminders for planting, pruning, feeding, observing, and logging data.  
   - Include checks that align with success criteria (e.g., “Record pollinator visits each weekend in June.”).

3. **Tool Inventory (`tools.md`)**  
   - Copy the inventory table from `plan.md`.  
   - Add maintenance status, borrow/reserve notes, safety gear requirements.  
   - This file is required for `/gardenkit.tasks`; if items are missing, note acquisition plans.

4. **Quickstart Guide (`quickstart.md`)**  
   - Audience: volunteers, caretakers, new gardeners.  
   - Include orientation map references, safety rules, tool checkout process, and observation logging instructions.

5. **Agent Context Update**  
   - Run `{AGENT_SCRIPT}` to sync the assistant-specific context file with the new plan, highlighting zones, tools, and safety rules.

**Outputs**: `planting-schema.md`, `seasonal-calendar.md`, `tools.md`, `quickstart.md`, updated agent context.

---

## Key Rules

- Use absolute paths for all file references.  
- Every `NEEDS CLARIFICATION` marker must be resolved or explicitly carried as an open question at the end of the plan.  
- Do not proceed to `/gardenkit.tasks` until the tool inventory exists and Constitution Check passes (or deviations are documented with mitigation).
