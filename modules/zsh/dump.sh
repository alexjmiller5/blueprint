#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"

cp "$HOME/.zshrc" "$SCRIPT_DIR/.zshrc"
cp "$HOME/.aliases" "$SCRIPT_DIR/.aliases"
"$REPO_ROOT/core/git_push.sh"
