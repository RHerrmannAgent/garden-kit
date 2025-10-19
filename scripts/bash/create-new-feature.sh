#!/usr/bin/env bash

set -euo pipefail

JSON_MODE=false
SHORT_NAME=""
DESCRIPTION_ARGS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --json)
            JSON_MODE=true
            ;;
        --short-name)
            shift
            if [[ $# -eq 0 ]]; then
                echo "Error: --short-name requires a value" >&2
                exit 1
            fi
            SHORT_NAME="$1"
            ;;
        --help|-h)
            cat <<'EOF'
Usage: create-new-feature.sh [--json] [--short-name <name>] <garden description>

Options:
  --json              Output in JSON format
  --short-name <name> Provide a custom short name (2-4 words) for the branch
  --help, -h          Show this help message

Examples:
  create-new-feature.sh "Design a pollinator meadow for the south slope" --short-name "pollinator-meadow"
  create-new-feature.sh "Convert backyard into raised bed kitchen garden"
EOF
            exit 0
            ;;
        *)
            DESCRIPTION_ARGS+=("$1")
            ;;
    esac
    shift
done

if [[ ${#DESCRIPTION_ARGS[@]} -eq 0 ]]; then
    echo "Usage: create-new-feature.sh [--json] [--short-name <name>] <garden description>" >&2
    exit 1
fi

GARDEN_DESC="${DESCRIPTION_ARGS[*]}"
GARDEN_DESC="${GARDEN_DESC## }"
GARDEN_DESC="${GARDEN_DESC%% }"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

REPO_ROOT=$(get_repo_root)
SPECS_DIR="$REPO_ROOT/specs"
mkdir -p "$SPECS_DIR"

has_git && HAS_GIT=true || HAS_GIT=false

highest=0
if [[ -d "$SPECS_DIR" ]]; then
    while IFS= read -r -d '' dir; do
        name=$(basename "$dir")
        if [[ "$name" =~ ^([0-9]{3})- ]]; then
            num=${BASH_REMATCH[1]}
            num=$((10#$num))
            if [[ $num -gt $highest ]]; then
                highest=$num
            fi
        fi
    done < <(find "$SPECS_DIR" -maxdepth 1 -mindepth 1 -type d -print0)
fi

next=$((highest + 1))
FEATURE_NUM=$(printf "%03d" "$next")

slugify() {
    local text="$1"
    text="${text,,}"
    text="${text//[^a-z0-9\s]/ }"
    text=$(echo "$text" | xargs)
    local stopwords=("i" "a" "an" "the" "to" "for" "of" "in" "on" "at" "by" "with" "from" "is" "are" "was" "were" "be" "been" "being" "have" "has" "had" "do" "does" "did" "will" "would" "should" "could" "can" "may" "might" "must" "shall" "this" "that" "these" "those" "my" "your" "our" "their" "make" "build" "create" "add" "new" "project" "feature")
    local filtered=()
    for word in $text; do
        skip=false
        for stop in "${stopwords[@]}"; do
            if [[ "$word" == "$stop" ]]; then
                skip=true
                break
            fi
        done
        if ! $skip && [[ ${#word} -ge 3 ]]; then
            filtered+=("$word")
        fi
    done
    if [[ ${#filtered[@]} -eq 0 ]]; then
        filtered=($text)
    fi
    local limit=3
    if [[ ${#filtered[@]} -gt 4 ]]; then
        limit=4
    else
        limit=${#filtered[@]}
    fi
    local slice=(${filtered[@]:0:$limit})
    local slug
    slug=$(IFS=-; echo "${slice[*]}")
    slug=$(echo "$slug" | sed -E 's/[^a-z0-9-]+/-/g; s/-+/-/g; s/^-+|-+$//g')
    echo "$slug"
}

if [[ -n "$SHORT_NAME" ]]; then
    BRANCH_SUFFIX=$(echo "$SHORT_NAME" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')
else
    BRANCH_SUFFIX=$(slugify "$GARDEN_DESC")
fi

BRANCH_NAME="$FEATURE_NUM-$BRANCH_SUFFIX"

# Enforce GitHub branch length limit (244 chars)
if [[ ${#BRANCH_NAME} -gt 244 ]]; then
    truncated_suffix=${BRANCH_SUFFIX:0:$((244-4))}
    truncated_suffix=${truncated_suffix%-}
    echo "[gardify] Warning: Branch name exceeded 244 characters, truncating." >&2
    BRANCH_NAME="$FEATURE_NUM-$truncated_suffix"
fi

pushd "$REPO_ROOT" >/dev/null
if $HAS_GIT; then
    if git rev-parse --verify "$BRANCH_NAME" >/dev/null 2>&1; then
        git checkout "$BRANCH_NAME"
    else
        git checkout -b "$BRANCH_NAME"
    fi
else
    echo "[gardify] Warning: Git repository not detected; skipped branch creation for $BRANCH_NAME" >&2
fi
popd >/dev/null

FEATURE_DIR="$SPECS_DIR/$BRANCH_NAME"
mkdir -p "$FEATURE_DIR"

TEMPLATE="$REPO_ROOT/.gardify/templates/spec-template.md"
SPEC_FILE="$FEATURE_DIR/spec.md"
if [[ -f "$TEMPLATE" ]]; then
    cp "$TEMPLATE" "$SPEC_FILE"
else
    touch "$SPEC_FILE"
fi

export gardify_FEATURE="$BRANCH_NAME"

if $JSON_MODE; then
    printf '{"BRANCH_NAME":"%s","SPEC_FILE":"%s","FEATURE_NUM":"%s","HAS_GIT":%s}' \
        "$BRANCH_NAME" "$SPEC_FILE" "$FEATURE_NUM" "$HAS_GIT"
else
    echo "BRANCH_NAME: $BRANCH_NAME"
    echo "SPEC_FILE: $SPEC_FILE"
    echo "FEATURE_NUM: $FEATURE_NUM"
    echo "HAS_GIT: $HAS_GIT"
fi
