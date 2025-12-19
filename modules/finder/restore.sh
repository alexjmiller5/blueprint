#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="$SCRIPT_DIR/com.apple.finder.plist"
DST="$HOME/Library/Preferences/com.apple.finder.plist"
cp "$SRC" "$DST"
plutil -convert binary1 "$DST"
killall cfprefsd
