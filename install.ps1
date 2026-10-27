# Writing Spec for AI - Cross-Agent Installer (Windows PowerShell)
# Usage (One-liner):
#   irm https://raw.githubusercontent.com/huongmh14/writing-spec-for-ai/main/install.ps1 | iex
# Usage (Local clone):
#   powershell -ExecutionPolicy Bypass -File .\install.ps1
# Default (lean): sub-skills ship nested in writing-spec-for-ai/skills/<name>/sub-skill.md so even
# recursive skill scanners (Codex, OpenCode) only preload the single orchestrator SKILL.md.
# -Standalone: also install the 10 sub-skills at top level for direct /write-spec etc.
# (~0.8k extra metadata tokens in EVERY session, measured with tiktoken o200k_base).
#   & ([scriptblock]::Create((irm https://raw.githubusercontent.com/huongmh14/writing-spec-for-ai/main/install.ps1))) -Standalone
param([switch]$Standalone)

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
    # Codex natively discovers ~/.agents/skills; avoid duplicating skills into ~/.codex/skills
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

$ExcludeItems = @(".git", ".github", "dist")
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
    $OrchNorm = $OrchRaw -replace 'templates/project-skill/SKILL\.md', 'templates/project-skill/SKILL.template.md'
    if (-not $Standalone) {
        # Rename nested SKILL.md -> sub-skill.md so recursive scanners (Codex, OpenCode) do not preload 10 sub-skill descriptions
        Get-ChildItem -Path (Join-Path $Dest "skills") -Directory | ForEach-Object {
            $NestedSkill = Join-Path $_.FullName "SKILL.md"
            if (Test-Path $NestedSkill) {
                $NestedRaw = (Get-Content $NestedSkill -Raw -Encoding UTF8) -replace '\.\./([a-z0-9-]+)/SKILL\.md', '../$1/sub-skill.md'
                [System.IO.File]::WriteAllText((Join-Path $_.FullName "sub-skill.md"), $NestedRaw, (New-Object System.Text.UTF8Encoding($false)))
                Remove-Item -LiteralPath $NestedSkill -Force
            }
        }
        $OrchNorm = $OrchNorm -replace 'skills/([a-z0-9-]+)/SKILL\.md', 'skills/$1/sub-skill.md'
    } else {
        $OrchNorm = $OrchNorm `
            -replace '\[skills/\]\(skills/\)', '[../](../)' `
            -replace '\[skills/([a-z0-9-]+)\]\(skills/([a-z0-9-]+)/SKILL\.md\)', '[../$1](../$2/SKILL.md)'
    }
    [System.IO.File]::WriteAllText((Join-Path $Dest "SKILL.md"), $OrchNorm, (New-Object System.Text.UTF8Encoding($false)))
    Write-Host ("  [+] Installed orchestrator -> {0,-20} ({1})" -f $Target.Name, $Dest) -ForegroundColor Green
}

if (-not $Standalone) {
    Write-Host "[3/4] Lean mode: sub-skills stay nested; removing top-level copies left by older installs..." -ForegroundColor Yellow
    foreach ($Target in $Targets) {
        foreach ($Sub in $SubSkills) {
            $Old = Join-Path $Target.Root $Sub.Name
            # Only delete folders this installer created (they carry references/base-kit.md), never a user's unrelated skill.
            if (Test-Path (Join-Path $Old "references\base-kit.md")) {
                Remove-Item -Recurse -Force $Old
                Write-Host ("  [-] Removed old top-level {0} ({1})" -f $Sub.Name, $Target.Name) -ForegroundColor DarkGray
            }
        }
    }
} else {
    Write-Host "[3/4] Installing $($SubSkills.Count) standalone sub-skills at top level for direct discovery..." -ForegroundColor Yellow
}

foreach ($Target in $(if ($Standalone) { $Targets } else { @() })) {
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
            -replace '\.\./\.\./SKILL\.md', "../$SkillName/SKILL.md" `
            -replace '\.\./([a-z0-9-]+)/SKILL\.md', '../$1/SKILL.md'
        [System.IO.File]::WriteAllText((Join-Path $SubDest "SKILL.md"), $NormalizedSkill, (New-Object System.Text.UTF8Encoding($false)))
    }
    Write-Host ("  [+] Installed $($SubSkills.Count) sub-skills -> {0,-20} ({1})" -f $Target.Name, $RootDir) -ForegroundColor Green
}

Write-Host "[4/4] Installing specialized subagents (spec-surveyor, spec-challenger, doc-tester)..." -ForegroundColor Yellow

$AgentDirs = @(
    "$HOME\.claude\agents",
    "$HOME\.agents\agents",
    "$HOME\.cursor\agents",
    "$HOME\.gemini\config\agents",
    "$HOME\.config\opencode\agents"
)

if (Test-Path (Join-Path $SourceDir "agents")) {
    foreach ($AgentDir in $AgentDirs) {
        New-Item -ItemType Directory -Force -Path $AgentDir | Out-Null
        Get-ChildItem -Path (Join-Path $SourceDir "agents") -Filter "*.md" | ForEach-Object {
            Copy-Item -Path $_.FullName -Destination (Join-Path $AgentDir $_.Name) -Force
        }
        Write-Host ("  [+] Installed subagents -> {0}" -f $AgentDir) -ForegroundColor Green
    }
    # Codex uses .toml agent definitions in ~/.codex/agents/
    $CodexAgentDir = "$HOME\.codex\agents"
    New-Item -ItemType Directory -Force -Path $CodexAgentDir | Out-Null
    Get-ChildItem -Path (Join-Path $SourceDir "agents") -Filter "*.md" | ForEach-Object {
        $araw = Get-Content $_.FullName -Raw -Encoding UTF8
        if ($araw -match '(?s)^---\r?\n(.*?)\r?\n---\r?\n(.*)$') {
            $afm = $Matches[1]; $abody = $Matches[2].Trim()
            $aname = if ($afm -match '(?m)^name:\s*(.+)$') { $Matches[1].Trim() } else { $_.BaseName }
            $adesc = if ($afm -match '(?m)^description:\s*(.+)$') { $Matches[1].Trim().Replace('"', '\"') } else { "" }
            $toml = "name = `"$aname`"`r`ndescription = `"$adesc`"`r`ndeveloper_instructions = '''`r`n$abody`r`n'''`r`n"
            [System.IO.File]::WriteAllText((Join-Path $CodexAgentDir "$aname.toml"), $toml, (New-Object System.Text.UTF8Encoding($false)))
        }
    }
    Write-Host ("  [+] Installed Codex .toml subagents -> {0}" -f $CodexAgentDir) -ForegroundColor Green
}
if ($TempDir -and (Test-Path $TempDir)) {
    Remove-Item -Recurse -Force $TempDir
}

Write-Host ""
$Mode = if ($Standalone) { "standalone: $($SubSkills.Count + 1) discoverable skills" } else { "lean: 1 discoverable skill, $($SubSkills.Count) nested sub-skills" }
Write-Host "Done! Installed ($Mode) + 3 subagents. Try asking your agent:" -ForegroundColor Cyan
Write-Host '  "Use skill writing-spec-for-ai to survey this repo and propose a doc design."' -ForegroundColor White
