#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
USER_DIR="$HOME/Library/Application Support/Code/User"

cp "$USER_DIR"/{settings.json,keybindings.json,tasks.json} "$SCRIPT_DIR/"
[ -f "$USER_DIR/mcp.json" ] && cp "$USER_DIR/mcp.json" "$SCRIPT_DIR/"
rm -rf "$SCRIPT_DIR/snippets" && cp -R "$USER_DIR/snippets" "$SCRIPT_DIR/"
command -v code >/dev/null && code --list-extensions > "$SCRIPT_DIR/extensions.txt"
"$REPO_ROOT/core/git_push.sh"
