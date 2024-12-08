#!/usr/bin/env pwsh
# Enable strict mode
Set-StrictMode -Version Latest

$PYTHON_VERSION = $env:PYTHON_VERSION -or "3.12"
$PYTHON_VERSIONS = $env:PYTHON_VERSIONS -or "3.11 3.12"
. tests/helpers.ps1
$output = "tests/tmp"

# Function to execute the make script
function Make {
    param([string[]]$args)
    & ./scripts/make @args
}

# Function to check if a file exists
function Check-File {
    param([string]$File)
    if (Test-Path -Path $File -PathType Leaf) {
        Write-Host "File '$File' exists."
        return $true
    } else {
        Write-Host "File '$File' does not exist."
        return $false
    }
}

# Function to check if a directory exists
function Check-Directory {
    param([string]$Dir)
    if (Test-Path -Path $Dir -PathType Container) {
        Write-Host "Directory '$Dir' exists."
        return $true
    } else {
        Write-Host "Directory '$Dir' does not exist."
        return $false
    }
}

# Clean output directory
Remove-Item -Recurse -Force -Path $output -ErrorAction SilentlyContinue

Write-Host "///////////////////////////////////////////"
Write-Host "             GENERATING PROJECT"
Write-Host "///////////////////////////////////////////"
Write-Host ""

# Example generate command
& Generate -Path $PWD -Output $output

Set-Location -Path $output
Get-Content ".copier-answers.yml"
git init .

Write-Host ">>> Check files with default values"
Check-Directory "configs"
Check-Directory "data"
Check-Directory "data/raw"
Check-Directory "data/processed"
Check-Directory "data/interim"
Check-Directory "data/external"
Check-Directory "docs"
Check-Directory "examples"
Check-Directory "models"
Check-Directory "notebooks"
Check-Directory "reports"
Check-Directory "src"
Check-File ".pre-commit-config.yaml"
Check-File "mkdocs.yml"
Check-File "README.md"
Check-File "pyproject.toml"

Write-Host "///////////////////////////////////////////"
Write-Host "             TESTING PROJECT"
Write-Host "///////////////////////////////////////////"
Write-Host ""

Write-Host ">>> Creating initial commit (feat)"
(Get-Content ".copier-answers.yml") -replace '(_commit: [a-z0-9.]+)(-.*|$)', '$1' | Set-Content ".copier-answers.yml"
git add -A .
git commit -am "feat: Initial commit"
git tag v0.1.0

Write-Host ">>> Printing help"
Make help

if (-not $env:SKIP_SETUP) {
    Write-Host ">>> Setting up Python environments"
    Make setup
    Write-Host ">>> Printing help again"
    Make help
}

Write-Host ">>> Testing arbitrary commands"
$pycode = 'import sys; print(sys.version.split(" ", 1)[0].rsplit(".", 1)[0])'
Make run "python3 -c 'print(\"allrun: \", end=\"\"); $pycode'"

Write-Host ">>> Creating second commit (fix)"
New-Item -ItemType File -Name "empty" | Out-Null
git add empty
git commit -m "fix: Fix all bugs"

Write-Host ">>> Cleaning directory"
Make clean
