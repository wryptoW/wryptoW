# Copy the second-brain template to a local folder and initialise a local git repo for backup.
# Usage (from the repo root, in PowerShell):
#   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\install.ps1
#   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\install.ps1 -Target D:\brain
# The script never overwrites an existing folder.
# Kept ASCII-only so Windows PowerShell 5.1 reads it correctly without a BOM.

param(
    [string]$Target = (Join-Path $env:USERPROFILE 'brain')
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$source = Join-Path $repoRoot 'brain-template'

if (-not (Test-Path $source)) {
    Write-Error "Template folder not found: $source"
    exit 1
}

if (Test-Path $Target) {
    $existing = Get-ChildItem -Force $Target | Select-Object -First 1
    if ($existing) {
        Write-Error "Target already exists and is not empty: $Target. Nothing was copied."
        exit 1
    }
    Remove-Item $Target
}

Copy-Item -Path $source -Destination $Target -Recurse
Write-Host "Template copied to $Target"

if (Get-Command git -ErrorAction SilentlyContinue) {
    Push-Location $Target
    try {
        git init -q
        git add -A
        git commit -q -m "Initial second-brain template"
        Write-Host "Local git repo initialised in $Target (no remote configured)."
    } finally {
        Pop-Location
    }
} else {
    Write-Host "git not found: skipped local backup repo. Install Git for Windows, then run 'git init' in $Target."
}

Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. In Claude Desktop, Code tab, open $Target as the working folder."
Write-Host "  2. Run /brain-interview to fill CLAUDE.md."
Write-Host "  3. Create the two local scheduled tasks (see README)."
