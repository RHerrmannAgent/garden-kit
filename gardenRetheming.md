# Garden Kit Retheming Task List

Tasks required to retheme Garden Kit for garden planning while keeping `/gardenkit.*` workflows and current directory names.

---

## Pre-Flight Checks (before any edits)
- [ ] Confirm no pending local changes you need to keep elsewhere.
- [ ] Sync with the latest `main` (or current base branch) to avoid conflicts.
- [ ] Note that directories such as `specs/` stay unchanged (per requirement).

Proceed only after all pre-flight items are satisfied.

---

## Task Breakdown

### 1. Rework Terminology & Narrative
- Actions
  - Update guiding documents (`README.md`, `spec-driven.md`, `AGENTS.md`, `memory/constitution.md`) to use garden-planning language.
  - Document new vocabulary mapping (feature → garden vision, etc.).
- Validation Criteria
  - Every public-facing document describes horticultural workflows.
  - No references remain tying the toolkit to software development.
- Checks Before Proceeding
  - Ensure updated terminology is consistent across all documents.

### 2. Update Core Templates (`.gardify/templates`)
- Actions
  - Rewrite `spec-template.md`, `plan-template.md`, `tasks-template.md`, `checklist-template.md`, and `agent-file-template.md` for garden planning.
  - Add guidance for site analysis, planting zones, seasonal considerations, and gardener goals.
- Validation Criteria
  - Templates no longer mention software terms (user stories, code paths, etc.).
  - New content covers garden planning concepts and includes placeholders where needed.
- Checks Before Proceeding
  - Run lint/format checks if applicable to ensure no syntax issues.

### 3. Adjust Command Workflow Templates (`templates/commands`)
- Actions
  - Tailor `/gardenkit.gardify`, `/gardenkit.plan`, `/gardenkit.tasks`, `/gardenkit.implement`, and supporting commands to garden deliverables.
  - Introduce instructions for recording gardener tool inventory during planning.
- Validation Criteria
  - Command guides point to garden artifacts (e.g., site research, planting schema).
  - Tool inventory step is explicitly required before task generation.
- Checks Before Proceeding
  - Verify command templates still reference existing filenames (`spec.md`, `plan.md`, etc.) to respect directory constraints.

### 4. Extend Scripts (PowerShell & Bash)
- Actions
  - Update narrative-driven messages in `scripts/powershell/*.ps1` and `scripts/bash/*.sh`.
  - Add logic for tool inventory generation/consumption where relevant (e.g., setup-plan, check-prerequisites).
- Validation Criteria
  - Scripts emit garden-centric messaging and instructions.
  - Tool inventory file is created/read without breaking existing flows.
- Checks Before Proceeding
  - Run linters/shellcheck if available; ensure scripts execute without errors.

### 5. Refresh CLI Messaging (`src/specify_cli/__init__.py`)
- Actions
  - Change banners, help text, examples, and console panels to garden planning language.
  - Ensure prompts emphasize garden setup, tool checks, and horticultural artifacts.
- Validation Criteria
  - `gardify --help` output references garden planning.
  - All onboarding prompts align with new terminology.
- Checks Before Proceeding
  - Run unit/static checks if available; confirm CLI executes without tracebacks.

### 6. Introduce Tool Inventory Workflow
- Actions
  - Create a template (e.g., `tools-template.md`) and integrate generation during `/gardenkit.plan`.
  - Ensure `/gardenkit.tasks` reads the inventory and warns when tasks require unavailable tools.
- Validation Criteria
  - Tool inventory file is produced automatically and referenced in tasks generation.
  - Missing tools trigger actionable warnings or steps.
- Checks Before Proceeding
  - Manual dry-run of plan/tasks commands demonstrates tool inventory usage.

### 7. Provide Garden Sample Assets
- Actions
  - Add example garden project under `specs/000-sample-garden/` (spec, plan, tasks, research files).
  - Include visual aids (e.g., site map image) in `media/`.
- Validation Criteria
  - Sample assets reflect garden planning narrative and can serve as references.
  - Assets load correctly without breaking packaging.
- Checks Before Proceeding
  - Confirm assets follow licensing guidelines and repo standards.

### 8. Update Documentation & Supporting Files
- Actions
  - Revise release notes, changelog entries, and CONTRIBUTING guidance to mention retheme.
  - Adjust any workflow descriptions or diagrams.
- Validation Criteria
  - Docs guide users through garden planning workflow end-to-end.
  - Changelog records the retheming changes.
- Checks Before Proceeding
  - Ensure documentation passes markdown linting (if configured).

### 9. Ensure Release & Packaging Scripts Handle Changes
- Actions
  - Review `.github/workflows/scripts/create-release-packages.sh` and `create-github-release.sh` to include new assets.
  - Confirm no rename of directories means minimal script changes.
- Validation Criteria
  - Release scripts bundle updated templates and sample assets.
  - No references to removed files remain.
- Checks Before Proceeding
  - Dry-run release packaging locally to confirm success.

### 10. Final Validation
- Actions
  - Run `gardify init` with a temporary directory to scaffold a garden project.
  - Execute `/gardenkit.plan` and `/gardenkit.tasks` end-to-end using sample input.
- Validation Criteria
  - Generated artifacts reflect garden planning at each stage.
  - Tool inventory is captured and enforced before tasks creation.
- Checks Before Proceeding
  - Document results and fix any issues discovered before calling the work complete.

---

Completion of all tasks above yields a garden-focused Garden Kit while maintaining existing command names and directory structure.
