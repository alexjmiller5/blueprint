#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
SRC="$HOME/Library/Preferences/pro.betterdisplay.BetterDisplay.plist"
DST="$SCRIPT_DIR/pro.betterdisplay.BetterDisplay.plist"
[ -f "$SRC" ] && plutil -convert xml1 "$SRC" -o "$DST"
"$REPO_ROOT/core/git_push.sh"
