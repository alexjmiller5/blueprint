#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
cp "$HOME/.config/karabiner/karabiner.json" "$SCRIPT_DIR/karabiner.json"
"$REPO_ROOT/core/git_push.sh"
