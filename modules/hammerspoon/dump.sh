#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
cp "$HOME/.hammerspoon/init.lua" "$SCRIPT_DIR/init.lua"
"$REPO_ROOT/core/git_push.sh"
