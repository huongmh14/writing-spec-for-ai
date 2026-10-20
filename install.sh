#!/usr/bin/env bash
# Writing Spec for AI - Cross-Agent Installer (macOS / Linux / WSL)
# Usage (One-liner):
#   curl -fsSL https://raw.githubusercontent.com/huongmh14/writing-spec-for-ai/main/install.sh | bash
# Usage (Local clone):
#   ./install.sh

set -euo pipefail

REPO_URL="https://github.com/huongmh14/writing-spec-for-ai.git"
SKILL_NAME="writing-spec-for-ai"
TEMP_DIR=""

echo "===================================================="
echo "  Installing Writing Spec for AI (Multi-Agent Kit)  "
echo "===================================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || pwd)"

if [ -f "$SCRIPT_DIR/SKILL.md" ]; then
    SOURCE_DIR="$SCRIPT_DIR"
    echo "[1/2] Using local repository at $SOURCE_DIR ..."
else
    TEMP_DIR="$(mktemp -d)"
    trap 'rm -rf "$TEMP_DIR"' EXIT
    echo "[1/2] Downloading latest release from $REPO_URL ..."
    git clone --depth 1 "$REPO_URL" "$TEMP_DIR" >/dev/null 2>&1
    SOURCE_DIR="$TEMP_DIR"
fi

TARGETS=(
    "$HOME/.agents/skills/$SKILL_NAME"
    "$HOME/.gemini/config/skills/$SKILL_NAME"
    "$HOME/.claude/skills/$SKILL_NAME"
    "$HOME/.codex/skills/$SKILL_NAME"
    "$HOME/.config/opencode/skills/$SKILL_NAME"
    "$HOME/.cursor/skills/$SKILL_NAME"
    "$HOME/.zcode/skills/$SKILL_NAME"
)

echo "[2/2] Installing skill suite to AI coding agents..."

for DEST in "${TARGETS[@]}"; do
    rm -rf "$DEST"
    mkdir -p "$DEST"
    tar -C "$SOURCE_DIR" \
        --exclude='.git' \
        --exclude='.github' \
        --exclude='dist' \
        -cf - . | tar -C "$DEST" -xf -
    echo "  [+] Installed -> $DEST"
done

echo ""
echo "Done! Try asking your agent:"
echo '  "Use skill writing-spec-for-ai to survey this repo and propose a doc design."'
