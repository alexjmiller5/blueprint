#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/backup"
mkdir -p "$BACKUP_DIR"
OUT="$BACKUP_DIR/apps_list.md"
BREW=$(brew list --cask 2>/dev/null)
echo "# App Audit" > "$OUT"
find /Applications -name "*.app" -maxdepth 1 -print0 | xargs -0 basename -s .app | while read app; do
    if echo "$BREW" | grep -iq "$(echo "$app" | sed 's/ /-/g')"; then
        echo "- [Brew] $app" >> "$OUT"
    else
        echo "- [Manual] $app" >> "$OUT"
    fi
done
"$REPO_ROOT/core/git_push.sh"
