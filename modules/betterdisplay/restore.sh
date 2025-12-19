#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="$SCRIPT_DIR/pro.betterdisplay.BetterDisplay.plist"
DST="$HOME/Library/Preferences/pro.betterdisplay.BetterDisplay.plist"
cp "$SRC" "$DST"
plutil -convert binary1 "$DST"
killall cfprefsd
