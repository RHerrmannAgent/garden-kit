<div align="center">
    <img src="./media/logo_small.webp" alt="Garden Kit Logo"/>
    <h1>Garden Kit</h1>
    <h3><em>Plan, plant, and care for thriving gardens with clarity.</em></h3>
</div>

<p align="center">
    <strong>An open source toolkit for transforming garden ideas into actionable, season-ready plans.</strong>
</p>

<p align="center">
    <a href="https://github.com/github/spec-kit/actions/workflows/release.yml"><img src="https://github.com/github/spec-kit/actions/workflows/release.yml/badge.svg" alt="Release"/></a>
    <a href="https://github.com/github/spec-kit/stargazers"><img src="https://img.shields.io/github/stars/github/spec-kit?style=social" alt="GitHub stars"/></a>
    <a href="https://github.com/github/spec-kit/blob/main/LICENSE"><img src="https://img.shields.io/github/license/github/spec-kit" alt="License"/></a>
    <a href="https://github.github.io/spec-kit/"><img src="https://img.shields.io/badge/docs-GitHub_Pages-blue" alt="Documentation"/></a>
</p>

---

## Table of Contents
- [🌿 What is Garden-Driven Planning?](#-what-is-garden-driven-planning)
- [🧭 Get Started](#-get-started)
- [🤝 Supported AI Gardening Assistants](#-supported-ai-gardening-assistants)
- [🪴 Garden Kit CLI Reference](#-garden-kit-cli-reference)
- [🌱 Core Philosophy](#-core-philosophy)
- [📅 Garden Planning Phases](#-garden-planning-phases)
- [📚 Sample Assets](#-sample-assets)
- [🧪 Validation & Tool Inventory](#-validation--tool-inventory)
- [🔍 Learn More](#-learn-more)
- [🧰 Troubleshooting](#-troubleshooting)
- [🙋 Maintainers](#-maintainers)
- [🤗 Support](#-support)
- [📜 License](#-license)

## 🌿 What is Garden-Driven Planning?

Garden-Driven Planning (GDP) adapts specification-first thinking to horticulture. Instead of jumping straight into planting, Garden Kit helps you articulate the vision for your landscape, document site realities, capture the tools you have on hand, and produce a reliable action schedule before any soil is turned.

Specs become living blueprints for the garden. Plans describe the layout, planting sequences, irrigation, and seasonal care in language that gardeners understand. Tasks translate those decisions into step-by-step work that can be handed to volunteers, contractors, or AI assistants. Every artifact is written in plain language, so the entire team shares the same mental model of the garden.

## 🧭 Get Started

### 1. Install the Garden Kit CLI

`ash
uv tool install gardify-cli --from git+https://github.com/github/spec-kit.git
`

Usage:

`ash
gardify init my-garden
gardify check
`

Update the tool when new templates ship:

`ash
uv tool install gardify-cli --force --from git+https://github.com/github/spec-kit.git
`

Prefer one-off usage?

`ash
uvx --from git+https://github.com/github/spec-kit.git gardify init my-garden
`

### 2. Establish Garden Principles

Launch your favourite AI gardening assistant in the project directory. Garden Kit exposes /gardenkit.* commands to guide the conversation. Start by defining your guiding principles and any constraints (community rules, sustainability goals, water limits) with:

`ash
/gardenkit.constitution Create principles that prioritise soil health, pollinator support, and year-round interest
`

### 3. Capture the Garden Vision

Describe the dream for your space:

`ash
/gardenkit.gardify I want a kitchen garden with raised beds, herbs near the back door, and berry bushes along the fence. The space gets morning sun and clay soil.
`

The command produces a garden vision document describing zones, goals, and success measures.

### 4. Craft the Garden Layout Plan

Translate the vision into a layout, resources, and sequencing. Specify site conditions, tooling, and legacy plant decisions:

`ash
/gardenkit.plan Raised beds will be cedar, irrigation is drip-based, and we only have hand tools plus a compact tiller.
`

This step creates research notes, catalogues existing plantings, drafts planting schemas, builds seasonal and monthly care plans, and records the gardener's available tools in 	ools.md.

### 5. Generate the Task Schedule

Break the plan into actionable work packages:

`ash
/gardenkit.tasks
`

The tool inventory and monthly care plan are cross-referenced so you can adjust tasks or borrow equipment before work starts.

### 6. Bring the Garden to Life

Execute the tasks in order:

`ash
/gardenkit.implement
`

The assistant checks safety lists, ensures required tools are ready, and walks through each task until the plan is complete.

## 🤝 Supported AI Gardening Assistants

| Assistant | Support | Notes |
|-----------|---------|-------|
| [Claude Code](https://www.anthropic.com/claude-code) | ✅ | Great for conversational planning and research synthesis. |
| [GitHub Copilot](https://code.visualstudio.com/) | ✅ | Use inside VS Code to keep garden docs consistent. |
| [Gemini CLI](https://github.com/google-gemini/gemini-cli) | ✅ | Handy for climate research and plant selection. |
| [Cursor](https://cursor.sh/) | ✅ | IDE workflows adapt well to drafting and editing templates. |
| [Qwen Code](https://github.com/QwenLM/qwen-code) | ✅ | Strong multilingual support for global plant data. |
| [opencode](https://opencode.ai/) | ✅ | Script-friendly assistant for automating repetitive edits. |
| [Windsurf](https://windsurf.com/) | ✅ | IDE-style, perfect for collaborative garden design docs. |
| [Kilo Code](https://github.com/Kilo-Org/kilocode) | ✅ | Visual authoring for garden presentations. |
| [Auggie CLI](https://docs.augmentcode.com/cli/overview) | ✅ | Focus on safety and project governance. |
| [CodeBuddy CLI](https://www.codebuddy.ai/cli) | ✅ | Automates repetitive maintenance logs. |
| [Roo Code](https://roocode.com/) | ✅ | Ideal when pairing with others on shared docs. |
| [Codex CLI](https://github.com/openai/codex) | ✅ | Automates template transformations. |
| [Amazon Q Developer CLI](https://aws.amazon.com/developer/learning/q-developer-cli/) | ⚠️ | Limited support for slash-command arguments. |

## 🪴 Garden Kit CLI Reference

### Commands

| Command | Description |
|---------|-------------|
| init | Scaffold a new garden project with the latest templates and sample assets. |
| check | Verify that required tools (git, claude, gemini, cursor-agent, windsurf, qwen, opencode, codex, etc.) are available. |

### gardify init Options

| Option | Description |
|--------|-------------|
| --ai | Pick the assistant you plan to use (claude, gemini, copilot, etc.). |
| --script | Choose script flavour: sh (bash/zsh) or ps (PowerShell). |
| --ignore-agent-tools | Skip AI tool checks. |
| --no-git | Disable git repository initialisation. |
| --here | Scaffold into the current directory. |
| --force | Overwrite conflicting files when using --here. |
| --skip-tls | Disable TLS verification (not recommended). |
| --debug | Verbose logs to troubleshoot network/template issues. |
| --github-token | Provide a token for release downloads and rate limits. |

### Example Workflows

`ash
# Create a fresh garden project with Claude
gardify init backyard-oasis --ai claude

# Scaffold garden docs into the current directory using PowerShell scripts
gardify init . --ai gemini --script ps

# Generate tasks with windsurf workflows and preflight tool checks
gardify init pollinator-haven --ai windsurf
`

## 🌱 Core Philosophy

Garden Kit is built on five guiding ideas:

1. **Intent First** – Start with the vision for the space and the experience you want.
2. **Context Before Action** – Capture soil, sunlight, climate, wildlife, available tools, and established plants.
3. **Seasonal Accountability** – Plans articulate success across seasons, not just at planting.
4. **Team-Friendly Docs** – Every artifact is designed for gardeners, volunteers, and AI assistants alike.
5. **Iterate with Nature** – Plans invite observation, adaptation, and gentle experimentation.

## 📅 Garden Planning Phases

1. **Garden Vision** – Capture goals, themes, and desired experiences (/gardenkit.gardify).
2. **Site Research** – Document soil tests, climate realities, local guidelines (site-research.md).
3. **Established Plant Inventory** – Record legacy trees, shrubs, and perennials with keep/relocate/remove decisions (existing-plant-inventory.md).
4. **Layout Planning** – Map zones, plant selections, irrigation, and hardscaping (plan.md, planting-schema.md).
5. **Tool Inventory** – Record every tool, appliance, and resource you have (	ools.md).
6. **Seasonal & Monthly Care** – Outline observations and detailed task schedules (seasonal-calendar.md, monthly-care-plan.md).
7. **Task Scheduling** – Break work into phases with dependencies and seasonal timing (	asks.md).
8. **Implementation & Stewardship** – Execute tasks, log observations, update the plan through seasons.

Each phase produces tangible artifacts under specs/<garden-branch>/, making it easy to revisit past seasons or share the plan with collaborators.

## 📚 Sample Assets

The repository ships with a reference project in specs/000-sample-garden/:

- spec.md – a complete garden vision document.
- plan.md – layout and phasing for beds, trellises, and irrigation.
- site-research.md – climate and soil findings.
- existing-plant-inventory.md – established trees, shrubs, perennials, and protection notes.
- planting-schema.md – plant layers, spacing, and companion notes.
- seasonal-calendar.md – maintenance reminders across the year.
- monthly-care-plan.md – detailed month-by-month work programme.
- 	ools.md – the gear available to the gardener.
- 	asks.md – sequenced work items for preparation, planting, and upkeep.

You can copy or adapt these examples when starting a new space.

## 🧪 Validation & Tool Inventory

Before generating tasks, Garden Kit requires a current tool inventory. During /gardenkit.plan, the assistant prompts for every tool, appliance, and resource. The generated 	ools.md powers safety lists, equipment reminders, and task validation:

- Missing tools trigger warnings before tasks are drafted.
- Parallel work highlights required tools so scheduling conflicts are clear.
- Safety notes reference protective gear captured in the inventory.

## 🔍 Learn More

- [Specs & Workflow Guide](./spec-driven.md) – deep dive into Garden-Driven Planning artefacts.
- [Docs Site](https://github.github.io/spec-kit/) – hosted documentation (under renovation for gardening content).
- [CHANGELOG](./CHANGELOG.md) – release history and updates.

## 🧰 Troubleshooting

Most issues fall into one of these buckets:

- **Template download failures** – retry with --skip-tls only if you trust the network.
- **Missing AI assistants** – run gardify check to see which assistants need installation.
- **Tool inventory warnings** – update 	ools.md or adjust the plan before generating tasks.
- **Permission errors on scripts** – rerun gardify init on macOS/Linux to ensure executable bits are set.

## 🙋 Maintainers

- The GitHub Garden Kit maintainers steward the templates and CLI.
- Contributions welcome—see [CONTRIBUTING.md](./CONTRIBUTING.md).

## 🤗 Support

- Open an issue for bugs or ideas.
- Use Discussions for workflow tips and sharing garden wins.
- Visit [SUPPORT.md](./SUPPORT.md) for escalation paths.

## 📜 License

Garden Kit is available under the [MIT License](./LICENSE). Grow generously.
