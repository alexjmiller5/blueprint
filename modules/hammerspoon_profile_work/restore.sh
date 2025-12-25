#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"

# 1. Restore Config Folder
if [ -d "$SCRIPT_DIR/config" ]; then
    mkdir -p "$HOME/.hammerspoon"
    rsync -av "$SCRIPT_DIR/config/" "$HOME/.hammerspoon/profile"
fi

# 2. Restore Plist
"$REPO_ROOT/core/helpers/restore_plist.sh" "Hammerspoon" "$SCRIPT_DIR"
