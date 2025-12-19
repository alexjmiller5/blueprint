#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="$SCRIPT_DIR/com.knollsoft.Rectangle.plist"
DST="$HOME/Library/Preferences/com.knollsoft.Rectangle.plist"
cp "$SRC" "$DST"
plutil -convert binary1 "$DST"
killall cfprefsd
