---
description: Review spec.md, plan.md, and tasks.md for garden-planning consistency before work begins.
---

## User Input

```text
$ARGUMENTS
```

Incorporate any user-specified concerns into the analysis focus (e.g., “check irrigation coverage”).

## Scope & Constraints

- **Read-only**: Do not modify files. Produce a diagnostic report.
- **Artifacts**: Requires completed `spec.md`, `plan.md`, `tasks.md`, plus supporting docs (`site-study.md`, `layout-guide.md`, `planting-calendar.md`, `care-guide.md` if available).
- **Authority**: The GardenKit Constitution is binding. Any violation is CRITICAL and must block execution until resolved.

## Workflow

1. **Initialize**
   - Run `.specify/scripts/powershell/check-prerequisites.ps1 -Json -RequireTasks -IncludeTasks`.
   - Resolve absolute paths for all artifacts in the active garden plan directory.
   - Abort with a clear error if anything is missing; advise which command to run next.

2. **Load key sections (progressively)**
   - From `spec.md`: Vision & Priorities, Site Snapshot, Zones & Experiences, Seasonal Rhythm, Resources & Stewardship, Success Criteria, Assumptions.
   - From `plan.md`: Site recap table, Constitution Check, Zones overview, circulation/water strategy, phasing roadmap, resource plan.
   - From `tasks.md`: Phase headings, each task line (IDs, `[P]`, `[Zone/Phase]`, descriptions), dependencies, parallel notes.
   - From supporting docs (if present): 
     * `site-study.md`: measurements, hazards, unresolved clarifications.
     * `layout-guide.md`: dimensions, materials, irrigation notes.
     * `planting-calendar.md`: seasonal plantings and inputs.
     * `care-guide.md`: maintenance cadence, validation checks.
   - From `.specify/memory/constitution.md`: principle statements and mandates.

3. **Build cross-artifact maps**
   - **Zone coverage matrix**: For each zone in the spec, confirm plan and tasks include a dedicated phase or task bundle.
   - **Seasonal alignment**: Map planting-calendar tasks to plan phases and success criteria.
   - **Resource commitments**: Compare maintenance hours, soil/water strategies, and tool requirements across docs.
   - **Clarification tracker**: List unresolved assumptions or TODOs mentioned in any document.

4. **Detection passes**
   - **Constitution compliance (CRITICAL)**: Missing observations, zone purpose ambiguity, lack of seasonal planning, unsustainable resource usage, or absent phasing.
   - **Coverage gaps**:
     * Zone defined in spec but missing from plan/tasks.
     * Plan phase with no tasks or tasks with no supporting plan rationale.
   - **Sequencing risks**:
     * Tasks that violate logical order (planting before irrigation, structures before utilities marked safe, etc.).
     * Missing validation tasks after critical installations (irrigation flush, soil moisture checks).
   - **Measurement inconsistencies**: Conflicting dimensions, capacities, quantities between docs.
   - **Resource overloads**: Labor hours per phase exceeding gardener’s stated availability; budget mismatches.
   - **Ambiguity**: Vague tasks (“prep beds”) without quantities or references; success criteria without metrics.
   - **Seasonal conflicts**: Tasks scheduled outside suitable planting windows per calendar.

5. **Severity levels**
   - **CRITICAL**: Constitution breach, missing artifact, safety hazard unaddressed, zone with zero implementation coverage.
   - **HIGH**: Sequencing error likely to cause rework, missing validation/test step, resource commitments unrealistic.
   - **MEDIUM**: Measurement mismatch, terminology drift, unclear success measure.
   - **LOW**: Style issues, redundant statements, cosmetic improvements.

6. **Report format**
   ```
   ## Garden Planning Analysis

   | ID | Category | Severity | Location(s) | Summary | Recommendation |
   |----|----------|----------|-------------|---------|----------------|
   | Z1 | Coverage | CRITICAL | spec.md:L85; plan.md:L120 | Zone 3 defined but no tasks | Add Phase 3 tasks for Zone 3 in tasks.md |
   ```
   - IDs prefix: Z (zone), S (seasonal), R (resource), C (constitution), M (measurement), A (ambiguity), O (other).
   - Provide a **Coverage Matrix**:
     ```
     | Zone | Spec Present | Plan Phase | Tasks Phase | Notes |
     ```
   - List **Seasonal Checks** summarizing plantings vs. tasks.
   - List **Unresolved Clarifications/TODOs** with references.
   - Metrics section:
     * Total zones
     * Zones fully covered (plan + tasks)
     * Tasks with `[P]` markers
     * Outstanding clarifications
     * Constitution violations

7. **Next actions**
   - Provide a concise “Next Steps” list tailored to severity (e.g., “Prioritize fixing irrigation sequencing before starting Phase 2”).
   - Offer to draft remediation tasks or edits if user wants follow-up (explicit opt-in).
