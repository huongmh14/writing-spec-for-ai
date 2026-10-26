#!/usr/bin/env bash
# Writing Spec for AI - Cross-Agent Installer (macOS / Linux / WSL)
# Usage (One-liner):
#   curl -fsSL https://raw.githubusercontent.com/huongmh14/writing-spec-for-ai/main/install.sh | bash
# Usage (Local clone):
#   ./install.sh

set -euo pipefail

REPO_URL="https://github.com/huongmh14/writing-spec-for-ai.git"
SKILL_NAME="writing-spec-for-ai"
VERSION="1.3.0"
TEMP_DIR=""

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
    "$HOME/.codex/skills"
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
    echo "  [+] Installed orchestrator -> $DEST"
done

echo "[3/4] Installing 9 standalone sub-skills at top level for direct discovery..."

for ROOT in "${TARGET_ROOTS[@]}"; do
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
            "$SOURCE_DIR/skills/$SUB/SKILL.md" > "$SUB_DEST/SKILL.md"
    done
    echo "  [+] Installed 9 sub-skills -> $ROOT"
done

echo "[4/4] Installing specialized subagents (spec-surveyor, spec-challenger, doc-tester)..."

AGENT_DIRS=(
    "$HOME/.claude/agents"
    "$HOME/.agents/agents"
    "$HOME/.cursor/agents"
)

if [ -d "$SOURCE_DIR/agents" ]; then
    for ADIR in "${AGENT_DIRS[@]}"; do
        mkdir -p "$ADIR"
        cp -f "$SOURCE_DIR/agents/"*.md "$ADIR/"
        echo "  [+] Installed subagents -> $ADIR"
    done
fi

for HDIR in "$HOME/.agents/hooks" "$HOME/.claude/hooks"; do
    mkdir -p "$HDIR"
    cp -f "$SOURCE_DIR/scripts/context-guard.ps1" "$SOURCE_DIR/scripts/context-guard.sh" "$HDIR/"
    chmod +x "$HDIR/context-guard.sh" 2>/dev/null || true
    echo "  [+] Installed Context & Token Guard Hook (C32) -> $HDIR"
done

echo ""
echo "Done! Installed 10 skills + 3 subagents. Try asking your agent:"
echo '  "Use skill writing-spec-for-ai to survey this repo and propose a doc design."'
