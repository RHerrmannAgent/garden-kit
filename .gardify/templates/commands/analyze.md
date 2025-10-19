---
description: Review garden artefacts (`spec.md`, `plan.md`, `tasks.md`) after task generation to surface inconsistencies before implementation.
scripts:
  sh: scripts/bash/check-prerequisites.sh --json --require-tasks --include-tasks
  ps: scripts/powershell/check-prerequisites.ps1 -Json -RequireTasks -IncludeTasks
---

## Gardener Input

```text
$ARGUMENTS
```

Incorporate any focus areas the gardener wants inspected (e.g., seasonal coverage, tool conflicts).

---

## Goal

Run a **read-only** analysis that checks whether the garden vision, plan, and task schedule agree with each other and with the constitution. Report findings; do not edit files.

---

## Execution Steps

### 1. Initialise Context

- Run `{SCRIPT}` from the repository root to gather `FEATURE_DIR` and `AVAILABLE_DOCS`.  
- Verify `spec.md`, `plan.md`, and `tasks.md` exist. Abort with guidance if any file is missing.  
- Use absolute paths at all times.

### 2. Load Artefacts (minimal necessary context)

- **From `spec.md`**: Garden scenarios, edge conditions, site/planting/stewardship requirements, success criteria.  
- **From `plan.md`**: Site conditions, tool inventory summary, phases, risks, observation loops.  
- **From `tasks.md`**: Task IDs, descriptions, phase labels, `[P]` markers, referenced locations/tools.  
- **From `tools.md`** (if available): Tool quantities and notes.  
- **From `/memory/constitution.md`**: Principles and mandates that must be upheld.

### 3. Build Comparative Inventories

- **Requirement Index**: Catalogue site, planting, and stewardship requirements with unique slugs.  
- **Scenario Index**: Map each garden scenario (priority, seasonal markers).  
- **Task Coverage Map**: Link tasks to requirements/scenarios based on keywords, zones, and tool references.  
- **Tool Usage Map**: Track which tasks require each tool.

### 4. Detection Passes

Limit to the most impactful observations (max 50 findings; summarise overflow).

- **Duplication**: Scenarios or requirements describing the same outcome with different wording.  
- **Ambiguity**: Vague measures (“lush”, “adequate”) without quantification; unresolved `[NEEDS CLARIFICATION]` markers; placeholders like TODO/???  
- **Coverage Gaps**: Requirements or scenarios that lack supporting tasks; tasks that do not map to any requirement/scenario.  
- **Tool Conflicts**: Multiple tasks competing for a single tool without sequencing guidance; tasks requiring tools absent from `tools.md`.  
- **Constitution Conflicts**: Any plan or task violating a MUST principle (e.g., ignoring water restrictions, safety mandates).  
- **Seasonal Tension**: Tasks scheduled out of sync with seasonal calendar cues; scenarios lacking coverage in certain seasons.  
- **Risk Misalignment**: Risks in `plan.md` without mitigation tasks; tasks referencing mitigations absent from plan.

### 5. Severity Guide

- **CRITICAL**: Breaches constitution, missing tasks for high-priority scenarios, or required tools absent.  
- **HIGH**: Conflicting guidance between spec/plan/tasks, ambiguous safety direction, or unsequenced tool conflicts.  
- **MEDIUM**: Terminology drift, weak success measures, seasonal mismatches.  
- **LOW**: Stylistic improvements, minor redundancies.

### 6. Output Format

Produce a Markdown report (no file writes) with:

1. **Findings Table**
   ```
   | ID | Category | Severity | Location(s) | Summary | Recommendation |
   |----|----------|----------|-------------|---------|----------------|
   | G1 | Coverage | HIGH | spec.md:120, tasks.md:88 | Scenario 1 lacks maintenance tasks | Add stewardship tasks in Phase 5 |
   ```

2. **Coverage Summary**
   ```
   | Requirement Key | Covered by Tasks? | Task IDs | Notes |
   ```

3. **Tool Usage Summary**
   - Highlight tools missing from inventory yet required by tasks.  
   - Flag simultaneous use conflicts.

4. **Constitution Alignment Issues**
   - List principle violations or areas needing clarification.

5. **Metrics**
   - Total scenarios  
   - Total requirements (site/planting/stewardship)  
   - Total tasks  
   - Coverage percentage  
   - Ambiguity count  
   - Tool conflicts count  
   - Critical issues count

6. **Next Actions Block**
   - Recommend halting `/gardenkit.implement` if CRITICAL issues exist.  
   - Otherwise, list improvements or confirmations that implementation can proceed.

---

## Operating Constraints

- Do **not** modify any files.  
- Respect the constitution’s authority. If principles need revision, suggest running `/gardenkit.constitution`.  
- Keep analysis concise and gardener-friendly.
