#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="$SCRIPT_DIR/me.guillaumeb.MonitorControl.plist"
DST="$HOME/Library/Preferences/me.guillaumeb.MonitorControl.plist"
cp "$SRC" "$DST"
plutil -convert binary1 "$DST"
killall cfprefsd
