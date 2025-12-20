#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
"$REPO_ROOT/core/helpers/dump_plist.sh" "Finder" "$SCRIPT_DIR"

cp -r "$HOME/Library/Application Support/com.apple.sharedfilelist" "$SCRIPT_DIR/data"