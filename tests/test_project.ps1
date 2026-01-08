#!/usr/bin/env pwsh
# Enable strict mode
Set-StrictMode -Version Latest

$PYTHON_VERSION = $env:PYTHON_VERSION -or "3.13"
$PYTHON_VERSIONS = $env:PYTHON_VERSIONS -or "3.12 3.13"
. tests/helpers.ps1
$output = "tests/tmp"

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

if (-not $env:SKIP_SETUP) {
    Write-Host ">>> Setting up Python environment"
    Write-Host "Installing uv dependencies..."
    uv sync --group dev --group docs
    Write-Host ""
}

Write-Host ">>> Testing Python environment"
$pycode = 'import sys; print(sys.version.split(" ", 1)[0].rsplit(".", 1)[0])'
uv run python3 -c "print('Python version: ', end=''); $pycode"

Write-Host ""
Write-Host "///////////////////////////////////////////"
Write-Host "          RUNNING CODE QUALITY CHECKS"
Write-Host "///////////////////////////////////////////"
Write-Host ""

Write-Host ">>> Running ruff format (should have no changes)"
uv run ruff format --check .
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Code is not properly formatted" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Code formatting check passed" -ForegroundColor Green

Write-Host ""
Write-Host ">>> Running ruff linting (should have no issues)"
uv run ruff check .
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Linting issues found" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Linting check passed" -ForegroundColor Green

Write-Host ""
Write-Host ">>> Running type checks with mypy"
uv run mypy src/
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Type checking failed" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Type checking passed" -ForegroundColor Green

Write-Host ""
Write-Host ">>> Building documentation with mkdocs"
uv run mkdocs build --strict
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Documentation build failed" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Documentation build passed" -ForegroundColor Green

Write-Host ""
Write-Host "///////////////////////////////////////////"
Write-Host "             RUNNING TESTS"
Write-Host "///////////////////////////////////////////"
Write-Host ""

Write-Host ">>> Running pytest"
uv run pytest -v
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Tests failed" -ForegroundColor Red
    exit 1
}
Write-Host "✓ All tests passed" -ForegroundColor Green

Write-Host ""
Write-Host "///////////////////////////////////////////"
Write-Host "          ALL CHECKS PASSED ✓"
Write-Host "///////////////////////////////////////////"
Write-Host ""
Write-Host "Summary:"
Write-Host "  ✓ Code formatting (ruff format)" -ForegroundColor Green
Write-Host "  ✓ Linting (ruff check)" -ForegroundColor Green
Write-Host "  ✓ Type checking (mypy)" -ForegroundColor Green
Write-Host "  ✓ Documentation build (mkdocs)" -ForegroundColor Green
Write-Host "  ✓ Tests (pytest)" -ForegroundColor Green
Write-Host ""

Write-Host ">>> Creating second commit (fix)"
New-Item -ItemType File -Name "empty" | Out-Null
git add empty
git commit -m "fix: Fix all bugs"

Write-Host ">>> Cleaning directory"
uv cache clean
