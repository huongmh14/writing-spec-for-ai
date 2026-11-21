<#
.SYNOPSIS
    Warn-only audit of a USER project's docs (validate.ps1 checks this kit, not user projects).
.EXAMPLE
    powershell -File scripts/audit-project.ps1 <path-to-your-project>
.NOTES
    Checks: docs/code line ratio, same-topic duplicate docs, bug-ledger entries missing SHA, runnable check or kit signal (references/kit-evidence.md).
    Always exits 0: these are warnings from measured projects, not hard gates.
#>
param([Parameter(Mandatory)][string]$Path)
$ErrorActionPreference = 'Stop'
$skip = '\\(\.git|node_modules|\.venv|venv|__pycache__|dist|build|models|data)\\'
$all = Get-ChildItem $Path -Recurse -File | Where-Object { $_.FullName -notmatch $skip }
$count = { param($files) ($files | ForEach-Object { (Get-Content $_.FullName -ErrorAction SilentlyContinue | Measure-Object -Line).Lines } | Measure-Object -Sum).Sum }
$md  = $all | Where-Object Extension -eq '.md'
$src = $all | Where-Object { $_.Extension -in '.py','.ts','.tsx','.js','.vue','.go','.rs','.cs','.java' }
$mdL = & $count $md; $srcL = & $count $src
$warn = @()

# 1. docs/code ratio (measured: 5.46 in a project with 100 open ACs)
if ($srcL -gt 0 -and ($mdL / $srcL) -gt 2) {
    $warn += ("[RATIO] docs/code = {0:N2} ({1} md lines vs {2} src lines, max 2). Merge or archive docs before writing more." -f ($mdL / $srcL), $mdL, $srcL)
}

# 2. same-topic duplicates: X.md and X-design.md / X-spec.md in one folder
$md | Group-Object { $_.DirectoryName + '|' + ($_.BaseName -replace '-(design|spec|plan)$','') } |
    Where-Object { $_.Count -gt 1 } | ForEach-Object {
        $warn += "[DUP] one topic, several files: $(($_.Group.Name) -join ', ')  keep one source of truth."
    }

# 3. bug ledger: every entry needs a SHA (or 'no commit: reason') and a runnable check
$ledger = $md | Where-Object Name -eq 'conflicts-and-bugs.md' | Select-Object -First 1
if ($ledger) {
    $entries = (Get-Content $ledger.FullName -Raw -Encoding UTF8) -split '(?m)^## ' | Select-Object -Skip 1
    $sig = @{}
    foreach ($e in $entries) {
        $title = ($e -split "`n")[0].Trim()
        if ($e -notmatch '\b[0-9a-f]{7,40}\b' -and $e -notmatch '(?i)no commit') { $warn += "[LEDGER] '$title': no commit SHA and no 'no commit: <reason>'." }
        if ($e -match '(?i)kit-(missed|ignored|caught)|not-kit') { $sig[$Matches[0].ToLower()]++ } else { $warn += "[LEDGER] '$title': no kit signal (kit-missed/kit-ignored/kit-caught/not-kit), see references/kit-evidence.md." }
        if ($e -notmatch '(?i)pytest|npm (run )?test|check|lint|\.ps1|\.sh|python .*\.py') { $warn += "[LEDGER] '$title': no runnable check." }
    }
}

if ($ledger) { Write-Host ("Kit signals: " + (($sig.GetEnumerator() | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Value)" }) -join ', ')) -ForegroundColor Cyan }
if ($warn) { $warn | ForEach-Object { Write-Host "WARN $_" -ForegroundColor Yellow } } else { Write-Host 'No warnings.' -ForegroundColor Green }
exit 0
