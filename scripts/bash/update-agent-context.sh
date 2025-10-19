#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

eval "$(get_feature_paths)"

PLAN_PATH="$IMPL_PLAN"
SPEC_PATH="$FEATURE_SPEC"
TOOLS_PATH="$TOOLS"
CLAUDE_FILE="$REPO_ROOT/CLAUDE.md"
GEMINI_FILE="$REPO_ROOT/GEMINI.md"
COPILOT_FILE="$REPO_ROOT/.github/copilot-instructions.md"
CURSOR_FILE="$REPO_ROOT/.cursor/rules/gardify-rules.mdc"
QWEN_FILE="$REPO_ROOT/QWEN.md"
AGENTS_FILE="$REPO_ROOT/AGENTS.md"
WINDSURF_FILE="$REPO_ROOT/.windsurf/rules/gardify-rules.md"
KILOCODE_FILE="$REPO_ROOT/.kilocode/rules/gardify-rules.md"
AUGGIE_FILE="$REPO_ROOT/.augment/rules/gardify-rules.md"
ROO_FILE="$REPO_ROOT/.roo/rules/gardify-rules.md"
CODEBUDDY_FILE="$REPO_ROOT/CODEBUDDY.md"
Q_FILE="$REPO_ROOT/AGENTS.md"
SEASONAL_PATH="$SEASONAL_CALENDAR"
PLANTING_PATH="$PLANTING_SCHEMA"

if [[ ! -f "$PLAN_PATH" ]]; then
  echo "ERROR: plan.md not found at $PLAN_PATH" >&2
  exit 1
fi

DATE_STAMP="$(date +%Y-%m-%d)"
BRANCH_NAME="$CURRENT_BRANCH"
GARDEN_SLUG="${BRANCH_NAME#???-}"
GARDEN_TITLE="$(echo "$GARDEN_SLUG" | tr '-' ' ' | sed -E 's/.*/\u&/' )"

if [[ -f "$SPEC_PATH" ]]; then
  TITLE_FROM_SPEC=$(grep -m1 '^# ' "$SPEC_PATH" | sed -E 's/^# [^:]+: ?//')
  if [[ -n "$TITLE_FROM_SPEC" ]]; then
    GARDEN_TITLE="$TITLE_FROM_SPEC"
  fi
fi

extract_section() {
  local heading="$1" file="$2"
  python - <<'PY'
import re,sys
heading=sys.argv[1]
path=sys.argv[2]
text=open(path,encoding='utf-8').read()
pattern=re.compile(r'^## '+re.escape(heading)+r'\n(.*?)(?=^## |\Z)', re.M|re.S)
match=pattern.search(text)
if match:
    print(match.group(1).strip())
PY
 "$heading" "$file"
}

summarise_bullets() {
  local section="$1" limit="$2"
  python - <<'PY'
import sys
section=sys.argv[1]
limit=int(sys.argv[2])
lines=[l.strip('- ').strip() for l in section.splitlines() if l.strip().startswith('-')]
lines=[l for l in lines if l]
print(' / '.join(lines[:limit]))
PY
 "$section" "$limit"
}

SUMMARY_SECTION="$(extract_section "Summary" "$PLAN_PATH")"
SITE_SECTION="$(extract_section "Site Conditions & Research Highlights" "$PLAN_PATH")"
PLANTING_SECTION="$(extract_section "Planting Schema Snapshot" "$PLAN_PATH")"
TOOLS_SECTION="$(extract_section "Tool & Resource Inventory *(mandatory)*" "$PLAN_PATH" || true)"
if [[ -z "$TOOLS_SECTION" ]]; then
  TOOLS_SECTION="$(extract_section "Tool & Resource Inventory" "$PLAN_PATH")"
fi
SAFETY_SECTION="$(extract_section "Risk & Contingency Planning" "$PLAN_PATH")"
OPEN_SECTION="$(extract_section "Open Questions & Follow-Ups" "$PLAN_PATH")"

