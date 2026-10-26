<#
.SYNOPSIS
    Deterministic Context & Token Budget Guard Hook (Core Rule C32 - writing-spec-for-ai).
.DESCRIPTION
    Measures active session conversation size (conversation bytes, estimated tokens, real user turns)
    and project memory file bloat (docs/progress.md > 5 KB, AGENTS.md > 150 lines).
    - Below threshold: exits 0 silently (0 token overhead).
    - Above threshold: injects Auto-Caveman activation, Token Burn Alert banner requirement,
      and Knowledge Distillation checklist into the agent context.
#>
param(
    [string]$TranscriptPath = "",
    [string]$Cwd = "",
    [int]$WarnBytes = $(if ($env:WSFA_WARN_BYTES) { [int]$env:WSFA_WARN_BYTES } else { 122880 }),
    [int]$CritBytes = $(if ($env:WSFA_CRIT_BYTES) { [int]$env:WSFA_CRIT_BYTES } else { 245760 }),
    [int]$WarnTurns = $(if ($env:WSFA_WARN_TURNS) { [int]$env:WSFA_WARN_TURNS } else { 20 }),
    [int]$CritTurns = $(if ($env:WSFA_CRIT_TURNS) { [int]$env:WSFA_CRIT_TURNS } else { 35 }),
    [int]$MinBytesForTurnTrigger = $(if ($env:WSFA_MIN_TURN_BYTES) { [int]$env:WSFA_MIN_TURN_BYTES } else { 32768 })
)

$ErrorActionPreference = 'SilentlyContinue'
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch { }

# 1. Parse optional Hook JSON from stdin if available (Claude Code / Cursor close stdin after payload)
if (-not $TranscriptPath -or -not $Cwd) {
    try {
        if ([Console]::IsInputRedirected) {
            $rawIn = [Console]::In.ReadToEnd()
            if (-not [string]::IsNullOrWhiteSpace($rawIn)) {
                $payload = $rawIn | ConvertFrom-Json
                if (-not $TranscriptPath) {
                    if ($payload.transcript_path) { $TranscriptPath = [string]$payload.transcript_path }
                    elseif ($payload.transcriptPath) { $TranscriptPath = [string]$payload.transcriptPath }
                }
                if (-not $Cwd) {
                    if ($payload.cwd) { $Cwd = [string]$payload.cwd }
                    elseif ($payload.workspace_roots -and $payload.workspace_roots.Count -gt 0) { $Cwd = [string]$payload.workspace_roots[0] }
                }
            }
        }
    } catch { }
}

if (-not $Cwd) {
    if ($env:CLAUDE_PROJECT_DIR) { $Cwd = $env:CLAUDE_PROJECT_DIR }
    else { $Cwd = (Get-Location).Path }
}

# 2. Scoped fallback discovery ONLY for the current project Cwd (never cross-agent / cross-project)
if (-not $TranscriptPath -or -not (Test-Path -LiteralPath $TranscriptPath)) {
    $slug = ($Cwd -replace '[:\\/]', '-')
    $projDir = Join-Path $HOME ".claude\projects\$slug"
    if (Test-Path -LiteralPath $projDir) {
        $cutoff = (Get-Date).AddMinutes(-30)
        $latest = Get-ChildItem -LiteralPath $projDir -Filter "*.jsonl" -File -ErrorAction SilentlyContinue |
            Where-Object { $_.LastWriteTime -ge $cutoff } |
            Sort-Object LastWriteTime -Descending |
            Select-Object -First 1
        if ($latest) { $TranscriptPath = $latest.FullName }
    }
}

