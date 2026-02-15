#!/bin/bash
set -e

# Fix ownership of writable mount points at runtime
# (host directory UID may differ, so adjust at startup)
WRITABLE_DIRS=(
    /app/data
)

if [ "$(id -u)" = "0" ]; then
    # Running as root: fix permissions then drop to appuser via gosu
    for dir in "${WRITABLE_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            chown appuser:appuser "$dir" 2>/dev/null || true
        fi
    done
    exec gosu appuser "$@"
else
    # Already running as non-root (appuser): execute CMD directly
    exec "$@"
fi
