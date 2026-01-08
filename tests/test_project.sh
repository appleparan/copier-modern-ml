#!/usr/bin/env bash
set -eu

PYTHON_VERSION="${PYTHON_VERSION-3.14}"
PYTHON_VERSIONS="${PYTHON_VERSIONS-3.12 3.13 3.14}"
. tests/helpers.sh
output=tests/tmp

# Function to check if a file exists
check_file() {
    local FILE="$1"

    if [ -f "$FILE" ]; then
        echo "File '$FILE' exists."
        return 0  # Return 0 if the file exists
    else
        echo "File '$FILE' does not exist."
        return 1  # Return 1 if the file does not exist
    fi
}

# Function to check if a directory exists
check_directory() {
    local DIR="$1"

    if [ -d "$DIR" ]; then
        echo "Directory '$DIR' exists."
        return 0  # Return 0 if the directory exists
    else
        echo "Directory '$DIR' does not exist."
        return 1  # Return 1 if the directory does not exist
    fi
}

rm -rf "${output}"

echo
echo "///////////////////////////////////////////"
echo "             GENERATING PROJECT"
echo "///////////////////////////////////////////"
echo
generate "${PWD}" "${output}"
cd "${output}"
cat .copier-answers.yml
git init .

echo
echo ">>> Check files with default values"
check_directory "configs"
check_directory "data"
check_directory "data/raw"
check_directory "data/processed"
check_directory "data/interim"
check_directory "data/external"
check_directory "docs"
check_directory "examples"
check_directory "models"
check_directory "notebooks"
check_directory "reports"
check_directory "src"
check_file ".pre-commit-config.yaml"
check_file "mkdocs.yml"
check_file "README.md"
check_file "pyproject.toml"

echo
echo "///////////////////////////////////////////"
echo "             TESTING PROJECT"
echo "///////////////////////////////////////////"
echo
echo ">>> Creating initial commit (feat)"
python3 << EOF
import re
with open(".copier-answers.yml") as file:
    answers = file.read()
with open(".copier-answers.yml", "w") as file:
    file.write(re.sub(r"(_commit: [a-z0-9.]+)(-.*|$)", r"\1", answers))
EOF
cat .copier-answers.yml
git add -A .
git commit -am "feat: Initial commit"
git tag v0.1.0
echo

if [ -z "${SKIP_SETUP:-}" ]; then
    echo ">>> Setting up Python environment"
    echo "Installing uv dependencies..."
    uv python pin $PYTHON_VERSION
    uv sync --group dev --group docs --extra cpu
    echo
fi

echo
echo ">>> Testing Python environment"
pycode="import sys; print(sys.version.split(' ', 1)[0].rsplit('.', 1)[0])"
uv run python3 -c "print('Python version: ', end=''); ${pycode}"

echo
echo "///////////////////////////////////////////"
echo "          RUNNING CODE QUALITY CHECKS"
echo "///////////////////////////////////////////"
echo
echo ">>> Running ruff format (should have no changes)"
if ! uv run ruff format --check .; then
    echo "ERROR: Code is not properly formatted"
    exit 1
fi
echo "✓ Code formatting check passed"

echo
echo ">>> Running ruff linting (should have no issues)"
if ! uv run ruff check .; then
    echo "ERROR: Linting issues found"
    exit 1
fi
echo "✓ Linting check passed"

echo
echo ">>> Running type checks with ty"
if ! uv run ty check; then
    echo "ERROR: Type checking failed"
    exit 1
fi
echo "✓ Type checking passed"

echo
echo ">>> Building documentation with mkdocs"
if ! uv run mkdocs build --strict; then
    echo "ERROR: Documentation build failed"
    exit 1
fi
echo "✓ Documentation build passed"

echo
echo "///////////////////////////////////////////"
echo "             RUNNING TESTS"
echo "///////////////////////////////////////////"
echo
echo ">>> Running pytest"
if ! uv run pytest -v; then
    echo "ERROR: Tests failed"
    exit 1
fi
echo "✓ All tests passed"

echo
echo "///////////////////////////////////////////"
echo "          ALL CHECKS PASSED ✓"
echo "///////////////////////////////////////////"
echo
echo "Summary:"
echo "  ✓ Code formatting (ruff format)"
echo "  ✓ Linting (ruff check)"
echo "  ✓ Type checking (ty)"
echo "  ✓ Documentation build (mkdocs)"
echo "  ✓ Tests (pytest)"
echo

echo ">>> Creating second commit (fix)"
touch empty
git add empty
git commit -m "fix: Fix all bugs"
echo
echo ">>> Cleaning directory"
uv cache clean
