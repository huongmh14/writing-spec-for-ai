# Writing Spec for AI - Cross-Agent Installer (Windows PowerShell)
# Usage (One-liner):
#   irm https://raw.githubusercontent.com/huongmh14/writing-spec-for-ai/main/install.ps1 | iex
# Usage (Local clone):
#   powershell -ExecutionPolicy Bypass -File .\install.ps1

$ErrorActionPreference = "Stop"
$RepoUrl = "https://github.com/huongmh14/writing-spec-for-ai.git"
$SkillName = "writing-spec-for-ai"

Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "  Installing Writing Spec for AI v1.2.0             " -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan

$TempDir = $null
$SourceDir = $PSScriptRoot

if ([string]::IsNullOrWhiteSpace($SourceDir) -or -not (Test-Path (Join-Path $SourceDir "SKILL.md"))) {
    $TempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("writing-spec-for-ai-" + [System.Guid]::NewGuid().ToString("N"))
    Write-Host "[1/3] Downloading latest release from $RepoUrl ..." -ForegroundColor Yellow
    git clone --depth 1 $RepoUrl $TempDir | Out-Null
    $SourceDir = $TempDir
} else {
    Write-Host "[1/3] Using local repository at $SourceDir ..." -ForegroundColor Yellow
}

$Targets = @(
    @{ Name = "Universal (.agents)"; Path = "$HOME\.agents\skills\$SkillName" },
    @{ Name = "Antigravity";         Path = "$HOME\.gemini\config\skills\$SkillName" },
    @{ Name = "Claude Code";         Path = "$HOME\.claude\skills\$SkillName" },
    @{ Name = "Codex";               Path = "$HOME\.codex\skills\$SkillName" },
    @{ Name = "OpenCode";            Path = "$HOME\.config\opencode\skills\$SkillName" },
    @{ Name = "Cursor";              Path = "$HOME\.cursor\skills\$SkillName" },
    @{ Name = "ZCode";               Path = "$HOME\.zcode\skills\$SkillName" }
)

$ExcludeItems = @(".git", ".github", "dist")

Write-Host "[2/3] Installing skill suite to AI coding agents..." -ForegroundColor Yellow

foreach ($Target in $Targets) {
    $Dest = $Target.Path
    if (Test-Path $Dest) {
        Remove-Item -Recurse -Force $Dest
    }
    New-Item -ItemType Directory -Force -Path $Dest | Out-Null

    Get-ChildItem -Path $SourceDir -Force | Where-Object { $ExcludeItems -notcontains $_.Name } | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination $Dest -Recurse -Force
    }
    Write-Host ("  [+] Installed skill suite -> {0,-20} ({1})" -f $Target.Name, $Dest) -ForegroundColor Green
}

Write-Host "[3/3] Installing specialized subagents (spec-surveyor, spec-challenger, doc-tester)..." -ForegroundColor Yellow

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

if ($TempDir -and (Test-Path $TempDir)) {
    Remove-Item -Recurse -Force $TempDir
}

Write-Host ""
Write-Host "Done! Try asking your agent:" -ForegroundColor Cyan
Write-Host '  "Use skill writing-spec-for-ai to survey this repo and propose a doc design."' -ForegroundColor White
