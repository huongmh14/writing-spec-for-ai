# Writing Spec for AI - Cross-Agent Installer (Windows PowerShell)
# Usage (One-liner):
#   irm https://raw.githubusercontent.com/huongmh14/writing-spec-for-ai/main/install.ps1 | iex
# Usage (Local clone):
#   powershell -ExecutionPolicy Bypass -File .\install.ps1

$ErrorActionPreference = "Stop"
$RepoUrl = "https://github.com/huongmh14/writing-spec-for-ai.git"
$SkillName = "writing-spec-for-ai"
$Version = "1.3.0"

Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "  Installing Writing Spec for AI v$Version             " -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan

$TempDir = $null
$SourceDir = $PSScriptRoot

# Guard against irm ... | iex where $PSScriptRoot is empty and CWD happens to contain an unrelated SKILL.md
$IsLocalRepo = (-not [string]::IsNullOrWhiteSpace($SourceDir)) -and
               (Test-Path (Join-Path $SourceDir "SKILL.md")) -and
               (Test-Path (Join-Path $SourceDir "references\base-kit.md")) -and
               (Test-Path (Join-Path $SourceDir "skills\survey-project\SKILL.md"))

if (-not $IsLocalRepo) {
    $TempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("writing-spec-for-ai-" + [System.Guid]::NewGuid().ToString("N"))
    Write-Host "[1/4] Downloading latest release from $RepoUrl ..." -ForegroundColor Yellow
    git clone --depth 1 $RepoUrl $TempDir | Out-Null
    $SourceDir = $TempDir
} else {
    Write-Host "[1/4] Using local repository at $SourceDir ..." -ForegroundColor Yellow
}

$RawTargets = @(
    @{ Name = "Universal (.agents)"; Root = "$HOME\.agents\skills" },
    @{ Name = "Antigravity";         Root = "$HOME\.gemini\config\skills" },
    @{ Name = "Claude Code";         Root = "$HOME\.claude\skills" },
    @{ Name = "OpenCode";            Root = "$HOME\.config\opencode\skills" },
    @{ Name = "Cursor";              Root = "$HOME\.cursor\skills" },
    @{ Name = "ZCode";               Root = "$HOME\.zcode\skills" }
)
$SeenRoots = @{}
$Targets = @()
foreach ($rt in $RawTargets) {
    $resolved = $rt.Root
    if (Test-Path $rt.Root) {
        $item = Get-Item $rt.Root -Force -ErrorAction SilentlyContinue
        if ($item -and $item.LinkType -and $item.Target) {
            $resolved = [string]($item.Target | Select-Object -First 1)
        }
    }
    if (-not $SeenRoots.ContainsKey($resolved)) {
        $SeenRoots[$resolved] = $true
        $Targets += $rt
    }
}

$ExcludeItems = @(".git", ".github", "dist", "skills")
$SubSkills = Get-ChildItem -Path (Join-Path $SourceDir "skills") -Directory

Write-Host "[2/4] Installing main orchestrator skill ($SkillName)..." -ForegroundColor Yellow

