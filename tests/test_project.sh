#!/usr/bin/env bash
set -eu

PYTHON_VERSION="${PYTHON_VERSION-3.12}"
PYTHON_VERSIONS="${PYTHON_VERSIONS-3.9 3.10 3.11 3.12}"
. tests/helpers.sh
output=tests/tmp
make() {
    ./scripts/make "$@"
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
check_file "mkdocs.yml"
check_file "README.md"
check_file "pyproject.toml"

echo
echo "///////////////////////////////////////////"
echo "             TESTING PROJECT"
echo "///////////////////////////////////////////"
echo
echo ">>> Creating initial commit (feat)"
python <<EOF
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
echo ">>> Printing help"
make help
echo
if [ -z "${SKIP_SETUP:-}" ]; then
    echo ">>> Setting up Python environments"
    make setup
    echo
    echo ">>> Printing help again"
    make help
    echo
fi

echo
echo ">>> Testing arbitrary commands"
pycode="import sys; print(sys.version.split(' ', 1)[0].rsplit('.', 1)[0])"

make run python -c "print('allrun: ', end=''); ${pycode}"

echo ">>> Creating second commit (fix)"
touch empty
git add empty
git commit -m "fix: Fix all bugs"
echo
echo ">>> Cleaning directory"
make clean
