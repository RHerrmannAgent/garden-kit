#!/usr/bin/env pwsh

[CmdletBinding()]
param(
    [string]$AgentType
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. "$PSScriptRoot/common.ps1"

$paths = Get-FeaturePathsEnv

$PlanPath      = $paths.IMPL_PLAN
$SpecPath      = $paths.FEATURE_SPEC
$ToolsPath     = $paths.TOOLS
$SeasonalPath  = $paths.SEASONAL_CALENDAR
$PlantingPath  = $paths.PLANTING_SCHEMA

if (-not (Test-Path $PlanPath)) {
    throw "plan.md not found at $PlanPath"
}

$ClaudeFile    = Join-Path $paths.REPO_ROOT 'CLAUDE.md'
$GeminiFile    = Join-Path $paths.REPO_ROOT 'GEMINI.md'
$CopilotFile   = Join-Path $paths.REPO_ROOT '.github/copilot-instructions.md'
$CursorFile    = Join-Path $paths.REPO_ROOT '.cursor/rules/gardify-rules.mdc'
$QwenFile      = Join-Path $paths.REPO_ROOT 'QWEN.md'
$AgentsFile    = Join-Path $paths.REPO_ROOT 'AGENTS.md'
$WindsurfFile  = Join-Path $paths.REPO_ROOT '.windsurf/rules/gardify-rules.md'
$KilocodeFile  = Join-Path $paths.REPO_ROOT '.kilocode/rules/gardify-rules.md'
$AuggieFile    = Join-Path $paths.REPO_ROOT '.augment/rules/gardify-rules.md'
$RooFile       = Join-Path $paths.REPO_ROOT '.roo/rules/gardify-rules.md'
$CodeBuddyFile = Join-Path $paths.REPO_ROOT 'CODEBUDDY.md'
$QFile         = $AgentsFile
$TemplateFile  = Join-Path $paths.REPO_ROOT '.gardify/templates/agent-file-template.md'

$DateStamp = Get-Date -Format 'yyyy-MM-dd'
$BranchName = $paths.CURRENT_BRANCH
if ($BranchName -match '^[0-9]{3}-(.+)$') {
    $GardenSlug = $Matches[1]
} else {
    $GardenSlug = $BranchName
}
$GardenTitle = ($GardenSlug -replace '-', ' ')
if ($GardenTitle.Length -gt 0) {
    $GardenTitle = $GardenTitle.Substring(0,1).ToUpper() + $GardenTitle.Substring(1)
}

if (Test-Path $SpecPath) {
    $spec = Get-Content $SpecPath -Raw
    if ($spec -match '^# .*?:\s*(.+)$') {
        $GardenTitle = $Matches[1].Trim()
    }
}

function Get-PlanSection {
    param(
        [string]$Heading,
        [string]$Path
    )
    if (-not (Test-Path $Path)) { return '' }
    $text = Get-Content $Path -Raw
    $pattern = "(?ms)^## $([regex]::Escape($Heading))\s*(.*?)(?=^## |\Z)"
    $match = [regex]::Match($text, $pattern)
    if ($match.Success) {
        return $match.Groups[1].Value.Trim()
    }
    return ''
}

function Summarize-Bullets {
    param(
        [string]$Section,
        [int]$Limit = 3
    )
    if ([string]::IsNullOrWhiteSpace($Section)) { return '' }
    $lines = $Section -split "`r?`n" | Where-Object { $_ -match '^-\s*' } | ForEach-Object { $_ -replace '^-\s*', '' }
    $result = $lines | Where-Object { $_ } | Select-Object -First $Limit
    if (-not $result) { return '' }
    return ($result -join ' / ')
}

$SummarySection  = Get-PlanSection 'Summary' $PlanPath
$SiteSection     = Get-PlanSection 'Site Conditions & Research Highlights' $PlanPath
$PlantingSection = Get-PlanSection 'Planting Schema Snapshot' $PlanPath
$SafetySection   = Get-PlanSection 'Risk & Contingency Planning' $PlanPath
$OpenSection     = Get-PlanSection 'Open Questions & Follow-Ups' $PlanPath

$SummaryLine = ($SummarySection -split "`r?`n" | Where-Object { $_.Trim() } | Select-Object -First 1)
if (-not $SummaryLine) { $SummaryLine = 'Refer to plan summary.' }

$SiteHighlights      = Summarize-Bullets $SiteSection
$PlantingHighlights  = Summarize-Bullets $PlantingSection
$SafetyHighlights    = Summarize-Bullets $SafetySection
$OpenHighlights      = Summarize-Bullets $OpenSection

if ([string]::IsNullOrWhiteSpace($PlantingHighlights)) { $PlantingHighlights = 'Review planting-schema.md for full details' }
if ([string]::IsNullOrWhiteSpace($SiteHighlights)) { $SiteHighlights = 'Consult plan.md for site specifics' }
if ([string]::IsNullOrWhiteSpace($SafetyHighlights)) { $SafetyHighlights = 'Review plan.md risk section' }
if ([string]::IsNullOrWhiteSpace($OpenHighlights)) { $OpenHighlights = 'No open questions recorded' }

if (Test-Path $ToolsPath) {
    $toolLines = @()
    foreach ($line in Get-Content $ToolsPath) {
        if ($line -notmatch '^\|' -or $line -match 'Tool / Resource' -or $line -match '^\|\s*-') { continue }
        $cells = ($line.Trim('|') -split '\|') | ForEach-Object { $_.Trim() }
        if ($cells.Count -ge 3) {
            $toolLines += "{0} ({1}, {2})" -f $cells[0], $cells[1], $cells[2]
            if ($toolLines.Count -ge 3) { break }
        }
    }
    $ToolSummary = if ($toolLines) { $toolLines -join ' / ' } else { 'Review tools.md for availability' }
} else {
    $ToolSummary = 'Tool inventory pending'
}

if (Test-Path $PlantingPath) {
    $plantText = Get-Content $PlantingPath -Raw
    $zoneMatches = [regex]::Matches($plantText, '- \*\*(.+?)\*\*')
    $zones = for ($i=0; $i -lt [Math]::Min(3, $zoneMatches.Count); $i++) { $zoneMatches[$i].Groups[1].Value.Trim() }
    $ZoneSummary = if ($zones) { $zones -join ', ' } else { 'See planting-schema.md' }
} else {
    $ZoneSummary = 'See planting-schema.md'
}

if (Test-Path $SeasonalPath) {
    $months = @()
    foreach ($line in Get-Content $SeasonalPath) {
        if ($line -notmatch '^\|' -or $line -match 'Month/Window' -or $line -match '^\|\s*-') { continue }
        $month = ($line.Trim('|') -split '\|')[0].Trim()
        if ($month) { $months += $month }
        if ($months.Count -ge 2) { break }
    }
    switch ($months.Count) {
        0 { $SeasonWindow = 'See seasonal-calendar.md' }
        1 { $SeasonWindow = $months[0] }
        default { $SeasonWindow = "{0} – {1}" -f $months[0], $months[-1] }
    }
} else {
    $SeasonWindow = 'See seasonal-calendar.md'
}

function Get-ManualBlock {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return '' }
    $buffer = New-Object System.Collections.Generic.List[string]
    $inside = $false
    foreach ($line in Get-Content $Path) {
        if ($line -match '<!-- MANUAL ADDITIONS START -->') { $inside = $true; continue }
        if ($line -match '<!-- MANUAL ADDITIONS END -->') { $inside = $false; continue }
        if ($inside) { $buffer.Add($line) }
    }
    return ($buffer -join "`n")
}

