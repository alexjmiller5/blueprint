#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/backup"
mkdir -p "$BACKUP_DIR"
osascript -e 'tell application "System Events" to get the name of every login item' | sed 's/, /\n/g' > "$BACKUP_DIR/items.txt"
"$REPO_ROOT/core/git_push.sh"
