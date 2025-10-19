## About Garden Kit and gardify

**GitHub Garden Kit** helps gardeners capture their intent, site realities, and tool inventory before any beds are dug. It packages a set of templates, scripts, and workflows that enforce Garden-Driven Planning (GDP)—a methodology that prioritises clear gardening documentation and seasonal validation.

**gardify CLI** scaffolds new garden projects that follow the Garden Kit conventions. It creates the folders, templates, and AI assistant commands needed to progress from garden vision to execution.

Garden Kit supports multiple AI assistants so teams can use their preferred tool while keeping a consistent garden-planning workflow.

---

## General Practices

- Any changes to `__init__.py` for the gardify CLI still require a version bump in `pyproject.toml` and matching entries in `CHANGELOG.md`.
- When adding new assistants or editing commands, keep terminology aligned with garden planning (zones, beds, seasonal tasks, tool inventory).

---

## Adding New Assistant Support

Follow these steps to integrate a new AI gardening assistant into gardify.

### 1. Extend `AGENT_CONFIG`

Add the new assistant to `AGENT_CONFIG` inside `src/gardify_cli/__init__.py`. Use the **actual executable name** as the key—the name gardeners type in their terminal.

```python
AGENT_CONFIG = {
    # ... existing assistants ...
    "new-garden-cli": {
        "name": "New Garden Assistant",
        "folder": ".newgarden/",
        "install_url": "https://example.com/install",
        "requires_cli": True,
    },
}
```

Fields:
- `name`: Friendly name shown in prompts.
- `folder`: Directory created in the project (relative to root).
- `install_url`: Documentation for installation (or `None` if embedded in an IDE).
- `requires_cli`: `True` if the gardener must install a CLI before using the assistant.

### 2. Update CLI Help Text

Expand the `--ai` option in `init()` so gardeners see the new assistant in the list, plus any docstrings or error messages that enumerate assistants.

### 3. Refresh Documentation

Update the Supported AI Gardening Assistants table in `README.md`:
- Add the assistant with support level (Full/Experimental).
- Link to the official product page.
- Note any garden-specific strengths (e.g., climate research, irrigation planning).

### 4. Adjust Release Packaging

- `.github/workflows/scripts/create-release-packages.sh` – append the new assistant to `ALL_AGENTS` and extend the case statement so its directory structure is scaffolded correctly.
- `.github/workflows/scripts/create-github-release.sh` – include the resulting zip files in GitHub releases.

### 5. Update Agent Context Scripts

Add the assistant to both context scripts so `/gardenkit.plan` can refresh its knowledge base:

- `scripts/bash/update-agent-context.sh`
- `scripts/powershell/update-agent-context.ps1`

Follow the patterns already present for other assistants.

### 6. Tool Checks (Optional)

If the assistant requires a CLI, ensure `requires_cli` is `True`. The `check()` and `init()` flows automatically prompt gardeners when a required tool is missing.

---

## Important Design Decisions

- **Executable Names as Keys**: Match the CLI tool exactly (e.g., `"cursor-agent"`, not `"cursor"`). Tool checks rely on `shutil.which`, so shortcuts create maintenance problems.
- **Garden Vocabulary**: All assistant descriptions should reference garden planning concepts—never software terms.
- **Consistent Directories**: Assistants that write files should follow existing patterns (e.g., `.assistant/commands/`) unless there’s a strong reason to diverge.

---

## Current Supported Assistants

| Assistant | Directory | Format | CLI Tool | Notes |
|-----------|-----------|--------|----------|-------|
| Claude Code | `.claude/commands/` | Markdown | `claude` | Conversational planning. |
| Gemini CLI | `.gemini/commands/` | TOML | `gemini` | Research-heavy workflows. |
| GitHub Copilot | `.github/prompts/` | Markdown | N/A | IDE-based templating. |
| Cursor | `.cursor/commands/` | Markdown | `cursor-agent` | IDE/CLI hybrid. |
| Qwen Code | `.qwen/commands/` | TOML | `qwen` | Multilingual horticulture data. |
| opencode | `.opencode/command/` | Markdown | `opencode` | Automation scripts. |
| Codex CLI | `.codex/commands/` | Markdown | `codex` | Template transformation. |
| Windsurf | `.windsurf/workflows/` | Markdown | N/A | Visual workflows. |
| Kilo Code | `.kilocode/rules/` | Markdown | N/A | Presentation authoring. |
| Auggie CLI | `.augment/rules/` | Markdown | `auggie` | Governance and safety. |
| Roo Code | `.roo/rules/` | Markdown | N/A | Pair-assistant editing. |
| CodeBuddy CLI | `.codebuddy/commands/` | Markdown | `codebuddy` | Task automation. |
| Amazon Q Developer CLI | `.amazonq/prompts/` | Markdown | `q` | Limited slash-command support. |

---

## Assistant Categories

### CLI-Based
Require installation and PATH access:
- Claude Code (`claude`)
- Gemini CLI (`gemini`)
- Cursor (`cursor-agent`)
- Qwen Code (`qwen`)
- opencode (`opencode`)
- Codex CLI (`codex`)
- Auggie CLI (`auggie`)
- CodeBuddy CLI (`codebuddy`)
- Amazon Q Developer CLI (`q`)

### IDE-Based
Provide in-app experiences:
- GitHub Copilot
- Windsurf
- Kilo Code
- Roo Code

---

## Adding Garden-Specific Knowledge

When introducing a new assistant:
- Highlight how it supports gardeners (e.g., lighting analysis, irrigation design).
- Ensure command files reference garden artefacts (`site-research.md`, `existing-plant-inventory.md`, `planting-schema.md`, `tools.md`, `monthly-care-plan.md`).
- Update the docstrings for `/gardenkit.plan` and `/gardenkit.tasks` so assistants know to respect the tool inventory step.

---

Keep this guide fresh whenever assistant support changes so gardeners always have accurate integration instructions.
