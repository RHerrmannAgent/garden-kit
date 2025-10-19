---
description: "Task list template for garden implementation"
---

# Tasks: [GARDEN NAME]

**Inputs**: `spec.md`, `plan.md`, `site-research.md`, `existing-plant-inventory.md`, `planting-schema.md`, `seasonal-calendar.md`, `monthly-care-plan.md`, `tools.md`  
**Prerequisites**: Constitution check complete, tool inventory verified, plan phases approved.

**Reminder**: Validation tasks refer to garden checks (soil tests, irrigation flushes, observation walks). Include them only when requested in the plan or vision.

**Organisation**: Tasks are grouped by phase and scenario so work can progress in manageable, independent segments.

---

## Format: `[ID] [P?] [Phase/Scenario?] Description`

- **[P]**: Use `[P]` when work can occur in parallel without conflicting over tools or space.
- **[Phase]**: Reference the phase or scenario (e.g., `PH0`, `SC1`) to keep traceability.
- Include exact locations, beds, or structures in every description.
- Always check `tools.md` and note required tools in the description when capacity is limited.

Examples:
- `- [ ] T001 PH0 Mark out raised beds in Zone A using stakes and twine (requires 2 stakes set)`
- `- [ ] T005 [P] PH1 Install drip header in Zone A with 25 mm mainline (requires pipe cutter)`
- `- [ ] T012 [P] SC1 Direct sow lettuce in Bed A2 (requires fine rake, spacing per planting-schema.md)`
- `- [ ] Prepare soil` (missing ID, location, tool context)

---

## Phase 0: Site Preparation (Shared Infrastructure)

**Purpose**: Prepare the site so subsequent planting phases can start without delays.

- [ ] T001 PH0 Conduct soil amendments in Zone A per `plan.md` (requires wheelbarrow, spade)
- [ ] T002 [P] PH0 Grade and level seating area in Zone B (requires spirit level, tamper)
- [ ] T003 PH0 Install landscape fabric under gravel paths (requires utility knife, pins)
- [ ] T004 [P] PH0 Test irrigation water pressure at main connection (requires pressure gauge)
- [ ] T005 PH0 Install protection fencing around legacy trees flagged in `existing-plant-inventory.md` (requires stakes, signage)

---

## Phase 1: Structural Build (Blocking Prerequisites)

**Purpose**: Construct hardscape and infrastructure that all scenarios rely on.

- [ ] T006 PH1 Assemble raised beds in Zone A using cedar kits (requires drill, driver bits)
- [ ] T007 [P] PH1 Set pergola posts in Zone B with concrete footing (requires post-hole digger)
- [ ] T008 PH1 Lay 2.5 m gravel path from gate to pergola, compact in layers (requires compactor)
- [ ] T009 [P] PH1 Install main drip line and valves in Zones A and C (requires pipe wrench)
- [ ] T010 PH1 Relocate herbs identified in `existing-plant-inventory.md` before construction (requires transplant spade)

**Checkpoint**: Structural elements complete; phases for planting can proceed.

---

## Phase 2: Scenario 1 – [Title] (Priority: P1)

**Goal**: [Describe the experience/outcome this scenario delivers.]

**Independent Observation**: [How success will be evaluated for this scenario.]

### Validation (Optional)
- [ ] T011 [P] SC1 Flush drip lines and confirm even distribution in Zone A (requires bucket)

### Implementation
- [ ] T012 SC1 Fill raised beds A1–A3 with amended soil mix (requires wheelbarrow)
- [ ] T013 [P] SC1 Plant anchor crops (e.g., tomatoes, basil) per `planting-schema.md` spacing (requires planting trowel)
- [ ] T014 SC1 Install insect netting over Bed A1 using hoops (requires clamps)
- [ ] T015 SC1 Mulch beds with 5 cm arborist chips (requires garden fork)

**Checkpoint**: Scenario 1 beds planted, mulched, and irrigated; ready for observation.

---

## Phase 3: Scenario 2 – [Title] (Priority: P2)

**Goal**: [...]

**Independent Observation**: [...]

### Validation (Optional)
- [ ] T016 [P] SC2 Test lighting levels under pergola at dusk (requires lux meter)

### Implementation
- [ ] T017 SC2 Install seating and planters in Zone B (requires socket set)
- [ ] T018 [P] SC2 Plant fragrance-focused understory around seating area (requires kneeling pad)
- [ ] T019 SC2 Set up rain chain and barrel overflow for Zone B roofline (requires ladder)

---

## Phase 4: Scenario 3 – [Title] (Priority: P3)

**Goal**: [...]

**Independent Observation**: [...]

### Validation (Optional)
- [ ] T020 [P] SC3 Conduct wildlife habitat checklist for Zone C (requires binoculars)

### Implementation
- [ ] T021 SC3 Plant berry hedge along north fence with spacing per `planting-schema.md` (requires trench spade)
- [ ] T022 [P] SC3 Install wildlife-friendly fencing and signage (requires mallet)
- [ ] T023 SC3 Add pollinator strip in front of hedge with succession sowing (requires seed spreader)

---

## Phase 5: Stewardship & Seasonal Care

- [ ] T024 STEW Compile observation prompts in `seasonal-calendar.md`
- [ ] T025 [P] STEW Confirm upcoming work in `monthly-care-plan.md` and assign responsible gardeners
- [ ] T026 STEW Sharpen pruners, loppers, and hoes; note replacements in `tools.md`
- [ ] T027 [P] STEW Update volunteer quickstart guide with safety reminders (requires laptop/assistant)
- [ ] T028 STEW Review protection measures for legacy specimens listed in `existing-plant-inventory.md`

---

## Dependencies & Execution Order

- **Phase 0 → Phase 1**: Site preparation must finish before structural installation.
- **Phase 1 → Scenarios**: Each scenario depends on structural elements and irrigation being complete.
- **Scenarios**: Work can proceed in parallel if tool availability allows; respect conflicts noted in descriptions.
- **Stewardship**: Starts after scenarios reach initial completion, continues seasonally.

### Parallel Opportunities

- Soil amendment and path installation (T001–T003) can run simultaneously with separate crews.
- Bed planting (T013) and mulching (T015) can overlap if there are enough wheelbarrows (check `tools.md`).
- Different scenario tasks marked `[P]` can run concurrently when they do not require the same tools or space.

---

## Implementation Strategy

### MVP First (Scenario 1)
1. Complete Phase 0 and Phase 1 tasks.
2. Execute Scenario 1 tasks (T011–T015).
3. Observe and log results before moving on.

### Incremental Delivery
1. Finish structural build.
2. Deliver Scenario 1, observe, adjust.
3. Deliver Scenario 2, observe, adjust.
4. Deliver Scenario 3, observe, adjust.

### Parallel Team Approach
- Team A handles soil work and raised beds.
- Team B installs irrigation and pergola.
- Team C plants and maintains Scenario 1.

---

## Notes

- Always cross-check `tools.md` and `existing-plant-inventory.md` before scheduling tasks that could disturb legacy plantings.
- Replace sample tasks with the specific activities derived from your plan, care plan, and planting schema.
- Document lessons learned in `seasonal-calendar.md`, `monthly-care-plan.md`, or `quickstart.md`.
- Update `tools.md` whenever tools are borrowed, replaced, or returned.
