#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/backup"
mkdir -p "$BACKUP_DIR"
cp "$HOME/.gitconfig" "$BACKUP_DIR/.gitconfig"
"$REPO_ROOT/core/git_push.sh"
