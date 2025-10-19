#!/usr/bin/env pwsh
# Shared PowerShell helpers for Garden Kit workflows.

function Get-RepoRoot {
    try {
        $result = git rev-parse --show-toplevel 2>$null
        if ($LASTEXITCODE -eq 0) {
            return $result
        }
    } catch {
        # git not available or repo missing
    }

    # Fallback: three levels up from scripts directory
    return (Resolve-Path (Join-Path $PSScriptRoot "../../..")).Path
}

function Get-CurrentBranch {
    if ($env:gardify_FEATURE) {
        return $env:gardify_FEATURE
    }

    try {
        $result = git rev-parse --abbrev-ref HEAD 2>$null
        if ($LASTEXITCODE -eq 0) {
            return $result
        }
    } catch {
        # Git command failed
    }

    $repoRoot = Get-RepoRoot
    $specsDir = Join-Path $repoRoot "specs"

    if (Test-Path $specsDir) {
        $latestFeature = ""
        $highest = 0

        Get-ChildItem -Path $specsDir -Directory | ForEach-Object {
            if ($_.Name -match '^(\d{3})-') {
                $num = [int]$matches[1]
                if ($num -gt $highest) {
                    $highest = $num
                    $latestFeature = $_.Name
                }
            }
        }

        if ($latestFeature) {
            return $latestFeature
        }
    }

    return "main"
}

function Test-HasGit {
    try {
        git rev-parse --show-toplevel 2>$null | Out-Null
        return ($LASTEXITCODE -eq 0)
    } catch {
        return $false
    }
}

function Test-FeatureBranch {
    param(
        [string]$Branch,
        [bool]$HasGit = $true
    )

    if (-not $HasGit) {
        Write-Warning "[gardify] Warning: Git repository not detected; skipped branch validation"
        return $true
    }

    if ($Branch -notmatch '^[0-9]{3}-') {
        Write-Output "ERROR: Not on a feature branch. Current branch: $Branch"
        Write-Output "Garden branches should follow: 001-garden-name"
        return $false
    }

    return $true
}

function Get-FeatureDir {
    param(
        [string]$RepoRoot,
        [string]$Branch
    )
    Join-Path $RepoRoot "specs/$Branch"
}

function Get-FeaturePathsEnv {
    $repoRoot = Get-RepoRoot
    $currentBranch = Get-CurrentBranch
    $hasGit = Test-HasGit
    $featureDir = Get-FeatureDir -RepoRoot $repoRoot -Branch $currentBranch

    [PSCustomObject]@{
        REPO_ROOT         = $repoRoot
        CURRENT_BRANCH    = $currentBranch
        HAS_GIT           = $hasGit
        FEATURE_DIR       = $featureDir
        FEATURE_SPEC      = Join-Path $featureDir 'spec.md'
        IMPL_PLAN         = Join-Path $featureDir 'plan.md'
        TASKS             = Join-Path $featureDir 'tasks.md'
        SITE_RESEARCH     = Join-Path $featureDir 'site-research.md'
        EXISTING_PLANTS   = Join-Path $featureDir 'existing-plant-inventory.md'
        PLANTING_SCHEMA   = Join-Path $featureDir 'planting-schema.md'
        SEASONAL_CALENDAR = Join-Path $featureDir 'seasonal-calendar.md'
        MONTHLY_CARE      = Join-Path $featureDir 'monthly-care-plan.md'
        TOOLS             = Join-Path $featureDir 'tools.md'
        QUICKSTART        = Join-Path $featureDir 'quickstart.md'
    }
}

function Test-FileExists {
    param(
        [string]$Path,
        [string]$Description
    )

    if (Test-Path -Path $Path -PathType Leaf) {
        Write-Output "  - $Description"
        return $true
    }

    Write-Output "  - (missing) $Description"
    return $false
}

function Test-DirHasFiles {
    param(
        [string]$Path,
        [string]$Description
    )

    if ((Test-Path -Path $Path -PathType Container) -and
        (Get-ChildItem -Path $Path -ErrorAction SilentlyContinue |
         Where-Object { -not $_.PSIsContainer } |
         Select-Object -First 1)) {
        Write-Output "  - $Description"
        return $true
    }

    Write-Output "  - (missing) $Description"
    return $false
}
