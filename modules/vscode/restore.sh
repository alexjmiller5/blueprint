#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
USER_DIR="$HOME/Library/Application Support/Code/User"
mkdir -p "$USER_DIR"
cp "$SCRIPT_DIR"/{settings.json,keybindings.json,tasks.json} "$USER_DIR/"
[ -f "$SCRIPT_DIR/mcp.json" ] && cp "$SCRIPT_DIR/mcp.json" "$USER_DIR/"
cp -R "$SCRIPT_DIR/snippets" "$USER_DIR/"
command -v code >/dev/null && cat "$SCRIPT_DIR/extensions.txt" | xargs -n 1 code --install-extension --force
