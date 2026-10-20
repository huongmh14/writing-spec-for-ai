<#
.SYNOPSIS
    Deterministic quality gate & SDO validator for the writing-spec-for-ai skill/plugin suite.
.DESCRIPTION
    Enforces:
    1. Valid JSON syntax and version consistency across all plugin manifests, marketplace.json, claude-settings.json, and evals/evals.json
    2. Complete skill & agent arrays in all 4 plugin manifests (.claude, .cursor, .copilot, .zcode)
    3. Valid YAML frontmatter (name, description) on SKILL.md, skills/*/SKILL.md, and agents/*.md
    4. SDO Trigger-First compliance: descriptions must start with trigger conditions and stay <= 450 chars
    5. Line-count ratchets (Progressive Disclosure budget)
    6. Template structural markers (Capability Map, HYPOTHESIS/CONFIDENCE, Pack Inheritance, Deep Modules & Seams, Tracer Bullets)
    7. Zero broken relative Markdown links & zero stray non-Latin/non-Vietnamese script characters
#>
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$failures = @()

Write-Host "=== Validating writing-spec-for-ai at $root ===" -ForegroundColor Cyan

# 1. Validate JSON manifests, evals & version sync
$jsonFiles = @(
    ".claude-plugin/plugin.json",
    ".claude-plugin/marketplace.json",
    ".cursor-plugin/plugin.json",
    ".copilot-plugin/plugin.json",
    ".zcode-plugin/plugin.json",
    "templates/adapters/claude-settings.json",
    "evals/evals.json"
)
$versions = @{}
$pluginManifests = @(
    ".claude-plugin/plugin.json",
    ".cursor-plugin/plugin.json",
    ".copilot-plugin/plugin.json",
    ".zcode-plugin/plugin.json"
)

foreach ($rel in $jsonFiles) {
    $full = Join-Path $root $rel
    if (-not (Test-Path $full)) {
        $failures += "[JSON] Missing required file: $rel"
        continue
    }
    try {
        $parsed = Get-Content $full -Raw -Encoding UTF8 | ConvertFrom-Json
        if ($parsed.PSObject.Properties.Name -contains "version") {
            $versions[$rel] = $parsed.version
        }
        if ($rel -in $pluginManifests) {
            if (-not ($parsed.skills -is [System.Array]) -or ($parsed.skills -notcontains "./") -or ($parsed.skills.Count -ne 10)) {
                $failures += "[MANIFEST] $rel must declare all 10 skills as an array including './'"
            }
            if (-not ($parsed.agents -is [System.Array]) -or ($parsed.agents.Count -ne 3)) {
                $failures += "[MANIFEST] $rel must declare all 3 subagents in 'agents' array"
            }
        }
    } catch {
        $failures += "[JSON] Invalid JSON in ${rel}: $($_.Exception.Message)"
    }
}

$uniqueVersions = $versions.Values | Select-Object -Unique
if ($uniqueVersions.Count -gt 1) {
    $failures += "[VERSION] Version mismatch across JSON files: $(($versions.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join ', ')"
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

# 4. Validate structural alignment between Templates and Sub-skills
$templateChecks = @(
    @{ File = "templates/doc-design-proposal.md"; Pattern = "Depends on"; Label = "Capability Map 'Depends on' column" },
    @{ File = "templates/doc-design-proposal.md"; Pattern = "HYPOTHESIS"; Label = "Frontier Q&A 'HYPOTHESIS' block" },
    @{ File = "templates/docs/specs/_template.md"; Pattern = "PK-"; Label = "Domain Pack inheritance table" },
    @{ File = "templates/docs/specs/_design-template.md"; Pattern = "Interface & Seam"; Label = "Deep Modules & Seams column" },
    @{ File = "templates/docs/specs/_design-template.md"; Pattern = "Design It Twice"; Label = "Design It Twice section" },
    @{ File = "templates/docs/plans/_plan-template.md"; Pattern = "Blocked by"; Label = "Tracer-Bullet Task Graph 'Blocked by' column" }
)
foreach ($tc in $templateChecks) {
    $tPath = Join-Path $root $tc.File
    $tRaw = Get-Content $tPath -Raw -Encoding UTF8
    if ($tRaw -notmatch [regex]::Escape($tc.Pattern)) {
        $failures += "[TEMPLATE] $($tc.File) is missing required marker: $($tc.Label)"
    }
}

# 5. Validate Markdown relative links and character hygiene across all .md files
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

Write-Host ("Checked {0} Markdown files, {1} Skills, {2} Subagents, {3} JSON manifests." -f $allMd.Count, $skillFiles.Count, $agentFiles.Count, $jsonFiles.Count) -ForegroundColor Gray
Write-Host ("Total always-loaded description budget (10 skills): {0} chars (~{1} tokens)" -f $totalSkillDescChars, [math]::Round($totalSkillDescChars / 3.8)) -ForegroundColor Gray

if ($failures.Count -gt 0) {
    Write-Host "`nVALIDATION FAILED ($($failures.Count) issues):" -ForegroundColor Red
    $failures | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    exit 1
}

Write-Host "ALL CHECKS PASSED (0 errors)." -ForegroundColor Green
exit 0
