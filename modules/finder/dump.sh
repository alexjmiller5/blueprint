#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/backup"
mkdir -p "$BACKUP_DIR"

"$REPO_ROOT/core/helpers/dump_plist.sh" "Finder" "$SCRIPT_DIR"
mkdir -p "$BACKUP_DIR/com.apple.sharedfilelist"
cp -r "$HOME/Library/Application Support/com.apple.sharedfilelist" "$BACKUP_DIR/"

"$REPO_ROOT/core/git_push.sh"