#!/usr/bin/env bash
# Writing Spec for AI - Cross-Agent Installer (macOS / Linux / WSL)
# Usage (One-liner):
#   curl -fsSL https://raw.githubusercontent.com/huongmh14/writing-spec-for-ai/main/install.sh | bash
# Usage (Local clone):
#   ./install.sh
# Default (lean): sub-skills ship nested in writing-spec-for-ai/skills/<name>/sub-skill.md so even
# recursive skill scanners (Codex, OpenCode) only preload the single orchestrator SKILL.md.
# --standalone: also install the 10 sub-skills at top level for direct /write-spec etc.
# (~0.8k extra metadata tokens in EVERY session, measured with tiktoken o200k_base).
#   curl -fsSL .../install.sh | bash -s -- --standalone

set -euo pipefail

REPO_URL="https://github.com/huongmh14/writing-spec-for-ai.git"
SKILL_NAME="writing-spec-for-ai"
VERSION="1.3.0"
TEMP_DIR=""
STANDALONE=0
[ "${1:-}" = "--standalone" ] && STANDALONE=1

echo "===================================================="
echo "  Installing Writing Spec for AI v${VERSION}             "
echo "===================================================="

SCRIPT_DIR=""
if [ -n "${BASH_SOURCE[0]:-}" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || true)"
fi

if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/SKILL.md" ] && [ -f "$SCRIPT_DIR/references/base-kit.md" ] && [ -f "$SCRIPT_DIR/skills/survey-project/SKILL.md" ]; then
    SOURCE_DIR="$SCRIPT_DIR"
    echo "[1/4] Using local repository at $SOURCE_DIR ..."
else
    TEMP_DIR="$(mktemp -d)"
    trap 'rm -rf "$TEMP_DIR"' EXIT
    echo "[1/4] Downloading latest release from $REPO_URL ..."
    git clone --depth 1 "$REPO_URL" "$TEMP_DIR" >/dev/null 2>&1
    SOURCE_DIR="$TEMP_DIR"
fi

TARGET_ROOTS=(
    "$HOME/.agents/skills"
    "$HOME/.gemini/config/skills"
    "$HOME/.claude/skills"
    # Codex natively discovers ~/.agents/skills; avoid duplicating skills into ~/.codex/skills
    "$HOME/.config/opencode/skills"
    "$HOME/.cursor/skills"
    "$HOME/.zcode/skills"
)

SUBSKILLS=(
    "survey-project"
    "propose-doc-design"
    "write-spec"
    "write-design-doc"
    "change-spec"
    "review-docs"
    "test-docs"
    "plan-tasks"
    "generate-verify-harness"
    "explore-options"
)

echo "[2/4] Installing main orchestrator skill ($SKILL_NAME)..."

for ROOT in "${TARGET_ROOTS[@]}"; do
    DEST="$ROOT/$SKILL_NAME"
    rm -rf "$DEST"
    mkdir -p "$DEST"
    tar -C "$SOURCE_DIR" \
        --exclude='.git' \
        --exclude='.github' \
        --exclude='dist' \
        -cf - . | tar -C "$DEST" -xf -
    if [ -f "$DEST/templates/project-skill/SKILL.md" ]; then
        mv "$DEST/templates/project-skill/SKILL.md" "$DEST/templates/project-skill/SKILL.template.md"
    fi
    sed -i.bak 's|templates/project-skill/SKILL\.md|templates/project-skill/SKILL.template.md|g' "$DEST/SKILL.md" && rm -f "$DEST/SKILL.md.bak"
    if [ "$STANDALONE" -eq 0 ]; then
        for SUB in "${SUBSKILLS[@]}"; do
            if [ -f "$DEST/skills/$SUB/SKILL.md" ]; then
                sed 's|\.\./\([a-z0-9-]*\)/SKILL\.md|../\1/sub-skill.md|g' "$DEST/skills/$SUB/SKILL.md" > "$DEST/skills/$SUB/sub-skill.md"
                rm -f "$DEST/skills/$SUB/SKILL.md"
            fi
        done
        sed -i.bak 's|skills/\([a-z0-9-]*\)/SKILL\.md|skills/\1/sub-skill.md|g' "$DEST/SKILL.md" && rm -f "$DEST/SKILL.md.bak"
    fi
    echo "  [+] Installed orchestrator -> $DEST"
