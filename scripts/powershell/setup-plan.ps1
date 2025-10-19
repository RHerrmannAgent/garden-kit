#!/usr/bin/env pwsh
# Prepare garden layout planning artefacts

[CmdletBinding()]
param(
    [switch]$Json,
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

# Show help if requested
if ($Help) {
    Write-Output "Usage: ./setup-plan.ps1 [-Json] [-Help]"
    Write-Output "  -Json     Output results in JSON format"
    Write-Output "  -Help     Show this help message"
    exit 0
}

# Load common functions
. "$PSScriptRoot/common.ps1"

# Get all paths and variables from common functions
$paths = Get-FeaturePathsEnv

# Check if we're on a proper garden branch (only for git repos)
if (-not (Test-FeatureBranch -Branch $paths.CURRENT_BRANCH -HasGit:$paths.HAS_GIT)) { 
    exit 1 
}

# Ensure the feature directory exists
New-Item -ItemType Directory -Path $paths.FEATURE_DIR -Force | Out-Null

# Copy plan template plus supporting stubs (if available)
$templateDir = Join-Path $paths.REPO_ROOT '.gardify/templates'

function Copy-OrCreate {
    param(
        [string]$TemplateName,
        [string]$DestinationPath
    )

    $source = Join-Path $templateDir $TemplateName
    if (Test-Path $source) {
        Copy-Item $source $DestinationPath -Force
        Write-Output "Copied $TemplateName to $DestinationPath"
    } else {
        if (-not (Test-Path $DestinationPath -PathType Leaf)) {
            New-Item -ItemType File -Path $DestinationPath -Force | Out-Null
        }
        Write-Warning "$TemplateName not found under $templateDir. Created empty file at $DestinationPath"
    }
}

Copy-OrCreate -TemplateName 'plan-template.md' -DestinationPath $paths.IMPL_PLAN
Copy-OrCreate -TemplateName 'site-research-template.md' -DestinationPath $paths.SITE_RESEARCH
Copy-OrCreate -TemplateName 'existing-plant-inventory-template.md' -DestinationPath $paths.EXISTING_PLANTS
Copy-OrCreate -TemplateName 'planting-schema-template.md' -DestinationPath $paths.PLANTING_SCHEMA
Copy-OrCreate -TemplateName 'seasonal-calendar-template.md' -DestinationPath $paths.SEASONAL_CALENDAR
Copy-OrCreate -TemplateName 'monthly-care-template.md' -DestinationPath $paths.MONTHLY_CARE
Copy-OrCreate -TemplateName 'tools-template.md' -DestinationPath $paths.TOOLS
Copy-OrCreate -TemplateName 'quickstart-template.md' -DestinationPath $paths.QUICKSTART

# Output results
if ($Json) {
    $result = [PSCustomObject]@{ 
        FEATURE_SPEC = $paths.FEATURE_SPEC
        IMPL_PLAN    = $paths.IMPL_PLAN
        SPECS_DIR    = $paths.FEATURE_DIR
        BRANCH       = $paths.CURRENT_BRANCH
        HAS_GIT      = $paths.HAS_GIT
        SITE_RESEARCH     = $paths.SITE_RESEARCH
        EXISTING_PLANTS   = $paths.EXISTING_PLANTS
        PLANTING_SCHEMA   = $paths.PLANTING_SCHEMA
        SEASONAL_CALENDAR = $paths.SEASONAL_CALENDAR
        MONTHLY_CARE      = $paths.MONTHLY_CARE
        TOOLS             = $paths.TOOLS
        QUICKSTART        = $paths.QUICKSTART
    }
    $result | ConvertTo-Json -Compress
} else {
    Write-Output "FEATURE_SPEC: $($paths.FEATURE_SPEC)"
    Write-Output "IMPL_PLAN: $($paths.IMPL_PLAN)"
    Write-Output "SPECS_DIR: $($paths.FEATURE_DIR)"
    Write-Output "BRANCH: $($paths.CURRENT_BRANCH)"
    Write-Output "HAS_GIT: $($paths.HAS_GIT)"
    Write-Output "SITE_RESEARCH: $($paths.SITE_RESEARCH)"
    Write-Output "EXISTING_PLANTS: $($paths.EXISTING_PLANTS)"
    Write-Output "PLANTING_SCHEMA: $($paths.PLANTING_SCHEMA)"
    Write-Output "SEASONAL_CALENDAR: $($paths.SEASONAL_CALENDAR)"
    Write-Output "MONTHLY_CARE: $($paths.MONTHLY_CARE)"
    Write-Output "TOOLS: $($paths.TOOLS)"
    Write-Output "QUICKSTART: $($paths.QUICKSTART)"
}
