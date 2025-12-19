#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
PWA_DIR="$HOME/Applications/Chrome Apps"
OUT="$SCRIPT_DIR/pwa_list.md"
echo "# Chrome PWAs" > "$OUT"
[ -d "$PWA_DIR" ] && ls "$PWA_DIR" | grep ".app" >> "$OUT"
"$REPO_ROOT/core/git_push.sh"