function Write-AgentFile {
    param([string]$Path)
    $dir = Split-Path $Path -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
    if (-not (Test-Path $Path) -and (Test-Path $TemplateFile)) { Copy-Item $TemplateFile $Path }
    $manual = Get-ManualBlock $Path
    $content = @"
# $GardenTitle Stewardship Brief
Auto-generated from current garden plans. Last updated: $DateStamp

## Garden Snapshot
- Highlights: $SummaryLine
- Zones in focus: $ZoneSummary
- Season window: $SeasonWindow

## Planting & Care Priorities
- $PlantingHighlights
- $SiteHighlights

## Tool Inventory Notes
- $ToolSummary

## Safety & Stewardship Guidelines
- $SafetyHighlights

## Recent Changes
- $OpenHighlights

<!-- MANUAL ADDITIONS START -->
$manual
<!-- MANUAL ADDITIONS END -->
"@
    Set-Content -Path $Path -Value $content
}

function Update-AllAgents {
    $found = $false
    foreach ($entry in @(
        @{Path=$ClaudeFile; Label='Claude'},
        @{Path=$GeminiFile; Label='Gemini'},
        @{Path=$CopilotFile; Label='Copilot'},
        @{Path=$CursorFile; Label='Cursor'},
        @{Path=$QwenFile; Label='Qwen'},
        @{Path=$AgentsFile; Label='Agent summary'},
        @{Path=$WindsurfFile; Label='Windsurf'},
        @{Path=$KilocodeFile; Label='Kilo Code'},
        @{Path=$AuggieFile; Label='Auggie'},
        @{Path=$RooFile; Label='Roo'},
        @{Path=$CodeBuddyFile; Label='CodeBuddy'},
        @{Path=$QFile; Label='Amazon Q'}
    )) {
        if (Test-Path $entry.Path) {
            Write-AgentFile $entry.Path
            Write-Host "Updated $($entry.Label) context at $($entry.Path)"
            $found = $true
        }
    }
    if (-not $found) {
        Write-AgentFile $ClaudeFile
        Write-Host "Created default Claude context at $ClaudeFile"
    }
}

function Update-SpecificAgent {
    param([string]$Type)
    switch ($Type) {
        'claude'        { Write-AgentFile $ClaudeFile }
        'gemini'        { Write-AgentFile $GeminiFile }
        'copilot'       { Write-AgentFile $CopilotFile }
        'cursor-agent'  { Write-AgentFile $CursorFile }
        'qwen'          { Write-AgentFile $QwenFile }
        'opencode'      { Write-AgentFile $AgentsFile }
        'codex'         { Write-AgentFile $AgentsFile }
        'windsurf'      { Write-AgentFile $WindsurfFile }
        'kilocode'      { Write-AgentFile $KilocodeFile }
        'auggie'        { Write-AgentFile $AuggieFile }
        'roo'           { Write-AgentFile $RooFile }
        'codebuddy'     { Write-AgentFile $CodeBuddyFile }
        'q'             { Write-AgentFile $QFile }
        default         { throw "Unknown agent type '$Type'" }
    }
    Write-Host "Updated $Type context"
}

if ([string]::IsNullOrWhiteSpace($AgentType)) {
    Update-AllAgents
} else {
    Update-SpecificAgent $AgentType
}

