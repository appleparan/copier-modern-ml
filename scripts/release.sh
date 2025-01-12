#!/bin/bash
BUMPED_VERSION=$(uv run git-cliff --bumped-version)

echo "Release to $BUMPED_VERSION"
uv run git-cliff --strip header --tag $BUMPED_VERSION -o CHANGELOG.md
uv run git-cliff --latest --strip header --tag $BUMPED_VERSION --unreleased -o RELEASE.md

git add CHANGELOG.md RELEASE.md
git commit -am "docs: Add CHANGELOG.md and RELEASE.md to release $BUMPED_VERSION"
git push origin
git tag -a $BUMPED_VERSION -m "Release $BUMPED_VERSION"
git push origin --tags
