#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_DIR="$HOME/Library/Application Support/com.raycast.macos"
killall Raycast 2>/dev/null
rsync -av "$SCRIPT_DIR/data/" "$APP_DIR/"
open -a Raycast
