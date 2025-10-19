---
description: Capture or update the garden vision from a natural-language description of the desired space.
scripts:
  sh: scripts/bash/create-new-feature.sh --json "{ARGS}"
  ps: scripts/powershell/create-new-feature.ps1 -Json "{ARGS}"
---

## Gardener Input

```text
$ARGUMENTS
```

Always consider the gardener’s description before drafting the vision. If the command was invoked without text, report an error.

---

## Outline

1. **Name the garden branch**  
   - Extract a concise 2–4 word short name that reflects the garden’s essence (e.g., `kitchen-garden`, `pollinator-haven`).  
   - Use action + noun or descriptor + noun formats when possible.  
   - Preserve key horticultural terms (raised beds, pergola, rain garden, etc.).  
   - Examples:  
     - “Create terraced beds for herbs and berries” → `terraced-herb-berries`  
     - “Transform shady corner into woodland retreat” → `woodland-retreat`

2. **Run `{SCRIPT}` with the short name**  
   - Append the generated short name when calling the script:  
     - Bash: `--short-name "short-name"`  
     - PowerShell: `-ShortName "short-name"`  
   - Parse `BRANCH_NAME` and `SPEC_FILE` from the JSON output (absolute paths).  
   - The script creates the branch, directory, and base template (still named `spec.md`). Never run it more than once per invocation.

3. **Load the garden vision template**  
   - Reference `templates/spec-template.md` (mirrored in `.gardify/templates/spec-template.md`).  
   - Understand mandatory sections: Garden Scenarios, Edge Conditions, Garden Requirements, Success Criteria, Assumptions, Open Questions.

4. **Interpret the gardener’s description**  
   - Identify: zones, uses, sensory goals, plant preferences, existing constraints (soil, sun, wildlife), and available help.  
   - Resolve ambiguity with reasonable gardening defaults (companion planting, seasonal interest) when the description lacks detail.  
   - Use `[NEEDS CLARIFICATION: …]` only for decisions that materially change the space or require stakeholder approval. Limit to **three** markers. Prioritise big topics: site constraints, safety, budget, community rules.

5. **Draft the Garden Vision**  
   - Populate every section in the template with clear, gardener-friendly language.  
   - Convert “user stories” into **Garden Scenarios** (seasonal experiences or outcomes).  
   - Replace functional requirements with **Site Requirements**, **Planting & Habitat requirements**, and **Stewardship requirements**.  
   - Edge conditions should cover weather extremes, pests, and resource limits.  
   - Success criteria must be measurable outdoors (yield, bloom duration, water savings, volunteer satisfaction).

6. **Write the document**  
   - Save the completed vision to `SPEC_FILE`.  
   - Maintain template headings and ordering; remove unused optional sections if they truly do not apply.  
   - Document assumptions separately from clarifications.

7. **Vision Quality Validation**  
   - Generate `checklists/vision-quality.md` (within the feature directory) based on `templates/checklist-template.md`.  
   - Checklist items should verify:  
     - Garden scenarios cover all intended experiences.  
     - Tool availability assumptions are captured (even if detailed inventory comes later).  
     - Edge conditions include weather, pests, and resource constraints.  
     - Success criteria are measurable and seasonally relevant.  
   - If `[NEEDS CLARIFICATION]` markers remain, create questions for the gardener before proceeding (see below).

8. **Clarification Loop (when needed)**  
   - Collect all outstanding questions (max three).  
   - Present them with context from the vision and suggested answers in a well-formatted table:  
     ```markdown
     ## Question [N]: [Topic]

     **Context**: [Quote relevant paragraph]

     **What we need to know**: [Specific clarification]

     **Suggested Answers**

     | Option | Answer | Implications |
     |--------|--------|--------------|
     | A | [Option 1] | [Impact on garden] |
     | B | [Option 2] | [Impact on garden] |
     | C | [Option 3] | [Impact on garden] |
     | Custom | Provide your own | [Explain how to respond] |

     **Your choice**: _[Wait for gardener response]_
     ```
   - After receiving answers, update the vision, remove the markers, and refresh the checklist.

9. **Report completion**  
   - Provide the branch name, path to `spec.md`, and checklist status.  
   - Mention readiness for `/gardenkit.plan`.

---

## Quality Expectations

- Language is friendly to gardeners and volunteers—no software terminology.  
- Scenarios are seasonally aware and independently testable.  
- Requirements describe physical outcomes (soil condition, habitat support, safety).  
- Success criteria are practical and measurable outdoors.  
- Questions focus on big decisions, not minor preferences.
