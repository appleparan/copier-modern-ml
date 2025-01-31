#!/bin/sh

# Get the bumped version (includes "v" prefix)
BUMPED_VERSION=$(uv run git-cliff --bumped-version)
# Remove the "v" prefix (e.g., v1.2.3 → 1.2.3)
PLAIN_VERSION=${BUMPED_VERSION#v}

echo "Release to $BUMPED_VERSION (plain: $PLAIN_VERSION)"

uv run git-cliff --strip header --tag "$BUMPED_VERSION" -o CHANGELOG.md
uv run git-cliff --latest --strip header --tag "$BUMPED_VERSION" --unreleased -o RELEASE.md

# Find pyproject.toml (should be in the project root)
PYPROJECT_FILE="pyproject.toml"
if [ -f "$PYPROJECT_FILE" ]; then
    sed -i "s/^version = \".*\"/version = \"$PLAIN_VERSION\"/" "$PYPROJECT_FILE"
fi

# Locate package directory (src/{{ project_slug }})
PACKAGE_DIR=""
find src -maxdepth 1 -type d -not -name "__pycache__" | while read -r dir; do
    PACKAGE_DIR="$dir"
    break
done
INIT_FILE="$PACKAGE_DIR/__init__.py"

if [ -f "$INIT_FILE" ]; then
    sed -i "s/^__version__ = \".*\"/__version__ = \"$PLAIN_VERSION\"/" "$INIT_FILE"
fi

# Update test_version.py (if not using Jinja2 template)
TEST_VERSION_FILE="tests/test_version.py"
if [ -f "$TEST_VERSION_FILE" ]; then
    if ! grep -q "{{ version }}" "$TEST_VERSION_FILE"; then
        sed -i "s/^.*== \".*\"/    assert __version__ == \"$PLAIN_VERSION\"/" "$TEST_VERSION_FILE"
    fi
fi

git add CHANGELOG.md RELEASE.md
[ -f "$PYPROJECT_FILE" ] && git add "$PYPROJECT_FILE"
[ -f "$INIT_FILE" ] && git add "$INIT_FILE"
[ -f "$TEST_VERSION_FILE" ] && git add "$TEST_VERSION_FILE"

git commit -am "chore(release): bump version to $PLAIN_VERSION"
git push origin

# Create and push the tag (use BUMPED_VERSION with "v")
git tag -a "$BUMPED_VERSION" -m "Release $BUMPED_VERSION"
git push origin --tags

echo "Released version $BUMPED_VERSION successfully!"
