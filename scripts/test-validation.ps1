# Run with: powershell -NoProfile -ExecutionPolicy Bypass -File scripts/test-validation.ps1
# Exercise the actual gate on a disposable copy, including negative cases.
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$fixture = Join-Path $root ('.validation-test-' + [guid]::NewGuid().ToString('N'))
$shell = (Get-Process -Id $PID).Path
$utf8 = New-Object System.Text.UTF8Encoding($false)

function Write-FixtureFile($relative, $text) {
    [IO.File]::WriteAllText((Join-Path $fixture $relative), $text, $utf8)
}

function Assert-Gate($expectedExit, $markers) {
    $output = & $shell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $fixture 'scripts/validate.ps1') 2>&1
    if ($LASTEXITCODE -ne $expectedExit) { throw "Unexpected gate exit: $LASTEXITCODE`n$output" }
    foreach ($marker in $markers) {
        if (-not ($output -join "`n").Contains($marker)) { throw "Missing gate diagnostic: $marker" }
    }
}

try {
    New-Item -ItemType Directory -Path $fixture | Out-Null
    Get-ChildItem -LiteralPath $root -Force | Where-Object {
        $_.Name -notin @('.git', 'dist', '.spec-fix-baseline') -and $_.Name -notlike '.validation-test-*'
    } | ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $fixture -Recurse -Force }

    # Baseline covers translated trigger forms and the English single-skill rule.
    Assert-Gate 0 @('ALL CHECKS PASSED')
    $entry = [IO.File]::ReadAllText((Join-Path $fixture 'SKILL.md'))
    $skillPath = 'skills/auto-guide/SKILL.md'
    $skill = [IO.File]::ReadAllText((Join-Path $fixture $skillPath))
    $translated = $entry -replace '(?m)^description:.*', 'description: Activates when project documentation is missing.'
    $translatedSkill = $skill -replace '(?m)^description:.*', 'description: Used at workflow selection when the user needs routing.'
    Write-FixtureFile 'SKILL.md' $translated
    Write-FixtureFile $skillPath $translatedSkill
    Assert-Gate 0 @('ALL CHECKS PASSED')

    Write-FixtureFile 'SKILL.md' ($entry -replace '(?:\*\*only the one sub-skill of the current step\*\*|ch\u1EC9 m\u1EDF \u0111\u00FAng 1 sub-skill)', 'any available sub-skills')
    Write-FixtureFile $skillPath ($skill -replace '(?m)^description:.*', 'description: Helpful workflow automation for everyone.')
    Assert-Gate 1 @('[SDO]', 'Just-in-time single sub-skill read budget (C17)')

    Write-FixtureFile 'SKILL.md' $entry
    Write-FixtureFile $skillPath ($skill + ("`n" * 111))
    Assert-Gate 1 @('[RATCHET]')
    # Execute the real standalone-copy block with workspace-local targets, avoiding global installs.
    $tokens = $null; $parseErrors = $null
    $ast = [Management.Automation.Language.Parser]::ParseFile((Join-Path $root 'install.ps1'), [ref]$tokens, [ref]$parseErrors)
    if ($parseErrors.Count) { throw 'Installer parse failed.' }
    $copyBlock = @($ast.FindAll({ param($node)
        $node -is [Management.Automation.Language.ForEachStatementAst] -and
        $node.Condition.Extent.Text -eq '$(if ($Standalone) { $Targets } else { @() })'
    }, $true))
    if ($copyBlock.Count -ne 1) { throw 'Cannot locate standalone installation block.' }
    $SourceDir = $root; $Standalone = $true; $SkillName = 'writing-spec-for-ai'
    $installed = Join-Path $fixture '.installed'
    $Targets = @(@{ Name = 'Fixture'; Root = $installed })
    $SubSkills = @(Get-ChildItem -LiteralPath (Join-Path $root 'skills') -Directory)
    & ([scriptblock]::Create($copyBlock[0].Extent.Text))
    foreach ($sub in $SubSkills) {
        foreach ($asset in @('references', 'templates', 'scripts')) {
            $assetRoot = Join-Path $sub.FullName $asset
            if (-not (Test-Path -LiteralPath $assetRoot)) { continue }
            foreach ($file in Get-ChildItem -LiteralPath $assetRoot -File -Recurse) {
                $relative = $file.FullName.Substring($sub.FullName.Length + 1)
                $copy = Join-Path (Join-Path $installed $sub.Name) $relative
                if (-not (Test-Path -LiteralPath $copy) -or (Get-FileHash -LiteralPath $copy).Hash -ne (Get-FileHash -LiteralPath $file.FullName).Hash) {
                    throw "Standalone asset missing or changed: $($sub.Name)/$relative"
                }
            }
        }
    }
    Write-Host 'PASS: translated triggers accepted; invalid descriptions, missing C17 and oversized skills rejected; standalone local assets preserved.'
} finally {
    # The only recursive removal is the exact workspace-local fixture created above.
    $resolved = [IO.Path]::GetFullPath($fixture)
    if ((Split-Path -Parent $resolved) -ne $root -or (Split-Path -Leaf $resolved) -notlike '.validation-test-*') {
        throw "Refusing cleanup outside the fixture: $resolved"
    }
    if (Test-Path -LiteralPath $resolved) { Remove-Item -LiteralPath $resolved -Recurse -Force }
}
