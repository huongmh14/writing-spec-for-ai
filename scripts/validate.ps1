<#
.SYNOPSIS
    Deterministic quality gate & SDO validator for the writing-spec-for-ai skill/plugin suite.
.DESCRIPTION
    Enforces:
    1. Valid YAML frontmatter (name, description) on SKILL.md, skills/*/SKILL.md, and agents/*.md
    2. SDO Trigger-First compliance: descriptions must start with trigger conditions and stay <= 450 chars
    3. Line-count ratchets (Progressive Disclosure budget)
    4. Zero broken relative Markdown links
    5. Zero stray non-Latin/non-Vietnamese script characters
    6. Valid JSON syntax on all plugin manifests and evals/evals.json
#>
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$failures = @()

Write-Host "=== Validating writing-spec-for-ai at $root ===" -ForegroundColor Cyan

# 1. Validate JSON manifests & evals
$jsonFiles = @(
    ".claude-plugin/plugin.json",
    ".cursor-plugin/plugin.json",
    ".copilot-plugin/plugin.json",
    ".zcode-plugin/plugin.json",
    "evals/evals.json"
)
foreach ($rel in $jsonFiles) {
    $full = Join-Path $root $rel
    if (-not (Test-Path $full)) {
        $failures += "[JSON] Missing required file: $rel"
        continue
    }
    try {
        $null = Get-Content $full -Raw -Encoding UTF8 | ConvertFrom-Json
    } catch {
        $failures += "[JSON] Invalid JSON in ${rel}: $($_.Exception.Message)"
    }
}

# 2. Validate SKILL.md and agents/*.md frontmatter, SDO rules & line budgets
$skillFiles = @("SKILL.md") + (Get-ChildItem -Path (Join-Path $root "skills") -Recurse -File -Filter "SKILL.md" | ForEach-Object { $_.FullName.Substring($root.Length + 1).Replace('\','/') })
$agentFiles = Get-ChildItem -Path (Join-Path $root "agents") -File -Filter "*.md" | ForEach-Object { $_.FullName.Substring($root.Length + 1).Replace('\','/') }

$totalSkillDescChars = 0

foreach ($rel in ($skillFiles + $agentFiles)) {
    $full = Join-Path $root $rel
    $raw = Get-Content $full -Raw -Encoding UTF8
    $lines = ($raw -split "`r?`n").Count

    # Line-count ratchets
    if ($rel -eq "SKILL.md" -and $lines -gt 65) {
        $failures += "[RATCHET] $rel has $lines lines (max 65)"
    } elseif ($rel -like "skills/*" -and $lines -gt 110) {
        $failures += "[RATCHET] $rel has $lines lines (max 110)"
    } elseif ($rel -like "agents/*" -and $lines -gt 55) {
        $failures += "[RATCHET] $rel has $lines lines (max 55)"
    }

    # Frontmatter check
    if ($raw -notmatch '(?s)^---\r?\n(.*?)\r?\n---') {
        $failures += "[FRONTMATTER] Missing YAML frontmatter in $rel"
        continue
    }
    $fm = $matches[1]
    if ($fm -notmatch '(?m)^name:\s*([a-z0-9-]+)\s*$') {
        $failures += "[FRONTMATTER] Invalid or missing kebab-case 'name' in $rel"
    }
    if ($fm -notmatch '(?m)^description:\s*(.+)$') {
        $failures += "[FRONTMATTER] Missing 'description' in $rel"
        continue
    }
    $desc = $matches[1].Trim()
    $descLen = $desc.Length
    if ($rel -in $skillFiles) {
        $totalSkillDescChars += $descLen
    }

    if ($descLen -gt 450) {
        $failures += "[SDO] Description in $rel is $descLen chars (max 450 chars)"
    }
    if ($desc -notmatch '^(K\u00EDch ho\u1EA1t khi|D\u00F9ng khi|D\u00F9ng \u1EDF|Use when|Use at)\b') {
        $failures += "[SDO] Description in $rel must front-load trigger condition ('Kich hoat khi...', 'Dung o...', 'Use when...'): $desc"
    }
}

# 3. Validate Pack line-count ratchets
Get-ChildItem -Path (Join-Path $root "packs") -File -Filter "PK-*.md" | ForEach-Object {
    $rel = $_.FullName.Substring($root.Length + 1).Replace('\','/')
    $lines = ((Get-Content $_.FullName -Raw -Encoding UTF8) -split "`r?`n").Count
    if ($lines -gt 95) {
        $failures += "[RATCHET] $rel has $lines lines (max 95)"
    }
}

# 4. Validate Markdown relative links and character hygiene across all .md files
$allMd = Get-ChildItem -Path $root -Recurse -File -Filter "*.md" | Where-Object { $_.FullName -notmatch "\\(\.git|dist)\\" }
foreach ($f in $allMd) {
    $rel = $f.FullName.Substring($root.Length + 1).Replace('\','/')
    $raw = Get-Content $f.FullName -Raw -Encoding UTF8

    # Check stray non-Latin/non-Vietnamese script characters (Cyrillic, Bengali, CJK, Replacement char)
    $badChars = [regex]::Matches($raw, '[\u0900-\u0DFF\u0400-\u04FF\u4E00-\u9FFF\u3040-\u30FF\uAC00-\uD7AF\uFFFD]')
    if ($badChars.Count -gt 0) {
        $failures += "[ENCODING] Stray non-Latin/non-Vietnamese characters in ${rel}: $($badChars.Value -join ', ')"
    }

    # Check relative links
    $linkMatches = [regex]::Matches($raw, '\[[^\]]+\]\(([^)]+)\)')
    foreach ($m in $linkMatches) {
        $url = $m.Groups[1].Value
        if ($url -notmatch '^(https?:|mailto:|#|file:)') {
            $cleanUrl = ($url -split '#')[0]
            if ($cleanUrl -and -not ($rel -eq "templates/docs/specs/README.md" -and $cleanUrl -eq "00-architecture.md")) {
                $target = Join-Path $f.DirectoryName $cleanUrl
                if (-not (Test-Path $target)) {
                    $failures += "[LINK] Broken relative link '$url' in $rel"
                }
            }
        }
    }
}

Write-Host ("Checked {0} Markdown files, {1} Skills, {2} Subagents." -f $allMd.Count, $skillFiles.Count, $agentFiles.Count) -ForegroundColor Gray
Write-Host ("Total always-loaded description budget (10 skills): {0} chars (~{1} tokens)" -f $totalSkillDescChars, [math]::Round($totalSkillDescChars / 3.8)) -ForegroundColor Gray

if ($failures.Count -gt 0) {
    Write-Host "`nVALIDATION FAILED ($($failures.Count) issues):" -ForegroundColor Red
    $failures | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    exit 1
}

Write-Host "ALL CHECKS PASSED (0 errors)." -ForegroundColor Green
exit 0
