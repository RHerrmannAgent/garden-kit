#!/usr/bin/env bash

set -euo pipefail

JSON_MODE=false

for arg in "$@"; do
    case "$arg" in
        --json) JSON_MODE=true ;;
        --help|-h)
            cat <<'EOF'
Usage: setup-plan.sh [--json]
  --json    Output results in JSON format
  --help    Show this help message
EOF
            exit 0
            ;;
        *)
            echo "Unknown option: $arg" >&2
            exit 1
            ;;
    esac
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
done

if ! check_feature_branch "${PATHS[CURRENT_BRANCH]}" "${PATHS[HAS_GIT]}"; then
    exit 1
fi

mkdir -p "${PATHS[FEATURE_DIR]}"

template_dir="${PATHS[REPO_ROOT]}/.gardify/templates"

copy_or_create() {
    local template_name="$1"
    local dest="$2"
    local source="$template_dir/$template_name"

    if [[ -f "$source" ]]; then
        cp "$source" "$dest"
        echo "Copied $template_name to $dest"
    else
        if [[ ! -f "$dest" ]]; then
            touch "$dest"
        fi
        echo "Warning: $template_name not found under $template_dir. Created empty file at $dest" >&2
    fi
}

copy_or_create "plan-template.md" "${PATHS[IMPL_PLAN]}"
copy_or_create "site-research-template.md" "${PATHS[SITE_RESEARCH]}"
copy_or_create "existing-plant-inventory-template.md" "${PATHS[EXISTING_PLANTS]}"
copy_or_create "planting-schema-template.md" "${PATHS[PLANTING_SCHEMA]}"
copy_or_create "seasonal-calendar-template.md" "${PATHS[SEASONAL_CALENDAR]}"
copy_or_create "monthly-care-template.md" "${PATHS[MONTHLY_CARE]}"
copy_or_create "tools-template.md" "${PATHS[TOOLS]}"
copy_or_create "quickstart-template.md" "${PATHS[QUICKSTART]}"

if $JSON_MODE; then
    printf '{"FEATURE_SPEC":"%s","IMPL_PLAN":"%s","SPECS_DIR":"%s","BRANCH":"%s","HAS_GIT":"%s","SITE_RESEARCH":"%s","EXISTING_PLANTS":"%s","PLANTING_SCHEMA":"%s","SEASONAL_CALENDAR":"%s","MONTHLY_CARE":"%s","TOOLS":"%s","QUICKSTART":"%s"}\n' \
        "${PATHS[FEATURE_SPEC]}" "${PATHS[IMPL_PLAN]}" "${PATHS[FEATURE_DIR]}" "${PATHS[CURRENT_BRANCH]}" "${PATHS[HAS_GIT]}" \
        "${PATHS[SITE_RESEARCH]}" "${PATHS[EXISTING_PLANTS]}" "${PATHS[PLANTING_SCHEMA]}" "${PATHS[SEASONAL_CALENDAR]}" "${PATHS[MONTHLY_CARE]}" \
        "${PATHS[TOOLS]}" "${PATHS[QUICKSTART]}"
else
    echo "FEATURE_SPEC: ${PATHS[FEATURE_SPEC]}"
    echo "IMPL_PLAN: ${PATHS[IMPL_PLAN]}"
    echo "SPECS_DIR: ${PATHS[FEATURE_DIR]}"
    echo "BRANCH: ${PATHS[CURRENT_BRANCH]}"
    echo "HAS_GIT: ${PATHS[HAS_GIT]}"
    echo "SITE_RESEARCH: ${PATHS[SITE_RESEARCH]}"
    echo "EXISTING_PLANTS: ${PATHS[EXISTING_PLANTS]}"
    echo "PLANTING_SCHEMA: ${PATHS[PLANTING_SCHEMA]}"
    echo "SEASONAL_CALENDAR: ${PATHS[SEASONAL_CALENDAR]}"
    echo "MONTHLY_CARE: ${PATHS[MONTHLY_CARE]}"
    echo "TOOLS: ${PATHS[TOOLS]}"
    echo "QUICKSTART: ${PATHS[QUICKSTART]}"
fi
