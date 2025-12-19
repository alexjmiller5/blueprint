#!/bin/bash
REPO_DIR="$HOME/blueprint/modules/vscode"
VSCODE_USER="$HOME/Library/Application Support/Code/User"

mkdir -p "$VSCODE_USER"

# 1. Configs
cp "$REPO_DIR/settings.json" "$VSCODE_USER/"
cp "$REPO_DIR/keybindings.json" "$VSCODE_USER/"
cp "$REPO_DIR/tasks.json" "$VSCODE_USER/"
[ -f "$REPO_DIR/mcp.json" ] && cp "$REPO_DIR/mcp.json" "$VSCODE_USER/"

# 2. Snippets
cp -R "$REPO_DIR/snippets" "$VSCODE_USER/"

# 3. Extensions
if command -v code &> /dev/null; then
    cat "$REPO_DIR/extensions.txt" | xargs -n 1 code --install-extension --force
fi

echo "Restored VSCode settings and extensions."