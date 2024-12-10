#!/bin/bash
echo "Release script"
echo "Next version: $(uv run git-cliff --bumped-version)"
uv run git-cliff --strip header -o CHANGELOG.md
uv run git-cliff --latest --strip header -o RELEASE.md
git add CHANGELOG.md RELEASE.md
git commit -am "docs: Add CHANGELOG.md and RELEASE.md to release $(uv run git-cliff --bumped-version)"
git tag -a $(uv run git-cliff --bumped-version) -m "Release $(uv run git-cliff --bumped-version)"
git push origin tag $(uv run git-cliff --bumped-version)
