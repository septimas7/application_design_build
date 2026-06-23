<#
.SYNOPSIS
  Install the Design & Build Skills into Claude Code or OpenAI Codex.
.EXAMPLE
  ./install.ps1 -Platform claude -Scope personal
  ./install.ps1 -Platform codex  -Scope project -ProjectPath "C:\path\to\repo"
#>
param(
  [Parameter(Mandatory = $true)][ValidateSet('claude', 'codex')][string]$Platform,
  [Parameter(Mandatory = $true)][ValidateSet('personal', 'project')][string]$Scope,
  [string]$ProjectPath = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
$src = $PSScriptRoot
$dirName = if ($Platform -eq 'claude') { '.claude' } else { '.codex' }

$base = if ($Scope -eq 'personal') { $HOME } else { $ProjectPath }
$target = Join-Path $base (Join-Path $dirName 'skills')

Write-Host "Installing Design & Build Skills -> $target"
New-Item -ItemType Directory -Force -Path $target | Out-Null

# Copy each skill folder
Copy-Item -Path (Join-Path $src 'skills\*') -Destination $target -Recurse -Force

# Copy shared references as a sibling so skills can cite references/<file>
$refTarget = Join-Path $target 'references'
New-Item -ItemType Directory -Force -Path $refTarget | Out-Null
Copy-Item -Path (Join-Path $src 'references\*') -Destination $refTarget -Recurse -Force

$count = (Get-ChildItem -Path $target -Directory | Where-Object { $_.Name -ne 'references' }).Count
Write-Host "Installed $count skills + references."
Write-Host "Restart $Platform to load them."
