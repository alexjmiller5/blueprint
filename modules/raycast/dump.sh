#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
APP_DIR="$HOME/Library/Application Support/com.raycast.macos"

# We use an array for options to keep it clean and robust
RSYNC_OPTIONS=(
    -av
    --delete
    --exclude=".DS_Store"
    --exclude="*.log"
    # caches
    --exclude="Cache"
    --exclude="Image Cache"
    --exclude="Favicons"
    --exclude="com.raycast.api.cache"  # Matches directory name anywhere
    --exclude="*/com.raycast.api.cache" # Explicit wildcard match
    # heavy assets
    --exclude="RaycastWrapped"
    # analytics/telemetry
    --exclude="posthog*"
    --exclude="sentry-native"
    # re-downloadable runtimes
    --exclude="NodeJS"
    # temporary database files (don't need these)
    --exclude="*.sqlite-wal"
    --exclude="*.sqlite-shm"
    # Too big unforunately
    --exclude="raycast-enc.sqlite"
)

echo "  Backing up Raycast (Slim Mode)..."
rsync "${RSYNC_OPTIONS[@]}" "$APP_DIR/" "$SCRIPT_DIR/data/"

"$REPO_ROOT/core/git_push.sh"
