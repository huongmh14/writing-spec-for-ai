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
    6. Template structural markers (Capability Map, evidence/gaps, Pack Inheritance, Deep Modules & Seams, bounded execution C30, provenance C31)
    7. Zero broken relative Markdown links & zero stray non-Latin/non-Vietnamese script characters
    8. Behavioral eval scenario structure only (does not execute or score model behavior)
#>
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$failures = @()

Write-Host "=== Validating writing-spec-for-ai at $root ===" -ForegroundColor Cyan

$subSkillNames = @("survey-project","propose-doc-design","write-spec","write-design-doc","change-spec","review-docs","test-docs","plan-tasks","generate-verify-harness","explore-options")

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
        if ($rel -eq "evals/evals.json") {
            $evalIds = @($parsed.evals | ForEach-Object { $_.id })
            $requiredEvalIds = @(
                "eval-07-one-current-task-many-ready-specs",
                "eval-08-explicit-bounded-batch",
                "eval-09-unknown-p95-and-token-ttl",
                "eval-10-risky-domain-outside-user-expertise",
                "eval-11-stale-handoff-and-continue",
                "eval-12-unverified-ac-prevents-done",
                "eval-13-staged-doc-authoring-c30",
                "eval-15-explore-options-user-chooses"
            )
            foreach ($evalId in $requiredEvalIds) {
                if ($evalIds -notcontains $evalId) {
                    $failures += "[EVAL] Missing behavioral scenario: $evalId"
                }
            }
            if (@($evalIds | Select-Object -Unique).Count -ne $evalIds.Count) {
                $failures += "[EVAL] Scenario IDs must be unique"
            }
            foreach ($scenario in $parsed.evals) {
                if (-not $scenario.prompt -or -not $scenario.expected_output -or @($scenario.assertions).Count -lt 1) {
                    $failures += "[EVAL] $($scenario.id) needs a prompt, expected_output and assertions"
                }
            }
        }
        if ($parsed.PSObject.Properties.Name -contains "version") {
            $versions[$rel] = $parsed.version
        }
        if ($rel -in $pluginManifests) {
            $expectedSkillCount = $subSkillNames.Count + 1
            if (-not ($parsed.skills -is [System.Array]) -or ($parsed.skills -notcontains "./") -or ($parsed.skills.Count -ne $expectedSkillCount)) {
                $failures += "[MANIFEST] $rel must declare all $expectedSkillCount skills (./ + skills/*) as an array including './'"
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

if (Test-Path (Join-Path $root "skills")) {
    $skillFiles = @("SKILL.md") + (Get-ChildItem -Path (Join-Path $root "skills") -Recurse -File -Filter "SKILL.md" | ForEach-Object { $_.FullName.Substring($root.Length + 1).Replace('\','/') })
} else {
    $skillFiles = @("SKILL.md") + ($subSkillNames | ForEach-Object { "../$_/SKILL.md" } | Where-Object { Test-Path (Join-Path $root $_) })
}
$agentFiles = Get-ChildItem -Path (Join-Path $root "agents") -File -Filter "*.md" | ForEach-Object { $_.FullName.Substring($root.Length + 1).Replace('\','/') }

$totalSkillDescChars = 0

foreach ($rel in ($skillFiles + $agentFiles)) {
    $full = Join-Path $root $rel
    if (-not (Test-Path $full)) {
        $failures += "[FILE] Missing skill/agent file: $rel"
        continue
    }
    $raw = Get-Content $full -Raw -Encoding UTF8
    $lines = ($raw -split "`r?`n").Count

    # Line-count ratchets
    if ($rel -eq "SKILL.md" -and $lines -gt 65) {
        $failures += "[RATCHET] $rel has $lines lines (max 65)"
    } elseif (($rel -like "skills/*" -or $rel -like "../*") -and $lines -gt 110) {
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
    @{ File = "templates/doc-design-proposal.md"; Pattern = "EVIDENCE"; Label = "Evidence supporting the current hypothesis" },
    @{ File = "templates/doc-design-proposal.md"; Pattern = "GAPS"; Label = "Unverified knowledge and verification path" },
    @{ File = "templates/doc-design-proposal.md"; Pattern = "Scope Radar"; Label = "Visual Direction 'Scope Radar' section (C28)" },
    @{ File = "templates/docs/specs/_template.md"; Pattern = "PK-"; Label = "Domain Pack inheritance table" },
    @{ File = "templates/docs/specs/_template.md"; Pattern = "Concrete I/O Snapshot"; Label = "Visual I/O Snapshot section (C28)" },
    @{ File = "templates/docs/specs/_template.md"; Pattern = "Visible Test Matrix"; Label = "Visible Test Matrix section (C29)" },
    @{ File = "templates/docs/specs/_design-template.md"; Pattern = "Interface & Seam"; Label = "Deep Modules & Seams column" },
    @{ File = "templates/docs/specs/_design-template.md"; Pattern = "Design It Twice"; Label = "Design It Twice section" },
    @{ File = "templates/docs/plans/_plan-template.md"; Pattern = "Blocked by"; Label = "Tracer-Bullet Task Graph 'Blocked by' column" },
    @{ File = "templates/AGENTS.md"; Pattern = "Visible Test Execution Ledger"; Label = "DoD Visible Test Execution Ledger requirement (C29)" },
    @{ File = "templates/adapters/pull_request_template.md"; Pattern = "Visible Test Execution Ledger"; Label = "PR Visible Test Execution Ledger table (C29)" },
    @{ File = "SKILL.md"; Pattern = "C30"; Label = "Bounded execution rule (C30)" },
    @{ File = "SKILL.md"; Pattern = "C31"; Label = "Provenance and knowledge limits rule (C31)" },
    @{ File = "references/base-kit.md"; Pattern = "| C30 |"; Label = "Core bounded execution contract (C30)" },
    @{ File = "references/base-kit.md"; Pattern = "| C31 |"; Label = "Core provenance contract (C31)" },
    @{ File = "templates/AGENTS.md"; Regex = $true; Pattern = '(?i)quy\u1EC1n th\u1EF1c thi theo \u0111\u1EE3t'; Label = "Task execution boundary (C30)" },
    @{ File = "templates/AGENTS.md"; Regex = $true; Pattern = '(?i)ngu\u1ED3n & gi\u1EDBi h\u1EA1n hi\u1EC3u bi\u1EBFt'; Label = "Task knowledge boundary (C31)" },
    @{ File = "templates/docs/specs/README.md"; Regex = $true; Pattern = '(?i)quy\u1EC1n th\u1EF1c thi theo \u0111\u1EE3t'; Label = "Spec readiness versus execution authority (C30)" },
    @{ File = "templates/docs/specs/_template.md"; Regex = $true; Pattern = 'Nh\u00E3n ngu\u1ED3n g\u1ED1c'; Label = "Requirement provenance (C31)" },
    @{ File = "templates/docs/specs/_template.md"; Pattern = "../progress.md"; Label = "Pointer to current execution grant" },
    @{ File = "templates/docs/progress.md"; Regex = $true; Pattern = '(?i)quy\u1EC1n th\u1EF1c thi theo \u0111\u1EE3t'; Label = "Current execution grant (C30)" },
    @{ File = "templates/docs/plans/_plan-template.md"; Regex = $true; Pattern = '(?i)quy\u1EC1n th\u1EF1c thi theo \u0111\u1EE3t'; Label = "Plan is not execution authority (C30)" },
    @{ File = "agents/doc-tester.md"; Pattern = "C30"; Label = "Clean-room execution boundary check (C30)" },
    @{ File = "agents/spec-challenger.md"; Pattern = "C31"; Label = "Adversarial provenance check (C31)" },
    @{ File = "skills/write-design-doc/SKILL.md"; Pattern = "C30"; Label = "Staged design doc authoring checkpoint (C30)" }
)
foreach ($tc in $templateChecks) {
    $tPath = Join-Path $root $tc.File
    if (-not (Test-Path $tPath) -and $tc.File -like "skills/*") {
        $tPath = Join-Path $root ($tc.File -replace '^skills/', '../')
    }
    if (-not (Test-Path $tPath)) {
        $failures += "[TEMPLATE] Missing required file for '$($tc.Label)': $($tc.File)"
        continue
    }
    $tRaw = Get-Content $tPath -Raw -Encoding UTF8
    if ($tRaw -notmatch $(if ($tc.Regex) { $tc.Pattern } else { [regex]::Escape($tc.Pattern) })) {
        $failures += "[TEMPLATE] $($tc.File) is missing required marker: $($tc.Label)"
    }
}

# Prevent the previous completion rule from silently returning in a shared contract.
$completionFiles = @("SKILL.md", "references/principles.md", "templates/AGENTS.md", "templates/docs/specs/README.md")
foreach ($rel in $completionFiles) {
    $raw = Get-Content (Join-Path $root $rel) -Raw -Encoding UTF8
    if ($raw -match '\[x\][^\r\n]{0,20}ho\u1EB7c[^\r\n]{0,20}\[~\]') {
        $failures += "[COMPLETION] $rel still accepts unresolved [~] alongside [x]; unresolved ACs must prevent Done"
    }
}

# Readability & provenance: copied-out templates must not carry kit-internal rule codes; no machine paths; C32 stays retired.
$tplDir = Join-Path $root "templates"
if (Test-Path $tplDir) {
    Get-ChildItem $tplDir -Recurse -File | Select-String -Pattern '\bC\d{2}\b' | ForEach-Object {
        $failures += "[READABILITY] Kit rule code '$($_.Matches[0].Value)' in copied-out template $($_.Path.Substring($root.Length + 1)):$($_.LineNumber); write its meaning instead"
    }
    $agentsTpl = Join-Path $tplDir "AGENTS.md"
    if ((Get-Content $agentsTpl -Encoding UTF8).Count -gt 150) { $failures += "[BUDGET] templates/AGENTS.md exceeds 150 lines" }
    # Regex escapes keep this file ASCII-only for Windows PowerShell 5.1 (no BOM). Labels: Nguoi dung chot, Da xac minh, AI de xuat, Chua biet, Tu kiem.
    foreach ($label in @('Ng\u01B0\u1EDDi d\u00F9ng ch\u1ED1t', '\u0110\u00E3 x\u00E1c minh', 'AI \u0111\u1EC1 xu\u1EA5t', 'Ch\u01B0a bi\u1EBFt', 'T\u1EF1 ki\u1EC3m')) {
        if ((Get-Content (Join-Path $tplDir "docs/specs/_template.md") -Raw -Encoding UTF8) -notmatch $label) {
            $failures += "[PROVENANCE] templates/docs/specs/_template.md missing provenance label /$label/"
        }
    }
}
$glossaryPath = Join-Path $root "references/glossary.md"
if ((Test-Path (Join-Path $root "references")) -and -not (Test-Path $glossaryPath)) { $failures += "[READABILITY] references/glossary.md missing" }
if (Test-Path (Join-Path $root "templates/docs/plans/HANDOFF.md")) { $failures += "[RETIRED] templates/docs/plans/HANDOFF.md must stay merged into templates/docs/progress.md (C17)" }
if ((Test-Path (Join-Path $root "references")) -and -not (Test-Path (Join-Path $root "references/lenses.md"))) { $failures += "[LENS] references/lenses.md missing" }
$exploreSkill = Join-Path $root "skills/explore-options/SKILL.md"; if (-not (Test-Path $exploreSkill)) { $exploreSkill = Join-Path (Split-Path $root -Parent) "explore-options/SKILL.md" }
if (Test-Path $exploreSkill) {
    $exploreRaw = Get-Content $exploreSkill -Raw -Encoding UTF8
    foreach ($pat in @('(?i)ng\u01B0\u1EDDi d\u00F9ng ch\u1ECDn', '(?i)gi\u1EEF nguy\u00EAn', '(?i)1 v\u00F2ng')) {
        if ($exploreRaw -notmatch $pat) { $failures += "[LENS] skills/explore-options/SKILL.md missing /$pat/" }
    }
}
Get-ChildItem $root -Recurse -File -Include *.md, *.json, *.ps1, *.sh | Where-Object { $_.FullName -notmatch "\\(\.git|dist)\\" } | ForEach-Object {
    $rel = $_.FullName.Substring($root.Length + 1).Replace('\', '/')
    $raw = Get-Content $_.FullName -Raw -Encoding UTF8
    if ($raw -match '\b[A-Z]:\\[A-Za-z]') { $failures += "[PRIVACY] Machine-specific path in ${rel}: $($Matches[0])" }
    if ($rel -notin @("references/base-kit.md", "references/glossary.md", "CHANGELOG.md", "scripts/validate.ps1") -and $raw -match '\bC32\b|context-guard|Auto-Caveman') {
        $failures += "[RETIRED] $rel still references retired C32 / context-guard"
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
Write-Host "Behavioral eval prompts checked structurally only; no model run or behavior score." -ForegroundColor Gray

if ($failures.Count -gt 0) {
    Write-Host "`nVALIDATION FAILED ($($failures.Count) issues):" -ForegroundColor Red
    $failures | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    exit 1
}

Write-Host "ALL CHECKS PASSED (0 errors)." -ForegroundColor Green
exit 0
