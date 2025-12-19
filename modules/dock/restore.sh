#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
"$REPO_ROOT/core/helpers/restore_plist.sh" "Dock" "com.apple.dock.plist" "$SCRIPT_DIR"
