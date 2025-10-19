#!/usr/bin/env pwsh
# Garden Kit prerequisite checker (PowerShell)

[CmdletBinding()]
param(
    [switch]$Json,
    [switch]$RequireTasks,
    [switch]$IncludeTasks,
    [switch]$RequireTools,
    [switch]$PathsOnly,
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

if ($Help) {
    Write-Output @"
Usage: check-prerequisites.ps1 [OPTIONS]

Options:
  -Json            Output data as JSON
  -RequireTasks    Ensure tasks.md exists (implementation stage)
  -IncludeTasks    Include tasks.md in AVAILABLE_DOCS list
  -RequireTools    Ensure tools.md exists (garden tasks require tool inventory)
  -PathsOnly       Output paths without validation (can combine with -Json)
  -Help            Show this message
"@
    exit 0
}

. "$PSScriptRoot/common.ps1"

$paths = Get-FeaturePathsEnv

if (-not (Test-FeatureBranch -Branch $paths.CURRENT_BRANCH -HasGit:$paths.HAS_GIT)) {
    exit 1
}

if ($PathsOnly) {
    $payload = [PSCustomObject]@{
        REPO_ROOT         = $paths.REPO_ROOT
        BRANCH            = $paths.CURRENT_BRANCH
        FEATURE_DIR       = $paths.FEATURE_DIR
        FEATURE_SPEC      = $paths.FEATURE_SPEC
        IMPL_PLAN         = $paths.IMPL_PLAN
        TASKS             = $paths.TASKS
        SITE_RESEARCH     = $paths.SITE_RESEARCH
        PLANTING_SCHEMA   = $paths.PLANTING_SCHEMA
        SEASONAL_CALENDAR = $paths.SEASONAL_CALENDAR
        TOOLS             = $paths.TOOLS
        QUICKSTART        = $paths.QUICKSTART
    }

    if ($Json) {
        $payload | ConvertTo-Json -Compress
    } else {
        $payload.PSObject.Properties | ForEach-Object { Write-Output ("{0}: {1}" -f $_.Name, $_.Value) }
    }
    exit 0
}

if (-not (Test-Path $paths.FEATURE_DIR -PathType Container)) {
    Write-Output "ERROR: Garden directory not found: $($paths.FEATURE_DIR)"
    Write-Output "Run /gardenkit.gardify to create the garden vision first."
    exit 1
}

if (-not (Test-Path $paths.IMPL_PLAN -PathType Leaf)) {
    Write-Output "ERROR: plan.md not found in $($paths.FEATURE_DIR)"
    Write-Output "Run /gardenkit.plan to generate the layout plan."
    exit 1
}

if ($RequireTools -and -not (Test-Path $paths.TOOLS -PathType Leaf)) {
    Write-Output "ERROR: tools.md not found in $($paths.FEATURE_DIR)"
    Write-Output "Tool inventory is required before generating tasks. Update plan or create tools.md."
    exit 1
}

if ($RequireTasks -and -not (Test-Path $paths.TASKS -PathType Leaf)) {
    Write-Output "ERROR: tasks.md not found in $($paths.FEATURE_DIR)"
    Write-Output "Run /gardenkit.tasks before attempting implementation."
    exit 1
}

$docs = @()
if (Test-Path $paths.SITE_RESEARCH)     { $docs += 'site-research.md' }
if (Test-Path $paths.EXISTING_PLANTS)   { $docs += 'existing-plant-inventory.md' }
if (Test-Path $paths.PLANTING_SCHEMA)   { $docs += 'planting-schema.md' }
if (Test-Path $paths.SEASONAL_CALENDAR) { $docs += 'seasonal-calendar.md' }
if (Test-Path $paths.MONTHLY_CARE)      { $docs += 'monthly-care-plan.md' }
if (Test-Path $paths.QUICKSTART)        { $docs += 'quickstart.md' }
if (Test-Path $paths.TOOLS)             { $docs += 'tools.md' }
if ($IncludeTasks -and (Test-Path $paths.TASKS)) { $docs += 'tasks.md' }

if ($Json) {
    [PSCustomObject]@{
        FEATURE_DIR     = $paths.FEATURE_DIR
        AVAILABLE_DOCS  = $docs
    } | ConvertTo-Json -Compress
} else {
    Write-Output "FEATURE_DIR:$($paths.FEATURE_DIR)"
    Write-Output "AVAILABLE_DOCS:"
    Test-FileExists -Path $paths.SITE_RESEARCH -Description 'site-research.md' | Out-Null
    Test-FileExists -Path $paths.EXISTING_PLANTS -Description 'existing-plant-inventory.md' | Out-Null
    Test-FileExists -Path $paths.PLANTING_SCHEMA -Description 'planting-schema.md' | Out-Null
    Test-FileExists -Path $paths.SEASONAL_CALENDAR -Description 'seasonal-calendar.md' | Out-Null
    Test-FileExists -Path $paths.MONTHLY_CARE -Description 'monthly-care-plan.md' | Out-Null
    Test-FileExists -Path $paths.TOOLS -Description 'tools.md' | Out-Null
    Test-FileExists -Path $paths.QUICKSTART -Description 'quickstart.md' | Out-Null

    if ($IncludeTasks) {
        Test-FileExists -Path $paths.TASKS -Description 'tasks.md' | Out-Null
    }
}
