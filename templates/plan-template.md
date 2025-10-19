# Garden Layout Plan: [GARDEN NAME]

**Branch**: `[###-garden-name]` | **Date**: [DATE] | **Vision**: [link to spec.md]  
**Inputs**: Garden vision, site research, gardener interviews.

> This template is filled by `/gardenkit.plan`. See `.gardify/templates/commands/plan.md` for the detailed workflow.

---

## Summary

[Describe the overall intent of the garden, key experiences, and any constraints discovered so far.]

---

## Site Conditions & Research Highlights

Use findings from `site-research.md` or conduct new observations.

- **Soil Profile**: [Texture, pH, organic matter, amendments needed or NEEDS CLARIFICATION]
- **Sun & Shade**: [Hours of light per zone, shade sources, seasonal shifts]
- **Water Sources**: [Rain capture, irrigation type, municipal supply limitations]
- **Microclimates**: [Frost pockets, wind tunnels, reflective surfaces]
- **Wildlife & Pollinators**: [Common visitors, desired support strategies, sensitive habitats]
- **Community & Access Rules**: [Noise limits, accessibility requirements, shared-tool etiquette]

---

## Constitution Check

*Gate: Confirm the garden vision aligns with the constitution before proceeding.*

- **Principle Alignment**: [List each core principle and how this plan honours it.]
- **Adjustments Needed**: [Note any conflicts to resolve.]

Revisit this section after completing the planting schema and stewardship planning.

---

## Garden Artefacts & Directory Layout

```
specs/[###-garden-name]/
├── plan.md                   # This file
├── site-research.md          # Environmental findings
├── existing-plant-inventory.md   # Established trees, shrubs, perennials
├── planting-schema.md        # Plant layers, companions, spacing
├── seasonal-calendar.md      # Seasonal observations and reminders
├── monthly-care-plan.md      # Detailed month-by-month task breakdown
├── tools.md                  # Tool and resource inventory
├── quickstart.md             # Orientation for volunteers/visitors
├── tasks.md                  # Generated later via /gardenkit.tasks
└── media/                    # Optional sketches, maps, photos
```

---

## Physical Layout Overview

Summarise the spaces, structures, and flows you will create. Delete options that do not apply.

```
Zones & Beds
├── Zone A: [Name] – [Dimensions, purpose, sun exposure]
│   ├── Bed A1 – [Raised/in-ground, soil depth, irrigation type]
│   └── Bed A2 – [...]
├── Zone B: [e.g., Gathering space with pergola and seating]
└── Zone C: [e.g., Berry hedge along north fence]

Paths & Access
├── Main Path – [Material, width, accessibility notes]
└── Secondary Paths – [Material, gradient notes]

Water & Utilities
├── Irrigation – [Drip, soaker, manual schedule]
├── Rainwater Storage – [Cistern capacity, overflow path]
└── Electrical – [Lighting, pumps, safety considerations]
```

**Layout Rationale**: [Explain why this arrangement fits the intent and site conditions.]

---

## Tool & Resource Inventory *(mandatory)*

Record every tool, appliance, and resource available. This table must be completed before `/gardenkit.tasks` runs. Copy the final table into `tools.md`.

| Tool / Resource | Qty / Access | Condition | Stored At | Notes |
|-----------------|--------------|-----------|-----------|-------|
| [e.g., Spade]   | [1]          | [Excellent] | [Shed]  | [Sharpened March 2025] |
| [e.g., Wheelbarrow] | [Shared] | [Needs tire check] | [Community shed] | |
| [e.g., Drip timer] | [2] | [Working] | [Utility locker] | [Requires batteries] |
| [e.g., Protective gloves] | [4 pairs] | [Good] | [Tool chest] | |

Include PPE, compost bins, hoses, irrigation fittings, stakes, netting, soil amendments, and any borrowed or rentable equipment. Note lead times for rentals or deliveries.

---

## Planting Schema Snapshot

- **Anchor Plantings**: [Trees, shrubs, key perennials providing structure.]
- **Understory & Companions**: [Layering strategy, groundcovers, annual rotations.]
- **Edible Production**: [Crop rotation plan, succession sowing schedule.]
- **Habitat Features**: [Pollinator strips, bird habitat, water features.]
- **Spacing & Height Considerations**: [Canopy spread, airflow, sightlines.]

The detailed reference belongs in `planting-schema.md`, but capture highlights here.

---

## Established Plant Inventory Overview

Summarise key findings from `existing-plant-inventory.md` so legacy plantings are respected:

- **Must-Preserve Specimens**: [List with protection requirements]
- **Relocation Candidates**: [Plants to move before construction and why]
- **Removal Plan**: [Specimens scheduled for removal, timing, disposal notes]
- **Root Zone Constraints**: [Areas where digging/trenching must be avoided]

Explain how existing plants influence new layouts, shading, soil conditions, wildlife commitments, and irrigation planning.

---

## Seasonal Strategy & Phases

### Phase 0 – Site Preparation
- [Grading, soil improvement, hardscape installation.]

### Phase 1 – Structural Build
- [Raised beds, trellises, pergolas, irrigation infrastructure.]

### Phase 2 – Primary Planting
- [Anchors, trees, shrubs, long-lived perennials.]

### Phase 3 – Secondary Planting
- [Annuals, succession crops, container plantings, understory.]

### Phase 4 – Stewardship
- [Mulch refresh, irrigation tuning, pruning, compost management, observation logs.]

For each phase note timing, dependencies, responsible parties, required tools, and cross-reference relevant months in `monthly-care-plan.md`.

---

## Monthly Care Overview

Highlight the most important activities captured in `monthly-care-plan.md`:

- **Priority Work Windows**: [e.g., “March – install trellises”, “July – deadhead pollinator strip”.]
- **Volunteer / Work Party Dates**: [Schedule and goals.]
- **Observation Prompts**: [Data to capture that feeds success criteria.]

Ensure the monthly plan aligns with seasonal phases and informs task generation.

---

## Risk & Contingency Planning

- **Weather Extremes**: [Frost blankets, shade cloth, wind barriers, drought measures.]
- **Pests & Wildlife**: [Netting, organic controls, habitat balance strategies.]
- **Resource Constraints**: [Volunteer availability, budget, delivery windows.]
- **Health & Safety**: [Protective gear, ergonomic considerations, signage.]

---

## Observation & Feedback Loops

- **Monitoring Schedule**: [How often to walk the site and log observations.]
- **Data to Capture**: [Bloom times, harvest yields, pest sightings, soil moisture.]
- **Adaptation Process**: [How adjustments are recorded and communicated.]

---

## Open Questions & Follow-Ups

1. [Clarification needed from stakeholders or authorities?]
2. [Outstanding measurement or survey to collect?]
3. [Tool acquisition, plant sourcing, or scheduling uncertainties?]

Resolve all open questions before generating tasks.
