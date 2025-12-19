#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="$SCRIPT_DIR/com.apple.dock.plist"
DST="$HOME/Library/Preferences/com.apple.dock.plist"
cp "$SRC" "$DST"
plutil -convert binary1 "$DST"
killall cfprefsd
killall Dock