# 3. Measure actual conversation bytes and real user turns (check user/assistant first with case-sensitive -cmatch)
$bytes = [int64]0
$turns = 0
$estTokens = 0
if ($TranscriptPath -and (Test-Path -LiteralPath $TranscriptPath)) {
    $utf8 = [System.Text.Encoding]::UTF8
    foreach ($line in [System.IO.File]::ReadLines($TranscriptPath, $utf8)) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }

        if ($line -cmatch '"type"\s*:\s*"user"') {
            $bytes += $utf8.GetByteCount($line)
            if ($line -notmatch '"tool_use_id"') { $turns++ }
        } elseif ($line -cmatch '"type"\s*:\s*"assistant"') {
            $bytes += $utf8.GetByteCount($line)
        } elseif ($line -cmatch '"type"\s*:\s*"USER_INPUT"') {
            $bytes += $utf8.GetByteCount($line)
            $turns++
        } elseif ($line -cmatch '"type"\s*:\s*"(PLANNER_RESPONSE|GENERIC)"') {
            $bytes += $utf8.GetByteCount($line)
        } elseif ($line -cmatch '"type"\s*:\s*"user_message"') {
            $turns++
        } elseif ($line -cmatch '"type"\s*:\s*"response_item"' -and $line -notmatch '"role"\s*:\s*"developer"') {
            $bytes += $utf8.GetByteCount($line)
        } elseif ($line -cmatch '"step"\s*:') {
            $bytes += $utf8.GetByteCount($line)
            $turns++
        }
    }
    $estTokens = [math]::Round($bytes / 4)
}

# 4. Measure project memory file bloat (C17 / C24 / C32)
$bloatWarnings = @()
$progressFile = Join-Path $Cwd "docs\progress.md"
if (Test-Path -LiteralPath $progressFile) {
    $pBytes = (Get-Item -LiteralPath $progressFile).Length
    if ($pBytes -gt 5120) {
        $pKb = [math]::Round($pBytes / 1024, 1)
        $bloatWarnings += "docs/progress.md = ${pKb} KB (> 5 KB limit C17) -> archive old entries to docs/progress-archive/ or run /caveman-compress."
    }
}
$agentsFile = Join-Path $Cwd "AGENTS.md"
if (Test-Path -LiteralPath $agentsFile) {
    $aLines = @(Get-Content -LiteralPath $agentsFile -ErrorAction SilentlyContinue).Count
    if ($aLines -gt 150) {
        $bloatWarnings += "AGENTS.md = ${aLines} lines (> 150 lines limit C24) -> move domain details to scoped rules or run /caveman-compress."
    }
}

# 5. Evaluate severity level (turn count requires minimum conversation bytes to prevent tiny-turn false positives)
$level = "NORMAL"
if ($bytes -ge $CritBytes -or ($turns -ge $CritTurns -and $bytes -ge $MinBytesForTurnTrigger)) {
    $level = "CRITICAL"
} elseif ($bytes -ge $WarnBytes -or ($turns -ge $WarnTurns -and $bytes -ge $MinBytesForTurnTrigger)) {
    $level = "WARNING"
} elseif ($bloatWarnings.Count -gt 0) {
    $level = "MEMORY_BLOAT"
}

if ($level -eq "NORMAL") {
    exit 0
}

$kb = [math]::Round($bytes / 1024, 1)
$tokK = [math]::Round($estTokens / 1000, 1)

