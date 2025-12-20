#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/backup"
mkdir -p "$BACKUP_DIR"
cp "$HOME/.config/karabiner/karabiner.json" "$BACKUP_DIR/karabiner.json"
"$REPO_ROOT/core/git_push.sh"
