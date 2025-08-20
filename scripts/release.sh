#!/bin/sh

# Get current version
CURRENT_VERSION=$(uv version --short)
echo "Current version: v$CURRENT_VERSION"

# Get the bumped version from git-cliff (includes "v" prefix)
BUMPED_VERSION=$(uv run git-cliff --bumped-version)
# Remove the "v" prefix (e.g., v1.2.3 → 1.2.3)
PLAIN_VERSION=${BUMPED_VERSION#v}

echo "Target version: $BUMPED_VERSION (plain: $PLAIN_VERSION)"

# Determine bump type by comparing versions
# Parse version components (major.minor.patch)
CURRENT_MAJOR=$(echo "$CURRENT_VERSION" | cut -d. -f1)
CURRENT_MINOR=$(echo "$CURRENT_VERSION" | cut -d. -f2)
CURRENT_PATCH=$(echo "$CURRENT_VERSION" | cut -d. -f3)

TARGET_MAJOR=$(echo "$PLAIN_VERSION" | cut -d. -f1)
TARGET_MINOR=$(echo "$PLAIN_VERSION" | cut -d. -f2)
TARGET_PATCH=$(echo "$PLAIN_VERSION" | cut -d. -f3)

# Determine bump type
if [ "$TARGET_MAJOR" -gt "$CURRENT_MAJOR" ]; then
    BUMP_TYPE="major"
elif [ "$TARGET_MINOR" -gt "$CURRENT_MINOR" ]; then
    BUMP_TYPE="minor"
else
    BUMP_TYPE="patch"
fi

echo "Bumping version: $BUMP_TYPE ($CURRENT_VERSION -> $PLAIN_VERSION)"

# Use uv version to set the exact version determined by git-cliff
# This ensures consistency between git-cliff's semantic analysis and the actual version
uv version "$PLAIN_VERSION"

uv run git-cliff --strip header --tag "$BUMPED_VERSION" -o CHANGELOG.md
uv run git-cliff --latest --strip header --tag "$BUMPED_VERSION" --unreleased -o RELEASE.md

# Update uv.lock file for new version
uv lock

# Add files changed by uv version and git-cliff
git add pyproject.toml CHANGELOG.md RELEASE.md uv.lock

# Add __init__.py if it exists and was updated by uv version
if [ -d "src" ]; then
    find src -name "__init__.py" -exec git add {} \;
fi

# Add test_version.py if it exists and was updated
if [ -f "tests/test_version.py" ]; then
    git add "tests/test_version.py"
fi

git commit -m "chore(release): bump version to $PLAIN_VERSION"
git push origin

# Create and push the tag (use BUMPED_VERSION with "v")
git tag -a "$BUMPED_VERSION" -m "Release $BUMPED_VERSION"
git push origin --tags

echo "Released version $BUMPED_VERSION successfully!"
