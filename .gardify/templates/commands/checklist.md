---
description: Generate a gardener-facing checklist that validates the clarity and completeness of garden artefacts.
scripts:
  sh: scripts/bash/check-prerequisites.sh --json
  ps: scripts/powershell/check-prerequisites.ps1 -Json
---

## Checklist Purpose

Checklists act as **quality gates** for garden documentation. They confirm the vision, plan, tasks, and safety notes are specific enough to execute without confusion. They do **not** validate whether a bed was actually planted—only whether the documentation is ready for implementation.

### What checklists cover
- Completeness of garden scenarios and seasonal experiences.
- Clarity of site, planting, and stewardship requirements.
- Alignment between plan phases and success criteria.
- Safety and accessibility guidance (PPE, pathways, signage).
- Tool inventory accuracy and readiness.

### What checklists do *not* cover
- Verifying that plants were installed.
- Confirming yields or bloom times.
- Testing irrigation hardware.

---

## Gardener Input

```text
$ARGUMENTS
```

Use the gardener’s request to focus the checklist (e.g., “safety audit”, “spring readiness”, “permaculture design review”).

---

## Execution Steps

1. **Setup**  
   - Run `{SCRIPT}` from repo root to obtain `FEATURE_DIR` and `AVAILABLE_DOCS`.  
   - Ensure absolute paths.  
   - Handle quoted arguments safely (`'I'\''m Groot'` or `"I'm Groot"`).

2. **Load Artefacts**  
   - `spec.md`, `plan.md`, `tasks.md`, `tools.md`, `seasonal-calendar.md`, and `quickstart.md` when present.  
   - Extract the sections relevant to the requested checklist focus.

3. **Define Checklist Categories**  
   - Choose 2–4 categories (e.g., *Site Readiness*, *Planting Clarity*, *Safety & Access*, *Seasonal Preparedness*).  
   - Ensure categories align with constitution principles and gardener input.

4. **Draft Checklist Items**  
   - Use the template at `templates/checklist-template.md`.  
   - Each item must be observable or verifiable by reviewing documents or performing a quick on-site check.  
   - Reference artefacts where needed (`plan.md → Tool Inventory`, `spec.md → Scenario 2`).  
   - Keep statements affirmative and concise.

5. **Write the Checklist**  
   - Save to `FEATURE_DIR/checklists/[slug].md` (use lowercase hyphenated slug based on checklist focus).  
   - Prepend metadata (purpose, date, garden link).  
   - Ensure Markdown tables (if any) are well formatted.

6. **Report**  
   - Share the path to the checklist and a summary of categories covered.  
   - Mention any areas lacking sufficient information (e.g., missing tool data) so the gardener can address them.

---

## Quality Guidelines

- Avoid repeating existing task descriptions; focus on validation of documentation.  
- Use inclusive, gardener-friendly language.  
- If information is missing from artefacts, create an item that highlights the gap rather than guessing.  
- Tie back to constitution principles whenever applicable (soil health, water stewardship, safety).
