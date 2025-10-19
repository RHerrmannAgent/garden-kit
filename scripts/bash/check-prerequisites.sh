#!/usr/bin/env bash
# Garden Kit prerequisite checker (Bash)

set -euo pipefail

show_help() {
    cat <<'EOF'
Usage: check-prerequisites.sh [OPTIONS]

Options:
  --json             Output data as JSON
  --require-tasks    Ensure tasks.md exists (implementation stage)
  --include-tasks    Include tasks.md in AVAILABLE_DOCS list
  --require-tools    Ensure tools.md exists before continuing
  --paths-only       Output paths without validation (combine with --json)
  --help             Show this message
EOF
}

OUTPUT_JSON=false
REQUIRE_TASKS=false
INCLUDE_TASKS=false
REQUIRE_TOOLS=false
PATHS_ONLY=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --json) OUTPUT_JSON=true ;;
        --require-tasks) REQUIRE_TASKS=true ;;
        --include-tasks) INCLUDE_TASKS=true ;;
        --require-tools) REQUIRE_TOOLS=true ;;
        --paths-only) PATHS_ONLY=true ;;
        --help|-h) show_help; exit 0 ;;
        *) echo "Unknown option: $1" >&2; show_help; exit 1 ;;
    esac
    shift
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

# shellcheck disable=SC2155
IFS=$'\n' read -r -d '' -a PATH_KV < <(get_feature_paths && printf '\0')

declare -A PATHS
for kv in "${PATH_KV[@]}"; do
    key="${kv%%=*}"
    value="${kv#*=}"
    value="${value#\'}"
    value="${value%\'}"
    PATHS[$key]="$value"
end

if ! check_feature_branch "${PATHS[CURRENT_BRANCH]}" "${PATHS[HAS_GIT]}"; then
    exit 1
fi

if $PATHS_ONLY; then
    if $OUTPUT_JSON; then
        printf '{'
        printf '"REPO_ROOT":"%s",' "${PATHS[REPO_ROOT]}"
        printf '"BRANCH":"%s",' "${PATHS[CURRENT_BRANCH]}"
        printf '"FEATURE_DIR":"%s",' "${PATHS[FEATURE_DIR]}"
        printf '"FEATURE_SPEC":"%s",' "${PATHS[FEATURE_SPEC]}"
        printf '"IMPL_PLAN":"%s",' "${PATHS[IMPL_PLAN]}"
        printf '"TASKS":"%s",' "${PATHS[TASKS]}"
        printf '"SITE_RESEARCH":"%s",' "${PATHS[SITE_RESEARCH]}"
        printf '"EXISTING_PLANTS":"%s",' "${PATHS[EXISTING_PLANTS]}"
        printf '"PLANTING_SCHEMA":"%s",' "${PATHS[PLANTING_SCHEMA]}"
        printf '"SEASONAL_CALENDAR":"%s",' "${PATHS[SEASONAL_CALENDAR]}"
        printf '"MONTHLY_CARE":"%s",' "${PATHS[MONTHLY_CARE]}"
        printf '"TOOLS":"%s",' "${PATHS[TOOLS]}"
        printf '"QUICKSTART":"%s"' "${PATHS[QUICKSTART]}"
        printf '}'
    else
        for key in REPO_ROOT CURRENT_BRANCH FEATURE_DIR FEATURE_SPEC IMPL_PLAN TASKS SITE_RESEARCH EXISTING_PLANTS PLANTING_SCHEMA SEASONAL_CALENDAR MONTHLY_CARE TOOLS QUICKSTART; do
            printf '%s: %s\n' "$key" "${PATHS[$key]}"
        done
    fi
    exit 0
fi

if [[ ! -d "${PATHS[FEATURE_DIR]}" ]]; then
    echo "ERROR: Garden directory not found: ${PATHS[FEATURE_DIR]}" >&2
    echo "Run /gardenkit.gardify first." >&2
    exit 1
fi

if [[ ! -f "${PATHS[IMPL_PLAN]}" ]]; then
    echo "ERROR: plan.md not found in ${PATHS[FEATURE_DIR]}" >&2
    echo "Run /gardenkit.plan to generate the layout plan." >&2
    exit 1
fi

if $REQUIRE_TOOLS && [[ ! -f "${PATHS[TOOLS]}" ]]; then
    echo "ERROR: tools.md not found in ${PATHS[FEATURE_DIR]}" >&2
    echo "Document the tool inventory before generating tasks." >&2
    exit 1
fi

if $REQUIRE_TASKS && [[ ! -f "${PATHS[TASKS]}" ]]; then
    echo "ERROR: tasks.md not found in ${PATHS[FEATURE_DIR]}" >&2
    echo "Run /gardenkit.tasks before implementation." >&2
    exit 1
fi

AVAILABLE_DOCS=()
[[ -f "${PATHS[SITE_RESEARCH]}" ]] && AVAILABLE_DOCS+=("site-research.md")
[[ -f "${PATHS[EXISTING_PLANTS]}" ]] && AVAILABLE_DOCS+=("existing-plant-inventory.md")
[[ -f "${PATHS[PLANTING_SCHEMA]}" ]] && AVAILABLE_DOCS+=("planting-schema.md")
[[ -f "${PATHS[SEASONAL_CALENDAR]}" ]] && AVAILABLE_DOCS+=("seasonal-calendar.md")
[[ -f "${PATHS[MONTHLY_CARE]}" ]] && AVAILABLE_DOCS+=("monthly-care-plan.md")
[[ -f "${PATHS[QUICKSTART]}" ]] && AVAILABLE_DOCS+=("quickstart.md")
[[ -f "${PATHS[TOOLS]}" ]] && AVAILABLE_DOCS+=("tools.md")
if $INCLUDE_TASKS && [[ -f "${PATHS[TASKS]}" ]]; then
    AVAILABLE_DOCS+=("tasks.md")
fi

if $OUTPUT_JSON; then
    printf '{"FEATURE_DIR":"%s","AVAILABLE_DOCS":[' "${PATHS[FEATURE_DIR]}"
    for ((i=0; i<${#AVAILABLE_DOCS[@]}; i++)); do
        printf '"%s"' "${AVAILABLE_DOCS[$i]}"
        if (( i < ${#AVAILABLE_DOCS[@]} - 1 )); then
            printf ','
        fi
    done
    printf ']}'
else
    echo "FEATURE_DIR:${PATHS[FEATURE_DIR]}"
    echo "AVAILABLE_DOCS:"
    check_file "${PATHS[SITE_RESEARCH]}" 'site-research.md'
    check_file "${PATHS[EXISTING_PLANTS]}" 'existing-plant-inventory.md'
    check_file "${PATHS[PLANTING_SCHEMA]}" 'planting-schema.md'
    check_file "${PATHS[SEASONAL_CALENDAR]}" 'seasonal-calendar.md'
    check_file "${PATHS[MONTHLY_CARE]}" 'monthly-care-plan.md'
    check_file "${PATHS[TOOLS]}" 'tools.md'
    check_file "${PATHS[QUICKSTART]}" 'quickstart.md'
    if $INCLUDE_TASKS; then
        check_file "${PATHS[TASKS]}" 'tasks.md'
    fi
fi