Write-Output "[CONTEXT-GUARD C32 | STATUS: $level | ~${tokK}k tokens (${kb} KB conversation, ${turns} turns)]"
Write-Output "1. AUTO-CAVEMAN ACTIVATED: Switch immediately to terse Caveman mode (answer first, drop all pleasantries/fluff, preserve 100% of code, paths, commands, AC-IDs, and negations)."
if ($level -eq "CRITICAL") {
    $msgCrit = [regex]::Unescape("   '[C\u1EA2NH B\u00C1O TOKEN & NG\u1EEE C\u1EA2NH \u2014 C32]: Ng\u1EEF c\u1EA3nh \u0111\u00E3 ch\u1EA1m m\u1EE9c QU\u00C1 T\u1EA2I (~${tokK}k tokens, ${turns} l\u01B0\u1EE3t) \u2014 AI \u0111ang t\u1ED1n r\u1EA5t nhi\u1EC1u token m\u1ED7i b\u01B0\u1EDBc v\u00E0 c\u00F3 nguy c\u01A1 tr\u00F4i lu\u1EADt (Context Rot). \u0110\u00E3 t\u1EF1 b\u1EADt Auto-Caveman t\u1ED1i \u0111a. B\u1EAET BU\u1ED8C: Ch\u1EAFt l\u1ECDc ngay tri th\u1EE9c quan tr\u1ECDng v\u00E0o docs/decisions.md + docs/progress.md + HANDOFF.md r\u1ED3i ch\u1EA1y /compact ho\u1EB7c m\u1EDF phi\u00EAn m\u1EDBi!'")
    Write-Output "2. CRITICAL TOKEN BURN ALERT (MANDATORY BANNER): Display this exact warning to the user:"
    Write-Output $msgCrit
} elseif ($level -eq "WARNING") {
    $msgWarn = [regex]::Unescape("   '[C\u1EA2NH B\u00C1O TOKEN & NG\u1EEE C\u1EA2NH \u2014 C32]: C\u1EEDa s\u1ED5 context \u0111\u00E3 d\u00E0i (~${tokK}k tokens, ${turns} l\u01B0\u1EE3t) \u2014 AI \u0111ang ti\u00EAu t\u1ED1n nhi\u1EC1u token m\u1ED7i l\u01B0\u1EE3t. \u0110\u00E3 t\u1EF1 \u0111\u1ED9ng b\u1EADt Auto-Caveman \u0111\u1EC3 n\u00E9n c\u00E2u tr\u1EA3 l\u1EDDi. Khuy\u1EBFn ngh\u1ECB: Ch\u1EAFt l\u1ECDc tri th\u1EE9c quan tr\u1ECDng v\u00E0o docs/decisions.md + docs/progress.md + HANDOFF.md r\u1ED3i d\u00F9ng /compact (ho\u1EB7c m\u1EDF phi\u00EAn m\u1EDBi).'")
    Write-Output "2. HIGH TOKEN & CONTEXT ALERT (MANDATORY BANNER): Display this warning to the user:"
    Write-Output $msgWarn
} elseif ($level -eq "MEMORY_BLOAT") {
    $msgBloat = [regex]::Unescape("   '[C\u1EA2NH B\u00C1O TOKEN & NG\u1EEE C\u1EA2NH \u2014 C32]: File b\u1ED9 nh\u1EDB d\u1EF1 \u00E1n (docs/progress.md > 5 KB ho\u1EB7c AGENTS.md > 150 d\u00F2ng) \u0111ang v\u01B0\u1EE3t ng\u01B0\u1EE1ng v\u00E0 g\u00E2y t\u1ED1n token m\u1ED7i phi\u00EAn. \u0110\u00E3 t\u1EF1 b\u1EADt Auto-Caveman. Khuy\u1EBFn ngh\u1ECB: Ch\u1EAFt l\u1ECDc tri th\u1EE9c quan tr\u1ECDng v\u00E0o docs/decisions.md + docs/progress.md (l\u01B0u tr\u1EEF ph\u1EA7n c\u0169 sang progress-archive/) + HANDOFF.md.'")
    Write-Output "2. MEMORY BLOAT & TOKEN ALERT (MANDATORY BANNER): Display this warning to the user:"
    Write-Output $msgBloat
}
Write-Output "3. KNOWLEDGE DISTILLATION CHECKLIST (Distill key knowledge before compacting/closing session):"
Write-Output "   - Confirmed decisions -> record D-xx in docs/decisions.md."
Write-Output "   - Progress & test evidence -> update current RUN in docs/progress.md (keep <= 5 KB)."
Write-Output "   - Remaining work & stop boundary -> update docs/plans/HANDOFF.md."
if ($bloatWarnings.Count -gt 0) {
    Write-Output "4. STATE FILE BLOAT DETECTED:"
    foreach ($w in $bloatWarnings) {
        Write-Output "   - $w"
    }
}
exit 0