foreach ($Target in $Targets) {
    $RootDir = $Target.Root
    $Dest = Join-Path $RootDir $SkillName
    if (Test-Path $Dest) {
        Remove-Item -Recurse -Force $Dest
    }
    New-Item -ItemType Directory -Force -Path $Dest | Out-Null

    Get-ChildItem -Path $SourceDir -Force | Where-Object { $ExcludeItems -notcontains $_.Name } | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination $Dest -Recurse -Force
    }
    $TplSkill = Join-Path $Dest "templates\project-skill\SKILL.md"
    if (Test-Path $TplSkill) {
        Move-Item -LiteralPath $TplSkill -Destination (Join-Path $Dest "templates\project-skill\SKILL.template.md") -Force
    }
    $OrchRaw = Get-Content (Join-Path $Dest "SKILL.md") -Raw -Encoding UTF8
    $OrchNorm = $OrchRaw `
        -replace '\[skills/\]\(skills/\)', '[../](../)' `
        -replace '\[skills/([a-z0-9-]+)\]\(skills/([a-z0-9-]+)/SKILL\.md\)', '[../$1](../$2/SKILL.md)' `
        -replace 'templates/project-skill/SKILL\.md', 'templates/project-skill/SKILL.template.md'
    [System.IO.File]::WriteAllText((Join-Path $Dest "SKILL.md"), $OrchNorm, (New-Object System.Text.UTF8Encoding($false)))
    Write-Host ("  [+] Installed orchestrator -> {0,-20} ({1})" -f $Target.Name, $Dest) -ForegroundColor Green
}

Write-Host "[3/4] Installing 9 standalone sub-skills at top level for direct discovery..." -ForegroundColor Yellow

foreach ($Target in $Targets) {
    $RootDir = $Target.Root
    foreach ($Sub in $SubSkills) {
        $SubDest = Join-Path $RootDir $Sub.Name
        if (Test-Path $SubDest) {
            Remove-Item -Recurse -Force $SubDest
        }
        New-Item -ItemType Directory -Force -Path $SubDest | Out-Null

        # Copy shared references, packs, agents, templates, scripts, and profiles so standalone invocation resolves all links
        foreach ($Shared in @("references", "packs", "agents", "templates", "scripts", "profiles.md", "LICENSE")) {
            $SharedPath = Join-Path $SourceDir $Shared
            if (Test-Path $SharedPath) {
                Copy-Item -Path $SharedPath -Destination $SubDest -Recurse -Force
            }
        }
        $SubTplSkill = Join-Path $SubDest "templates\project-skill\SKILL.md"
        if (Test-Path $SubTplSkill) {
            Move-Item -LiteralPath $SubTplSkill -Destination (Join-Path $SubDest "templates\project-skill\SKILL.template.md") -Force
        }

        # Copy sub-skill SKILL.md and normalize ../../ relative links to ./
        $RawSkill = Get-Content (Join-Path $Sub.FullName "SKILL.md") -Raw -Encoding UTF8
        $NormalizedSkill = $RawSkill `
            -replace '\.\./\.\./references/', './references/' `
            -replace '\.\./\.\./templates/', './templates/' `
            -replace '\.\./\.\./packs/', './packs/' `
            -replace '\.\./\.\./agents/', './agents/' `
            -replace '\.\./\.\./profiles\.md', './profiles.md' `
            -replace '\.\./([a-z0-9-]+)/SKILL\.md', '../$1/SKILL.md'
        [System.IO.File]::WriteAllText((Join-Path $SubDest "SKILL.md"), $NormalizedSkill, (New-Object System.Text.UTF8Encoding($false)))
    }
    Write-Host ("  [+] Installed 9 sub-skills -> {0,-20} ({1})" -f $Target.Name, $RootDir) -ForegroundColor Green
}

Write-Host "[4/4] Installing specialized subagents (spec-surveyor, spec-challenger, doc-tester)..." -ForegroundColor Yellow

$AgentDirs = @(
    "$HOME\.claude\agents",
    "$HOME\.agents\agents",
    "$HOME\.cursor\agents"
)

if (Test-Path (Join-Path $SourceDir "agents")) {
    foreach ($AgentDir in $AgentDirs) {
        New-Item -ItemType Directory -Force -Path $AgentDir | Out-Null
        Get-ChildItem -Path (Join-Path $SourceDir "agents") -Filter "*.md" | ForEach-Object {
            Copy-Item -Path $_.FullName -Destination (Join-Path $AgentDir $_.Name) -Force
        }
        Write-Host ("  [+] Installed subagents -> {0}" -f $AgentDir) -ForegroundColor Green
    }
}

$HookDirs = @(
    "$HOME\.agents\hooks",
    "$HOME\.claude\hooks"
)
foreach ($HookDir in $HookDirs) {
    New-Item -ItemType Directory -Force -Path $HookDir | Out-Null
    foreach ($HookScript in @("context-guard.ps1", "context-guard.sh")) {
        $SrcHook = Join-Path $SourceDir "scripts\$HookScript"
        if (Test-Path $SrcHook) {
            Copy-Item -Path $SrcHook -Destination (Join-Path $HookDir $HookScript) -Force
        }
    }
    Write-Host ("  [+] Installed Context & Token Guard Hook (C32) -> {0}" -f $HookDir) -ForegroundColor Green
}

# Register Context Guard Hook (C32) into Claude Code settings.json (UserPromptSubmit) and Cursor hooks.json (preToolUse)
$HookCmd = "powershell -NoProfile -ExecutionPolicy Bypass -File `"$($HOME -replace '\\','\\')\\.agents\\hooks\\context-guard.ps1`""
$ClaudeSettings = Join-Path $HOME ".claude\settings.json"
if (Test-Path $ClaudeSettings) {
    $rawClaude = Get-Content $ClaudeSettings -Raw -Encoding UTF8
    if ($rawClaude -notmatch 'context-guard\.ps1') {
        try {
            $cfg = $rawClaude | ConvertFrom-Json
            if (-not $cfg.hooks) { $cfg | Add-Member -NotePropertyName "hooks" -NotePropertyValue ([pscustomobject]@{}) }
            $entry = [pscustomobject]@{
                hooks = @(
                    [pscustomobject]@{
                        type    = "command"
                        command = "powershell -NoProfile -ExecutionPolicy Bypass -File `"$HOME\.agents\hooks\context-guard.ps1`""
                        timeout = 5
                    }
                )
            }
            if (-not $cfg.hooks.UserPromptSubmit) {
                $cfg.hooks | Add-Member -NotePropertyName "UserPromptSubmit" -NotePropertyValue @($entry)
            } else {
                $cfg.hooks.UserPromptSubmit = @($cfg.hooks.UserPromptSubmit) + @($entry)
            }
            [System.IO.File]::WriteAllText($ClaudeSettings, ($cfg | ConvertTo-Json -Depth 10), (New-Object System.Text.UTF8Encoding($false)))
            Write-Host "  [+] Registered UserPromptSubmit hook in $ClaudeSettings" -ForegroundColor Green
        } catch { }
    }
}
$CursorHooks = Join-Path $HOME ".cursor\hooks.json"
if (Test-Path $CursorHooks) {
    $rawCursor = Get-Content $CursorHooks -Raw -Encoding UTF8
    if ($rawCursor -notmatch 'context-guard\.ps1') {
        try {
            $ccfg = $rawCursor | ConvertFrom-Json
            if ($ccfg.hooks -and $ccfg.hooks.preToolUse) {
                $cEntry = [pscustomobject]@{
                    command = "powershell -NoProfile -ExecutionPolicy Bypass -File `"$HOME\.agents\hooks\context-guard.ps1`""
                    timeout = 5
                }
                $ccfg.hooks.preToolUse = @($ccfg.hooks.preToolUse) + @($cEntry)
                [System.IO.File]::WriteAllText($CursorHooks, ($ccfg | ConvertTo-Json -Depth 10), (New-Object System.Text.UTF8Encoding($false)))
                Write-Host "  [+] Registered preToolUse hook in $CursorHooks" -ForegroundColor Green
            }
        } catch { }
    }
}

if ($TempDir -and (Test-Path $TempDir)) {
    Remove-Item -Recurse -Force $TempDir
}

Write-Host ""
Write-Host "Done! Installed 10 skills + 3 subagents. Try asking your agent:" -ForegroundColor Cyan
Write-Host '  "Use skill writing-spec-for-ai to survey this repo and propose a doc design."' -ForegroundColor White
