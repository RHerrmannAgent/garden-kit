#!/usr/bin/env bash
# Shared Bash helpers for Garden Kit workflows.

# Get repository root, with fallback for non-git repositories
get_repo_root() {
    if git rev-parse --show-toplevel >/dev/null 2>&1; then
        git rev-parse --show-toplevel
    else
        local script_dir
        script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        (cd "$script_dir/../../.." && pwd)
    fi
}

# Determine current branch or active garden directory
get_current_branch() {
    if [[ -n "${gardify_FEATURE:-}" ]]; then
        echo "$gardify_FEATURE"
        return
    fi

    if git rev-parse --abbrev-ref HEAD >/dev/null 2>&1; then
        git rev-parse --abbrev-ref HEAD
        return
    fi

    local repo_root specs_dir
    repo_root=$(get_repo_root)
    specs_dir="$repo_root/specs"

    if [[ -d "$specs_dir" ]]; then
        local latest=""
        local highest=0

        for dir in "$specs_dir"/*; do
            [[ -d "$dir" ]] || continue
            local name
            name=$(basename "$dir")
            if [[ "$name" =~ ^([0-9]{3})- ]]; then
                local num=${BASH_REMATCH[1]}
                num=$((10#$num))
                if [[ $num -gt $highest ]]; then
                    highest=$num
                    latest=$name
                fi
            fi
        done

        if [[ -n "$latest" ]]; then
            echo "$latest"
            return
        fi
    fi

    echo "main"
}

has_git() {
    git rev-parse --show-toplevel >/dev/null 2>&1
}

check_feature_branch() {
    local branch="$1"
    local has_git_repo="$2"

    if [[ "$has_git_repo" != "true" ]]; then
        echo "[gardify] Warning: Git repository not detected; skipped branch validation" >&2
        return 0
    fi

    if [[ ! "$branch" =~ ^[0-9]{3}- ]]; then
        echo "ERROR: Not on a garden branch. Current branch: $branch" >&2
        echo "Garden branches should follow: 001-garden-name" >&2
        return 1
    fi

    return 0
}

get_feature_dir() {
    echo "$1/specs/$2"
}

find_feature_dir_by_prefix() {
    local repo_root="$1"
    local branch_name="$2"
    local specs_dir="$repo_root/specs"

    if [[ ! "$branch_name" =~ ^([0-9]{3})- ]]; then
        echo "$specs_dir/$branch_name"
        return
    fi

    local prefix="${BASH_REMATCH[1]}"
    local matches=()

    if [[ -d "$specs_dir" ]]; then
        for dir in "$specs_dir"/"$prefix"-*; do
            [[ -d "$dir" ]] || continue
            matches+=("$(basename "$dir")")
        done
    fi

    if [[ ${#matches[@]} -eq 0 ]]; then
        echo "$specs_dir/$branch_name"
    elif [[ ${#matches[@]} -eq 1 ]]; then
        echo "$specs_dir/${matches[0]}"
    else
        echo "ERROR: Multiple garden directories found with prefix '$prefix': ${matches[*]}" >&2
        echo "Please keep only one garden directory per prefix." >&2
        echo "$specs_dir/$branch_name"
    fi
}

get_feature_paths() {
    local repo_root current_branch has_git_repo feature_dir

    repo_root=$(get_repo_root)
    current_branch=$(get_current_branch)

    if has_git; then
        has_git_repo="true"
    else
        has_git_repo="false"
    fi

    feature_dir=$(find_feature_dir_by_prefix "$repo_root" "$current_branch")

    cat <<EOF
REPO_ROOT='$repo_root'
CURRENT_BRANCH='$current_branch'
HAS_GIT='$has_git_repo'
FEATURE_DIR='$feature_dir'
FEATURE_SPEC='$feature_dir/spec.md'
IMPL_PLAN='$feature_dir/plan.md'
TASKS='$feature_dir/tasks.md'
SITE_RESEARCH='$feature_dir/site-research.md'
EXISTING_PLANTS='$feature_dir/existing-plant-inventory.md'
PLANTING_SCHEMA='$feature_dir/planting-schema.md'
SEASONAL_CALENDAR='$feature_dir/seasonal-calendar.md'
MONTHLY_CARE='$feature_dir/monthly-care-plan.md'
TOOLS='$feature_dir/tools.md'
QUICKSTART='$feature_dir/quickstart.md'
EOF
}

check_file() {
    local path="$1"
    local description="$2"
    if [[ -f "$path" ]]; then
        echo "  - $description"
    else
        echo "  - (missing) $description"
    fi
}

check_dir() {
    local path="$1"
    local description="$2"
    if [[ -d "$path" && -n "$(ls -A "$path" 2>/dev/null)" ]]; then
        echo "  - $description"
    else
        echo "  - (missing) $description"
    fi
}
