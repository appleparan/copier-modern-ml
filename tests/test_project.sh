#!/usr/bin/env bash
set -eu

PYTHON_VERSION="${PYTHON_VERSION-3.14}"
PYTHON_VERSIONS="${PYTHON_VERSIONS-3.12 3.13 3.14}"
. tests/helpers.sh
output=tests/tmp
repo_root="${PWD}"

# Generate a template variant with extra `-d` answers, commit it, guard
# against unrendered Jinja, and (unless SKIP_SETUP is set) run the same
# quality gate as the default run against it. Runs in a subshell so the
# working directory is restored to the repo root once it returns.
generate_variant() {
    local name="$1"
    shift
    local variant_dir="tests/tmp-variants/${name}"

    (
        cd "${repo_root}"
        rm -rf "${variant_dir}"

        echo
        echo "///////////////////////////////////////////"
        echo "     GENERATING VARIANT: ${name}"
        echo "///////////////////////////////////////////"
        echo
        generate "${repo_root}" "${variant_dir}" "$@"
        cd "${variant_dir}"

        git init -q .
        git add -A
        git commit -qm "feat: initial"

        echo ">>> Checking for unrendered Jinja (variant: ${name})"
        if grep -rn --exclude-dir=.git --exclude-dir=.github --exclude=cliff.toml --exclude=.gitlab-ci.yml -e '{{ ' -e '{% ' .; then
            echo "ERROR: unrendered Jinja found in variant '${name}'"
            exit 1
        fi
        echo "✓ No unrendered Jinja (variant: ${name})"

        if [ -z "${SKIP_SETUP:-}" ]; then
            echo ">>> Setting up Python environment (variant: ${name})"
            uv python pin "${PYTHON_VERSION}"
            uv sync --group dev
            echo
            echo ">>> Running code quality checks (variant: ${name})"
            uv run ruff format --check .
            uv run ruff check .
            uv run ty check
            uv run pytest -q
            echo ">>> Building package (variant: ${name})"
            uv build
            if ! ls dist/*.whl >/dev/null 2>&1; then
                echo "ERROR: no wheel produced for variant '${name}'"
                exit 1
            fi
        fi

        echo "✓ Variant '${name}' passed"
    )
}

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
check_file "properdocs.yml"
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
echo ">>> Building documentation with properdocs"
if ! uv run properdocs build --strict; then
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
echo "          BUILDING PACKAGE"
echo "///////////////////////////////////////////"
echo
echo ">>> Building sdist and wheel with uv build"
if ! uv build; then
    echo "ERROR: uv build failed"
    exit 1
fi
echo "✓ Build passed"

echo ">>> Inspecting wheel contents"
python3 - << 'EOF'
import sys
import zipfile
from pathlib import Path

wheels = sorted(Path("dist").glob("*.whl"), key=lambda p: p.stat().st_mtime)
if not wheels:
    print("ERROR: no wheel found in dist/")
    sys.exit(1)
wheel = wheels[-1]
print(f"Inspecting {wheel}")

with zipfile.ZipFile(wheel) as zf:
    names = zf.namelist()

for name in names:
    print(f"  {name}")

required = {"modern_template/__init__.py", "modern_template/_version.py"}
missing = required - set(names)
if missing:
    print(f"ERROR: wheel is missing required entries: {sorted(missing)}")
    sys.exit(1)

leaked = [n for n in names if n.startswith("tests/") or n.startswith("data/")]
if leaked:
    print(f"ERROR: wheel contains entries that should not ship: {leaked}")
    sys.exit(1)

print("✓ Wheel contents look correct")
EOF

echo
echo "///////////////////////////////////////////"
echo "          ALL CHECKS PASSED ✓"
echo "///////////////////////////////////////////"
echo
echo "Summary:"
echo "  ✓ Code formatting (ruff format)"
echo "  ✓ Linting (ruff check)"
echo "  ✓ Type checking (ty)"
echo "  ✓ Documentation build (properdocs)"
echo "  ✓ Tests (pytest)"
echo "  ✓ Package build (uv build)"
echo

echo ">>> Creating second commit (fix)"
touch empty
git add empty
git commit -m "fix: Fix all bugs"
# echo
# echo ">>> Cleaning directory"
# uv cache clean || true

cd "${repo_root}"

echo
echo "///////////////////////////////////////////"
echo "          GENERATING VARIANTS"
echo "///////////////////////////////////////////"

generate_variant noexamples-gitlab -d create_examples=no -d use_torch=no -d ci=gitlab
generate_variant noexamples-virtual -d create_examples=no -d use_torch=no -d package=no -d create_directories=no

echo
echo "///////////////////////////////////////////"
echo "          ALL VARIANTS PASSED ✓"
echo "///////////////////////////////////////////"
echo