SUMMARY_LINE="$(echo "$SUMMARY_SECTION" | sed -n '1p' | sed 's/\r//g')"
SITE_HIGHLIGHTS="$(summarise_bullets "$SITE_SECTION" 3)"
PLANTING_HIGHLIGHTS="$(summarise_bullets "$PLANTING_SECTION" 3)"
SAFETY_HIGHLIGHTS="$(summarise_bullets "$SAFETY_SECTION" 3)"
OPEN_ITEMS="$(summarise_bullets "$OPEN_SECTION" 3)"

if [[ -f "$TOOLS_PATH" ]]; then
  TOOL_SUMMARY=$(python - <<'PY'
import sys
path=sys.argv[1]
rows=[]
with open(path,encoding='utf-8') as fh:
    for line in fh:
        line=line.strip()
        if not line.startswith('|') or 'Tool / Resource' in line or '---' in line:
            continue
        parts=[p.strip() for p in line.strip('|').split('|')]
        if len(parts)>=3:
            rows.append(f"{parts[0]} ({parts[1]}, {parts[2]})")
        if len(rows)==3:
            break
print(' / '.join(rows))
PY
 "$TOOLS_PATH")
else
  TOOL_SUMMARY="Tool inventory pending"
fi

if [[ -f "$PLANTING_PATH" ]]; then
  ZONE_SUMMARY=$(python - <<'PY'
import sys,re
text=open(sys.argv[1],encoding='utf-8').read()
zones=[m.group(1).strip() for m in re.finditer(r'- \*\*(.+?)\*\*', text)]
print(', '.join(zones[:3]))
PY
 "$PLANTING_PATH")
else
  ZONE_SUMMARY="See planting-schema.md"
fi

if [[ -f "$SEASONAL_PATH" ]]; then
  SEASON_WINDOW=$(python - <<'PY'
import sys
rows=[]
with open(sys.argv[1],encoding='utf-8') as fh:
    for line in fh:
        line=line.strip()
        if not line.startswith('|') or 'Month/Window' in line or '---' in line:
            continue
        month=line.strip('|').split('|')[0].strip()
        rows.append(month)
        if len(rows)>=2:
            break
if rows:
    if len(rows)==1:
        print(rows[0])
    else:
        print(f"{rows[0]} – {rows[-1]}")
else:
    print("See seasonal-calendar.md")
PY
 "$SEASONAL_PATH")
else
  SEASON_WINDOW="See seasonal-calendar.md"
fi

Garden_Snapshot() {
  cat <<EOF
## Garden Snapshot
- Highlights: ${SUMMARY_LINE:-Refer to plan summary}
- Zones in focus: ${ZONE_SUMMARY:-See planting schema}
- Season window: ${SEASON_WINDOW}
EOF
}

Planting_Care() {
  cat <<EOF
## Planting & Care Priorities
- ${PLANTING_HIGHLIGHTS:-Review planting-schema.md for full details}
- ${SITE_HIGHLIGHTS:-Consult plan.md for site specifics}
EOF
}

Tool_Notes() {
  cat <<EOF
## Tool Inventory Notes
- ${TOOL_SUMMARY:-Update tools.md with available equipment}
EOF
}

Safety_Guidelines() {
  cat <<EOF
## Safety & Stewardship Guidelines
- ${SAFETY_HIGHLIGHTS:-Review plan.md risk section}
EOF
}

Recent_Changes() {
  cat <<EOF
## Recent Changes
- ${OPEN_ITEMS:-No open questions recorded}
EOF
}

ensure_agent_file() {
  local file="$1"
  mkdir -p "$(dirname "$file")"
  if [[ ! -f "$file" && -f "$TEMPLATE_FILE" ]]; then
    cp "$TEMPLATE_FILE" "$file"
  fi
}