done

if [ "$STANDALONE" -eq 0 ]; then
    echo "[3/4] Lean mode: sub-skills stay nested; removing top-level copies left by older installs..."
    for ROOT in "${TARGET_ROOTS[@]}"; do
        for SUB in "${SUBSKILLS[@]}"; do
            # Only delete folders this installer created (they carry references/base-kit.md), never a user's unrelated skill.
            if [ -f "$ROOT/$SUB/references/base-kit.md" ]; then rm -rf "${ROOT:?}/$SUB"; echo "  [-] Removed old top-level $SUB ($ROOT)"; fi
        done
    done
    TARGET_ROOTS_STANDALONE=()
else
    echo "[3/4] Installing ${#SUBSKILLS[@]} standalone sub-skills at top level for direct discovery..."
    TARGET_ROOTS_STANDALONE=("${TARGET_ROOTS[@]}")
fi

for ROOT in "${TARGET_ROOTS_STANDALONE[@]+"${TARGET_ROOTS_STANDALONE[@]}"}"; do
    for SUB in "${SUBSKILLS[@]}"; do
        SUB_DEST="$ROOT/$SUB"
        rm -rf "$SUB_DEST"
        mkdir -p "$SUB_DEST"
        cp -r "$SOURCE_DIR/references" "$SOURCE_DIR/packs" "$SOURCE_DIR/agents" "$SOURCE_DIR/templates" "$SOURCE_DIR/scripts" "$SOURCE_DIR/profiles.md" "$SOURCE_DIR/LICENSE" "$SUB_DEST/"
        sed \
            -e 's|\.\./\.\./references/|./references/|g' \
            -e 's|\.\./\.\./templates/|./templates/|g' \
            -e 's|\.\./\.\./packs/|./packs/|g' \
            -e 's|\.\./\.\./agents/|./agents/|g' \
            -e 's|\.\./\.\./profiles\.md|./profiles.md|g' \
            -e "s|\.\./\.\./SKILL\.md|../$SKILL_NAME/SKILL.md|g" \
            "$SOURCE_DIR/skills/$SUB/SKILL.md" > "$SUB_DEST/SKILL.md"
    done
    echo "  [+] Installed ${#SUBSKILLS[@]} sub-skills -> $ROOT"
done

echo "[4/4] Installing specialized subagents (spec-surveyor, spec-challenger, doc-tester)..."

AGENT_DIRS=(
    "$HOME/.claude/agents"
    "$HOME/.agents/agents"
    "$HOME/.cursor/agents"
    "$HOME/.gemini/config/agents"
    "$HOME/.config/opencode/agents"
)

if [ -d "$SOURCE_DIR/agents" ]; then
    for ADIR in "${AGENT_DIRS[@]}"; do
        mkdir -p "$ADIR"
        cp -f "$SOURCE_DIR/agents/"*.md "$ADIR/"
        echo "  [+] Installed subagents -> $ADIR"
    done
    mkdir -p "$HOME/.codex/agents"
    for AMD in "$SOURCE_DIR/agents/"*.md; do
        ANAME="$(sed -n 's/^name:[[:space:]]*//p' "$AMD" | head -n 1)"
        ADESC="$(sed -n 's/^description:[[:space:]]*//p' "$AMD" | head -n 1 | sed 's/"/\\"/g')"
        ABODY="$(awk 'BEGIN{c=0} /^---$/{c++;next} c>=2{print}' "$AMD")"
        printf "name = \"%s\"\ndescription = \"%s\"\ndeveloper_instructions = '''\n%s\n'''\n" "$ANAME" "$ADESC" "$ABODY" > "$HOME/.codex/agents/$ANAME.toml"
    done
    echo "  [+] Installed Codex .toml subagents -> $HOME/.codex/agents"
fi


echo ""
if [ "$STANDALONE" -eq 1 ]; then MODE="standalone: $((${#SUBSKILLS[@]} + 1)) discoverable skills"; else MODE="lean: 1 discoverable skill, ${#SUBSKILLS[@]} nested sub-skills"; fi
echo "Done! Installed ($MODE) + 3 subagents. Try asking your agent:"
echo '  "Use skill writing-spec-for-ai to survey this repo and propose a doc design."'
