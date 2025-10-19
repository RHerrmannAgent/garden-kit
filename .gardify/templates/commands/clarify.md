---
description: Surface gaps or ambiguities in the current garden vision by asking targeted clarification questions and incorporating answers.
scripts:
  sh: scripts/bash/check-prerequisites.sh --json --paths-only
  ps: scripts/powershell/check-prerequisites.ps1 -Json -PathsOnly
---

## Gardener Input

```text
$ARGUMENTS
```

Consider any focus areas the gardener wants clarified (e.g., water restrictions, accessibility, wildlife support).

---

## Goal

Resolve missing or ambiguous details in `spec.md` before `/gardenkit.plan` runs. Clarifications should reduce rework and ensure the plan captures accurate garden realities.

---

## Execution Steps

1. **Setup**  
   - Run `{SCRIPT}` with `--json --paths-only` (or PowerShell equivalent).  
   - Parse `FEATURE_DIR` and `FEATURE_SPEC`.  
   - Abort with guidance if parsing fails; gardeners must rerun `/gardenkit.gardify` first.

2. **Scan the Garden Vision**  
   - Evaluate each section using the checklist below. Mark status internally as Clear / Partial / Missing.  
   - Prioritise categories with Partial/Missing coverage.  

   **Categories**  
   - Garden Scenarios & Seasonal Experiences  
   - Site Requirements (soil, water, access)  
   - Planting & Habitat Requirements  
   - Stewardship Requirements  
   - Edge Conditions (weather extremes, pests, resource limits)  
   - Success Criteria (measurable, seasonal)  
   - Assumptions (labour, budget, community rules)  

3. **Select Up to Five Questions**  
   - Choose the most impactful gaps (focus on site constraints, safety, tool availability, or seasonal dependencies).  
   - Each question must include:  
     - Topic and short rationale.  
     - Quoted context from the vision.  
     - Three suggested answers (Options A–C) reflecting reasonable horticultural choices.  
     - “Custom” option for bespoke input.  
   - Format questions using the template also shown in `/templates/commands/specify.md`.

4. **Present Questions**  
   - Output all questions together using Markdown tables for suggested answers.  
   - Wait for the gardener to respond with selections (e.g., `Q1: B, Q2: Custom - ...`).

5. **Apply Answers**  
   - Update `spec.md` in place:  
     - Replace `[NEEDS CLARIFICATION: …]` markers.  
     - Insert new information under the relevant headings.  
   - Ensure updates preserve the Garden Vision structure and tone.

6. **Validation**  
   - Re-read the edited sections to confirm clarity.  
   - Verify no placeholder markers remain.  
   - If new assumptions were introduced, document them in the **Assumptions** section.

7. **Report**  
   - Summarise resolved topics, note any remaining open items, and indicate readiness for `/gardenkit.plan`.

---

## Question Crafting Tips

- Use gardener-friendly language—avoid jargon.  
- Offer reasonable defaults grounded in climate, soil, or community realities.  
- Highlight safety or accessibility implications when relevant.  
- If more than five issues exist, tackle the highest-impact areas and note the rest for later follow-up.