update_agent_file() {
  local file="$1" label="$2"
  ensure_agent_file "$file"
  local manual=""
  if [[ -f "$file" ]]; then
    manual=$(awk '/<!-- MANUAL ADDITIONS START -->/{flag=1;next}/<!-- MANUAL ADDITIONS END -->/{flag=0;next}flag{print}' "$file")
  fi
  cat <<EOF >"$file"
# ${GARDEN_TITLE} Stewardship Brief
Auto-generated from current garden plans. Last updated: ${DATE_STAMP}

$(Garden_Snapshot)

$(Planting_Care)

$(Tool_Notes)

$(Safety_Guidelines)

$(Recent_Changes)

<!-- MANUAL ADDITIONS START -->
${manual}
<!-- MANUAL ADDITIONS END -->
EOF
  echo "Updated $label context at $file"
}

TEMPLATE_FILE="$REPO_ROOT/.gardify/templates/agent-file-template.md"

AGENT_TYPE="${1:-}"

update_all() {
  local found=false
  if [[ -f "$CLAUDE_FILE" ]]; then update_agent_file "$CLAUDE_FILE" "Claude"; found=true; fi
  if [[ -f "$GEMINI_FILE" ]]; then update_agent_file "$GEMINI_FILE" "Gemini"; found=true; fi
  if [[ -f "$COPILOT_FILE" ]]; then update_agent_file "$COPILOT_FILE" "Copilot"; found=true; fi
  if [[ -f "$CURSOR_FILE" ]]; then update_agent_file "$CURSOR_FILE" "Cursor"; found=true; fi
  if [[ -f "$QWEN_FILE" ]]; then update_agent_file "$QWEN_FILE" "Qwen"; found=true; fi
  if [[ -f "$AGENTS_FILE" ]]; then update_agent_file "$AGENTS_FILE" "Agent summary"; found=true; fi
  if [[ -f "$WINDSURF_FILE" ]]; then update_agent_file "$WINDSURF_FILE" "Windsurf"; found=true; fi
  if [[ -f "$KILOCODE_FILE" ]]; then update_agent_file "$KILOCODE_FILE" "Kilo Code"; found=true; fi
  if [[ -f "$AUGGIE_FILE" ]]; then update_agent_file "$AUGGIE_FILE" "Auggie"; found=true; fi
  if [[ -f "$ROO_FILE" ]]; then update_agent_file "$ROO_FILE" "Roo"; found=true; fi
  if [[ -f "$CODEBUDDY_FILE" ]]; then update_agent_file "$CODEBUDDY_FILE" "CodeBuddy"; found=true; fi
  if [[ -f "$Q_FILE" ]]; then update_agent_file "$Q_FILE" "Amazon Q"; found=true; fi
  if [[ "$found" == false ]]; then
    update_agent_file "$CLAUDE_FILE" "Claude"
  fi
}

update_specific() {
  case "$1" in
    claude) update_agent_file "$CLAUDE_FILE" "Claude" ;;
    gemini) update_agent_file "$GEMINI_FILE" "Gemini" ;;
    copilot) update_agent_file "$COPILOT_FILE" "Copilot" ;;
    cursor-agent) update_agent_file "$CURSOR_FILE" "Cursor" ;;
    qwen) update_agent_file "$QWEN_FILE" "Qwen" ;;
    opencode|codex) update_agent_file "$AGENTS_FILE" "Agent summary" ;;
    windsurf) update_agent_file "$WINDSURF_FILE" "Windsurf" ;;
    kilocode) update_agent_file "$KILOCODE_FILE" "Kilo Code" ;;
    auggie) update_agent_file "$AUGGIE_FILE" "Auggie" ;;
    roo) update_agent_file "$ROO_FILE" "Roo" ;;
    codebuddy) update_agent_file "$CODEBUDDY_FILE" "CodeBuddy" ;;
    q) update_agent_file "$Q_FILE" "Amazon Q" ;;
    *) echo "ERROR: Unknown agent type $1" >&2; exit 1 ;;
  esac
}

if [[ -z "$AGENT_TYPE" ]]; then
  update_all
else
  update_specific "$AGENT_TYPE"
fi
