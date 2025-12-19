#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="$SCRIPT_DIR/com.blackhole.alttab.plist"
DST="$HOME/Library/Preferences/com.blackhole.alttab.plist"
cp "$SRC" "$DST"
plutil -convert binary1 "$DST"
killall cfprefsd
