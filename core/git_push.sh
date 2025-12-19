#!/bin/bash
# Find repo root relative to this script
CORE_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$CORE_DIR/.." && pwd)"

cd "$REPO_ROOT" || exit
git add .
if ! git diff-index --quiet HEAD --; then
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    # echo "[$TIMESTAMP] Changes detected. Pushing..." >> /tmp/blueprint_backup.log
    git commit -m "Auto-backup: $TIMESTAMP"
    git push origin main
fi
