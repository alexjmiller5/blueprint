#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/backup"

mkdir -p "$BACKUP_DIR"
cp "$HOME/.zshrc" "$BACKUP_DIR/.zshrc"
cp "$HOME/.aliases" "$BACKUP_DIR/.aliases"
cp "$HOME/.functions" "$BACKUP_DIR/.functions"
cp "$HOME/.zsh_prompt" "$BACKUP_DIR/.zsh_prompt"
"$REPO_ROOT/core/git_push.sh"
