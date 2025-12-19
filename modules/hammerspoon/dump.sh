#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"

# 1. Sync Config Folder
rsync -av --delete --exclude '.git' --exclude '.DS_Store' "$HOME/.hammerspoon/" "$SCRIPT_DIR/.hammerspoon/"

# 2. Dump Plist (Helper handles naming)
"$REPO_ROOT/core/helpers/dump_plist.sh" "Hammerspoon" "$SCRIPT_DIR"
