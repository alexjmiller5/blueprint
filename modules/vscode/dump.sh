#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
USER_DIR="$HOME/Library/Application Support/Code/User"
BACKUP_DIR="$SCRIPT_DIR/backup"

mkdir -p "$BACKUP_DIR"
cp "$USER_DIR"/{settings.json,keybindings.json,tasks.json} "$BACKUP_DIR/"
[ -f "$USER_DIR/mcp.json" ] && cp "$USER_DIR/mcp.json" "$BACKUP_DIR/"
rm -rf "$BACKUP_DIR/snippets" && cp -R "$USER_DIR/snippets" "$BACKUP_DIR/"
command -v code >/dev/null && code --list-extensions > "$BACKUP_DIR/extensions.txt"
"$REPO_ROOT/core/git_push.sh"
