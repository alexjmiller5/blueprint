#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
cd "$SCRIPT_DIR" || exit
brew bundle dump --force
"$REPO_ROOT/core/git_push.sh"
