#!/usr/bin/env pwsh
<#! 
.SYNOPSIS
Refresh agent context files with the latest garden-planning insights from plan.md.

.DESCRIPTION
Reads the active garden plan, extracts zone highlights, infrastructure notes,
seasonal playbook details, and tool/material standards, then regenerates each
agent guidance file while preserving manual additions.

.PARAMETER AgentType
Optional agent key (claude, gemini, copilot, cursor-agent, qwen, opencode,
codex, windsurf, kilocode, auggie, roo, codebuddy, q). When omitted the script
updates all existing agent files and creates a Claude file if none are present.
#>
param(
    [Parameter(Position = 0)]
    [ValidateSet('claude','gemini','copilot','cursor-agent','qwen','opencode','codex','windsurf','kilocode','auggie','roo','codebuddy','q')]
    [string]$AgentType
)

$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $scriptDir 'common.ps1')

$paths = Get-FeaturePathsEnv
$repoRoot = $paths.REPO_ROOT
$planPath = $paths.IMPL_PLAN
$branch = $paths.CURRENT_BRANCH

if (-not (Test-FeatureBranch -Branch $branch -HasGit $paths.HAS_GIT)) {
    exit 1
}
if (-not (Test-Path $planPath)) {
    Write-Error "No plan.md found for $branch. Run /speckit.plan before updating agent context."
    exit 1
}

$templatePath = Join-Path $repoRoot '.specify/templates/agent-file-template.md'
if (-not (Test-Path $templatePath)) {
    Write-Error "Template missing at $templatePath. Re-run specify init or restore the template."
    exit 1
}

$planContent = Get-Content -LiteralPath $planPath -Raw -Encoding utf8

function Get-MarkdownSection {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Content,
        [Parameter(Mandatory = $true)]
        [string]$Heading
    )
    $escaped = [Regex]::Escape($Heading)
    $pattern = "(?ms)^\s*$escaped\s*\r?\n(.*?)(?=^\s*#|\Z)"
    $match = [Regex]::Match($Content, $pattern)
    if ($match.Success) {
        return ($match.Groups[1].Value.Trim())
    }
    return ''
}

function Build-AgentContent {
    param(
        [string]$Template,
        [string]$GardenName,
        [datetime]$DateStamp,
        [string]$ZoneSummary,
        [string]$Infrastructure,
        [string]$Seasonal,
        [string]$Resources,
        [string]$Recent,
        [string]$ManualBlock
    )

    $content = $Template
    $content = $content.Replace('[GARDEN NAME]', $GardenName)
    if ([string]::IsNullOrWhiteSpace($ZoneSummary)) { $zoneText = '_No zones documented yet._' } else { $zoneText = $ZoneSummary.Trim() }
    if ([string]::IsNullOrWhiteSpace($Infrastructure)) { $infraText = '_No infrastructure updates recorded._' } else { $infraText = $Infrastructure.Trim() }
    if ([string]::IsNullOrWhiteSpace($Seasonal)) { $seasonalText = '_Seasonal playbook pending update._' } else { $seasonalText = $Seasonal.Trim() }
    if ([string]::IsNullOrWhiteSpace($Resources)) { $resourceText = '_Tool and material standards not captured yet._' } else { $resourceText = $Resources.Trim() }

    $content = $content.Replace('[Summaries extracted from plan.md files]', $zoneText)
    $content = $content.Replace('[Composite map of beds, paths, irrigation, storage, structures]', $infraText)
    $content = $content.Replace('[Key planting/harvest windows, maintenance cadence, observation checkpoints]', $seasonalText)
    $content = $content.Replace('[Reusable lists derived from care-guide.md and layout-guide.md]', $resourceText)
    $content = $content.Replace('[Last three plans or amendments with highlights and impacted zones]', $Recent)
    $content = $content.Replace('[DATE]', $DateStamp.ToString('yyyy-MM-dd'))

    if (-not [string]::IsNullOrEmpty($ManualBlock)) {
        $replacement = "<!-- MANUAL ADDITIONS START -->`n$($ManualBlock.Trim())`n<!-- MANUAL ADDITIONS END -->"
        $content = [Regex]::Replace(
            $content,
            '(?s)<!-- MANUAL ADDITIONS START -->.*?<!-- MANUAL ADDITIONS END -->',
            $replacement
        )
    }
    return $content
}

function Extract-ManualBlock {
    param([string]$ExistingContent)
    $match = [Regex]::Match($ExistingContent, '(?s)<!-- MANUAL ADDITIONS START -->(.*?)<!-- MANUAL ADDITIONS END -->')
    if ($match.Success) { return $match.Groups[1].Value }
    return ''
}

