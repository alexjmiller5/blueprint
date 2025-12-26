#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/backup"

# 1. Sync Config Folder
mkdir -p "$BACKUP_DIR/.hammerspoon/profile/"
rsync -av --delete --exclude '.git' --exclude '.DS_Store' "$HOME/.hammerspoon/profile/" "$BACKUP_DIR/.hammerspoon/profile/"