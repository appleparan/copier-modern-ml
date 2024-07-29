#!/usr/bin/env bash
cd tests/tmp || exit 1
rm -rf .git
git init .
git add -A
git commit -m "feat: Initial commit"
git tag 0.1.0
