#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="$SCRIPT_DIR/com.sergey-software.keyclu.plist"
DST="$HOME/Library/Preferences/com.sergey-software.keyclu.plist"
cp "$SRC" "$DST"
plutil -convert binary1 "$DST"
killall cfprefsd
