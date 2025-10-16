---
description: Amend the GardenKit Constitution and cascade updates across supporting templates.
---

## User Input

```text
$ARGUMENTS
```

You **MUST** incorporate any non-empty user input.

## Working Agreement

- Operate on `.specify/memory/constitution.md`; this document already contains the GardenKit principles.
- The constitution is the single source of truth for how we plan, phase, and care for the garden. Treat changes as governance decisions.
- Keep the document fully populated—no placeholder tokens remain anywhere in the file.

## Execution Flow

1. **Load Context**
   - Read the current constitution and capture the existing version, ratification date, last amended date, and principle summaries.
   - Review user input to understand required additions, refinements, or removals.

2. **Assess Impact**
   - Decide the semantic version bump (MAJOR for rewriting/removing a principle, MINOR for adding guidance/sections, PATCH for clarifications).
   - Identify which sections must change: Core Principles, Site Design Standards, Planning Workflow, Governance, or Sync Impact Report.

3. **Author Updates**
   - Edit only the affected sections, keeping language garden-focused, testable, and declarative.
   - Maintain and refresh the HTML “Sync Impact Report” comment:
     * Version change (old → new)
     * Modified principles (old title → new title if renamed)
     * Added / removed sections
     * Templates or prompts touched (`.specify/templates/*.md`, `.codex/prompts/*.md`, etc.) marked `●updated` or `◌ pending`
     * Follow-up TODOs (e.g., “◌ confirm soil test results once lab report arrives”)
   - Update the version line at the bottom plus ratified/amended dates (ISO `yyyy-MM-dd`). Use today for `Last Amended` when you change anything.

4. **Cascade Validation**
   - Re-check `.specify/templates/spec-template.md`, `plan-template.md`, `tasks-template.md`, `checklist-template.md`, and the agent context template to ensure they align with the revised constitution.
   - Confirm `.codex/prompts/speckit.*` guidance still matches the new rules. If more edits are needed outside this command, note them with `◌ pending` in the Sync Impact Report.

5. **Quality Gates**
   - Principles must reference observable garden behaviors (sun mapping, purposeful zones, seasonal rhythm, resource stewardship, incremental phasing).
   - Avoid vague verbs (“should”, “maybe”) unless framed as rationale. Replace with MUST/SHOULD plus measurable cues.
   - Preserve Markdown hierarchy, spacing, and tone. Remove any lingering template comments that no longer add value.

6. **Write & Report**
   - Save the updated constitution back to `.specify/memory/constitution.md` (UTF-8).
   - Respond to the user with:
     * New version number and bump rationale
     * Bullet summary of key changes
     * Follow-up actions (if any)
     * Suggested commit message, e.g. `docs: update GardenKit constitution to vX.Y.Z`
