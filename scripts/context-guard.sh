#!/usr/bin/env bash
# Deterministic Context & Token Budget Guard Hook (Core Rule C32 - writing-spec-for-ai)
set -u

TRANSCRIPT_PATH="${1:-}"
CWD_PATH="${2:-$(pwd)}"
WARN_BYTES="${WSFA_WARN_BYTES:-122880}"
CRIT_BYTES="${WSFA_CRIT_BYTES:-245760}"
WARN_TURNS="${WSFA_WARN_TURNS:-20}"
CRIT_TURNS="${WSFA_CRIT_TURNS:-35}"
MIN_TURN_BYTES="${WSFA_MIN_TURN_BYTES:-32768}"

if [ ! -t 0 ] && [ -z "$TRANSCRIPT_PATH" ]; then
    RAW_IN="$(cat 2>/dev/null || true)"
    if [ -n "$RAW_IN" ]; then
        PARSED_TP="$(printf '%s' "$RAW_IN" | grep -oE '"transcript_path"[[:space:]]*:[[:space:]]*"[^"]+"' | head -n1 | sed -E 's/.*"([^"]+)"$/\1/' || true)"
        if [ -n "$PARSED_TP" ]; then TRANSCRIPT_PATH="$PARSED_TP"; fi
        PARSED_CWD="$(printf '%s' "$RAW_IN" | grep -oE '"cwd"[[:space:]]*:[[:space:]]*"[^"]+"' | head -n1 | sed -E 's/.*"([^"]+)"$/\1/' || true)"
        if [ -n "$PARSED_CWD" ]; then CWD_PATH="$PARSED_CWD"; fi
    fi
fi

BYTES=0
TURNS=0
if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
    BYTES="$(grep -E '"type"[[:space:]]*:[[:space:]]*"(user|assistant|USER_INPUT|PLANNER_RESPONSE|GENERIC|response_item)"|"step"[[:space:]]*:' "$TRANSCRIPT_PATH" 2>/dev/null | grep -vE '"role"[[:space:]]*:[[:space:]]*"developer"' | wc -c 2>/dev/null | tr -d ' ' || echo 0)"
    USER_TURNS="$(grep -E '"type"[[:space:]]*:[[:space:]]*"user"' "$TRANSCRIPT_PATH" 2>/dev/null | grep -cv '"tool_use_id"' 2>/dev/null | tr -d ' ' || echo 0)"
    OTHER_TURNS="$(grep -E '"type"[[:space:]]*:[[:space:]]*"(USER_INPUT|user_message)"|"step"[[:space:]]*:' "$TRANSCRIPT_PATH" 2>/dev/null | wc -l 2>/dev/null | tr -d ' ' || echo 0)"
    TURNS=$(( USER_TURNS + OTHER_TURNS ))
fi

BLOAT_MSG=""
if [ -f "$CWD_PATH/docs/progress.md" ]; then
    P_BYTES="$(wc -c < "$CWD_PATH/docs/progress.md" 2>/dev/null | tr -d ' ' || echo 0)"
    if [ "$P_BYTES" -gt 5120 ]; then
        BLOAT_MSG="docs/progress.md exceeds 5 KB (C17) -> archive old history to docs/progress-archive/ or run /caveman-compress."
    fi
fi
if [ -f "$CWD_PATH/AGENTS.md" ]; then
    A_LINES="$(wc -l < "$CWD_PATH/AGENTS.md" 2>/dev/null | tr -d ' ' || echo 0)"
    if [ "$A_LINES" -gt 150 ]; then
        BLOAT_MSG="${BLOAT_MSG:+$BLOAT_MSG }AGENTS.md exceeds 150 lines (C24) -> move domain details to scoped rules or run /caveman-compress."
    fi
fi

LEVEL="NORMAL"
if [ "$BYTES" -ge "$CRIT_BYTES" ] || { [ "$TURNS" -ge "$CRIT_TURNS" ] && [ "$BYTES" -ge "$MIN_TURN_BYTES" ]; }; then
    LEVEL="CRITICAL"
elif [ "$BYTES" -ge "$WARN_BYTES" ] || { [ "$TURNS" -ge "$WARN_TURNS" ] && [ "$BYTES" -ge "$MIN_TURN_BYTES" ]; }; then
    LEVEL="WARNING"
elif [ -n "$BLOAT_MSG" ]; then
    LEVEL="MEMORY_BLOAT"
fi

if [ "$LEVEL" = "NORMAL" ]; then
    exit 0
fi

TOK_K=$(( BYTES / 4000 ))
KB=$(( BYTES / 1024 ))

echo "[CONTEXT-GUARD C32 | STATUS: $LEVEL | ~${TOK_K}k tokens (${KB} KB conversation, ${TURNS} turns)]"
echo "1. AUTO-CAVEMAN ACTIVATED: Switch immediately to terse Caveman mode (answer first, drop fluff, keep 100% of code/paths/AC-IDs/negations)."
echo "2. TOKEN BURN ALERT (MANDATORY BANNER): Display '[CẢNH BÁO TOKEN & NGỮ CẢNH — C32]' and advise distilling key knowledge into docs/decisions.md + docs/progress.md + HANDOFF.md before running /compact or starting a fresh session."
echo "3. KNOWLEDGE DISTILLATION CHECKLIST: Record D-xx in docs/decisions.md, update RUN in docs/progress.md (<= 5 KB), update docs/plans/HANDOFF.md."
if [ -n "$BLOAT_MSG" ]; then
    echo "4. STATE FILE BLOAT DETECTED: $BLOAT_MSG"
fi
exit 0