function Calculate-RecentEntry {
    param([string]$Branch)
    $today = Get-Date -Format 'yyyy-MM-dd'
    return "- $Branch: plan refreshed on $today"
}

$zoneSection = Get-MarkdownSection -Content $planContent -Heading '### Zones Overview'
$infraAccess = Get-MarkdownSection -Content $planContent -Heading '### Circulation & Access'
$infraWater  = Get-MarkdownSection -Content $planContent -Heading '### Water & Soil Strategy'
$seasonalRoadmap = Get-MarkdownSection -Content $planContent -Heading '## Phasing Roadmap'
$resourcePlan = Get-MarkdownSection -Content $planContent -Heading '## Resource Plan'

$gardenName = Split-Path $repoRoot -Leaf
$recentEntry = Calculate-RecentEntry -Branch $branch
$templateRaw = Get-Content -LiteralPath $templatePath -Raw -Encoding utf8

$agentTargets = @{
    'claude'      = Join-Path $repoRoot 'CLAUDE.md';
    'gemini'      = Join-Path $repoRoot 'GEMINI.md';
    'copilot'     = Join-Path $repoRoot '.github/copilot-instructions.md';
    'cursor-agent'= Join-Path $repoRoot '.cursor/rules/specify-rules.mdc';
    'qwen'        = Join-Path $repoRoot 'QWEN.md';
    'opencode'    = Join-Path $repoRoot 'AGENTS.md';
    'codex'       = Join-Path $repoRoot 'AGENTS.md';
    'windsurf'    = Join-Path $repoRoot '.windsurf/rules/specify-rules.md';
    'kilocode'    = Join-Path $repoRoot '.kilocode/rules/specify-rules.md';
    'auggie'      = Join-Path $repoRoot '.augment/rules/specify-rules.md';
    'roo'         = Join-Path $repoRoot '.roo/rules/specify-rules.md';
    'codebuddy'   = Join-Path $repoRoot 'CODEBUDDY.md';
    'q'           = Join-Path $repoRoot 'AGENTS.md'
}

function Update-AgentFile {
    param(
        [string]$AgentKey,
        [string]$TargetFile
    )

    $dir = Split-Path -Parent $TargetFile
    if (-not [string]::IsNullOrWhiteSpace($dir) -and -not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
    }

    $manual = ''
    if (Test-Path $TargetFile) {
        $existing = Get-Content -LiteralPath $TargetFile -Raw -Encoding utf8
        $manual = Extract-ManualBlock -ExistingContent $existing
    }

    $infraSections = @($infraAccess, $infraWater) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    if ($infraSections) {
        $infraCombined = [string]::Join("`n`n", $infraSections)
    } else {
        $infraCombined = ''
    }

    $content = Build-AgentContent `
        -Template $templateRaw `
        -GardenName $gardenName `
        -DateStamp (Get-Date) `
        -ZoneSummary $zoneSection `
        -Infrastructure $infraCombined `
        -Seasonal $seasonalRoadmap `
        -Resources $resourcePlan `
        -Recent $recentEntry `
        -ManualBlock $manual

    Set-Content -LiteralPath $TargetFile -Value $content -Encoding utf8
    Write-Host ("[done] Updated agent guidance for {0} -> {1}" -f $AgentKey, $TargetFile)
}

if ($AgentType) {
    Update-AgentFile -AgentKey $AgentType -TargetFile $agentTargets[$AgentType]
} else {
    $updatedAny = $false
    foreach ($pair in $agentTargets.GetEnumerator()) {
        if (Test-Path $pair.Value) {
            Update-AgentFile -AgentKey $pair.Key -TargetFile $pair.Value
            $updatedAny = $true
        }
    }
    if (-not $updatedAny) {
        Update-AgentFile -AgentKey 'claude' -TargetFile $agentTargets['claude']
    }
}

Write-Host ''
Write-Host 'Summary:'
Write-Host ("  Garden plan : {0}" -f $branch)
$zonesStatus = if ([string]::IsNullOrWhiteSpace($zoneSection)) { 'missing (update plan.md)' } else { 'documented' }
$infraStatus = if ((@($infraAccess, $infraWater) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }).Count -gt 0) { 'documented' } else { 'pending' }
$seasonalStatus = if ([string]::IsNullOrWhiteSpace($seasonalRoadmap)) { 'pending' } else { 'documented' }
Write-Host ("  Zones captured : {0}" -f $zonesStatus)
Write-Host ("  Infrastructure : {0}" -f $infraStatus)
Write-Host ("  Seasonal playbook : {0}" -f $seasonalStatus)

exit 0
