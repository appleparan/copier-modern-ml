#!/usr/bin/env bash
set -eu

PYTHON_VERSIONS="${PYTHON_VERSIONS-3.8 3.9 3.10 3.11 3.12 3.13}"
. tests/helpers.sh
output=tests/tmp
make() {
    ./scripts/make "$@"
}


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
echo ">>> Configuring VSCode"
make vscode
echo
echo ">>> Testing arbitrary commands"
pycode="import sys; print(sys.version.split(' ', 1)[0].rsplit('.', 1)[0])"
make run python -c "print('run: ', end=''); ${pycode}"
make multirun python -c "print('multirun: ', end=''); ${pycode}"
make allrun python -c "print('allrun: ', end=''); ${pycode}"
if [ -n "${PYTHON_VERSIONS}" ]; then
    version="$(python -c "${pycode}")"
    make "${version}" python -c "print('3.x: ', end=''); ${pycode}" | grep -F "${version}"
fi
echo ">>> Creating second commit (fix)"
touch empty
git add empty
git commit -m "fix: Fix all bugs"
echo
echo ">>> Updating changelog and releasing version"
make changelog release version=0.1.1
echo
echo ">>> Checking changelog's contents"
make run failprint -- grep 'v0\.1\.0' CHANGELOG.md
make run failprint -- grep 'v0\.1\.1' CHANGELOG.md
make run failprint -- grep 'Features' CHANGELOG.md
make run failprint -- grep 'Bug Fixes' CHANGELOG.md
echo
echo ">>> Cleaning directory"
make clean
