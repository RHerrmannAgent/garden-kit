---
description: Transform the garden vision (spec.md) into a phased implementation plan with supporting artifacts.
---

## User Input

```text
$ARGUMENTS
```

Incorporate any non-empty user guidance before planning.

## Workflow

1. **Prepare workspace**
   - Run `.specify/scripts/powershell/setup-plan.ps1 -Json` from repo root.
   - Parse JSON once for: `PLAN_FILE`, `PLAN_DIR`, `GARDEN_VISION`, `BRANCH`.
   - All paths must be absolute.

2. **Load context**
   - Read `spec.md` (garden vision), the new `plan.md` template, and `.specify/memory/constitution.md`.
   - Gather site assumptions, zone priorities, clarifications, and success criteria from the spec.

3. **Plan structure**
   - Complete every section of `plan.md`:
     * **Summary**: Highlight primary goals, standout opportunities, and risks.
     * **Site & Context Recap**: Build the table and open questions list using data from the spec and any new research.
     * **Constitution Check**: Evidence how the plan honors each principle. Flag gaps with mitigation notes.
     * **Design Blueprint**: Populate zones overview, circulation/access, water & soil strategy.
     * **Supporting Artifacts Table**: Track status for `site-study.md`, `layout-guide.md`, `planting-calendar.md`, `care-guide.md`, and `structures/`.
     * **Phasing Roadmap**: Map phases 0–4 with clear goals, tasks, and dependencies. Each phase must deliver a self-contained win.
     * **Resource Plan**: Budget, labor, tools/materials, risk register.
     * **Evaluation Gates**: Define checks before advancing to the next phase.

4. **Generate supporting artifacts**
   Create (or overwrite) the following files in `PLAN_DIR`:
   - `site-study.md`: Expanded observations, measurement logs, sun/shade charts, soil findings, outstanding clarifications.
   - `layout-guide.md`: Zone-by-zone dimensions, path widths, material lists, irrigation notes, elevation/grade considerations.
   - `planting-calendar.md`: Season-by-season tables with plantings, successions, inputs, and maintenance cues.
   - `care-guide.md`: Weekly/monthly routines, harvest instructions, tool maintenance, and observation checklists.
   - `structures/` directory: Markdown files or diagrams describing raised beds, trellises, water systems, compost bays, etc. Include cut lists or material takeoffs when relevant.

5. **Align with constitution**
   - For each artifact, note how GardenKit principles are satisfied. Example: `site-study.md` must demonstrate “Observe Before You Design”; the phasing roadmap must show “Grow Incrementally”.
   - If any principle cannot be satisfied with current information, document mitigation steps or follow-up research tasks inside `site-study.md` and the plan’s risk register.

6. **Quality checks**
   - No TBD or placeholder text remains.
   - All measurements include units and are consistent (prefer metric unless the gardener demands imperial).
   - Phases avoid rework and respect labor/time constraints.
   - Supporting docs cross-reference each other (e.g., layout dimensions match planting spacing).
   - Update agent context: run `.specify/scripts/powershell/update-agent-context.ps1 -AgentType codex` so assistants inherit the latest garden context.

7. **Report**
   - Save `plan.md` and all supporting files in UTF-8.
   - Reply with a summary covering: branch, paths of updated artifacts, key assumptions, unresolved clarifications (if any), and suggested next command (usually `/speckit.tasks` once plan + artifacts are complete).
