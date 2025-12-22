#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/backup"
mkdir -p "$BACKUP_DIR"
cd "$BACKUP_DIR" || exit
/opt/homebrew/bin/brew bundle dump --force
"$REPO_ROOT/core/git_push.sh"
