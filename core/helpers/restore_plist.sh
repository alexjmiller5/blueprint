#!/bin/bash
APP_NAME="$1"
TARGET_DIR="$2"

if [ "$APP_NAME" == "Finder" ]; then BUNDLE_ID="com.apple.finder";
elif [ "$APP_NAME" == "Dock" ]; then BUNDLE_ID="com.apple.dock";
else
    BUNDLE_ID=$(osascript -e "id of app \"$APP_NAME\"" 2>/dev/null)
fi

FILENAME="${BUNDLE_ID}.plist"
CONFIG_FILE="$TARGET_DIR/$FILENAME"

if [ -f "$CONFIG_FILE" ]; then
    echo "Restoring $APP_NAME ($FILENAME)..."
    killall "$APP_NAME" 2>/dev/null
    
    defaults import "$BUNDLE_ID" "$CONFIG_FILE"
    
    killall cfprefsd
    if [ "$APP_NAME" != "Finder" ] && [ "$APP_NAME" != "Dock" ]; then
        open -a "$APP_NAME"
    elif [ "$APP_NAME" == "Dock" ]; then
        killall Dock
    fi
else
    echo "Config file not found: $CONFIG_FILE"
fi
