---
description: Create or update the garden constitution so principles, safety rules, and stewardship pledges stay aligned across all templates.
---

## Gardener Input

```text
$ARGUMENTS
```

Blend the gardener’s guidance with existing documentation to produce a clear, enforceable constitution.

---

## Outline

1. **Load the template**  
   - Open `/memory/constitution.md`.  
   - Identify placeholders like `[GARDEN_NAME]`, `[PRINCIPLE_1_NAME]`, etc. The gardener may request fewer or more principles—tailor the document accordingly.

2. **Collect values for placeholders**  
   - Use gardener input, existing plan artefacts, or reasonable horticultural defaults.  
   - Versioning rules (`CONSTITUTION_VERSION`):  
     - **MAJOR** – Principles removed or fundamentally redefined.  
     - **MINOR** – New principle or substantive guidance added.  
     - **PATCH** – Editorial improvements only.  
   - Dates must be ISO `YYYY-MM-DD`. Update `LAST_AMENDED_DATE` when any change occurs.

3. **Draft the updated constitution**  
   - Replace all placeholders with concrete language.  
   - Each principle should include a title, short explanation, and actionable rules.  
   - Sections should speak to soil stewardship, water use, biodiversity, safety, shared access, or other garden realities.  
   - Remove instructional comments once content is in place unless they remain helpful.

4. **Sync-dependent templates**  
   After updating the constitution, verify other templates are aligned:
   - `templates/spec-template.md` – Garden scenarios and requirements must reflect new principles.  
   - `templates/plan-template.md` – Constitution check section should match updated guidance.  
   - `templates/tasks-template.md` – Ensure phases or safety reminders cover new mandates.  
   - `templates/commands/*.md` – Update any references to principles or governance to stay consistent.  
   - Documentation (`README.md`, `spec-driven.md`, etc.) – adjust text if principles changed materially.

5. **Insert Sync Impact Report**  
   - At the top of `/memory/constitution.md`, add an HTML comment summarising:  
     - Version change (old → new).  
     - Renamed or added principles.  
     - Sections added or removed.  
     - Files updated or flagged for follow-up.  
     - Deferred TODO items, if any.

6. **Validation**  
   - No unresolved placeholders.  
   - Language uses clear commitments (“must”, “always”, “never”) where appropriate.  
   - Safety, stewardship, and access guidance are explicit.  
   - Version line mirrors the report.

7. **Write the file**  
   - Save the updated constitution to `/memory/constitution.md`.  
   - Note any deferred decisions for gardeners to address later.

8. **Output**  
   - Summarise the new version and major changes.  
   - List downstream files touched or still needing manual edits.  
   - Suggest a commit message, e.g., `docs: refresh garden constitution to vX.Y.Z`.

---

## Style Guide

- Use garden-friendly language—avoid software terminology.  
- Keep sections concise and anchored in observable practices.  
- When uncertain, ask clarifying questions rather than guessing critical rules.  
- Respect accessibility and inclusivity in all guidance.
