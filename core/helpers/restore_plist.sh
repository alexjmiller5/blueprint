#!/bin/bash
APP_NAME="$1"
FILENAME="$2"
MODULE_DIR="$(pwd)"

if [ "$APP_NAME" == "Finder" ]; then BUNDLE_ID="com.apple.finder";
elif [ "$APP_NAME" == "Dock" ]; then BUNDLE_ID="com.apple.dock";
else
    BUNDLE_ID=$(osascript -e "id of app \"$APP_NAME\"" 2>/dev/null)
fi

if [ -z "$BUNDLE_ID" ]; then
    echo "Error: Could not find Bundle ID for $APP_NAME"
    exit 1
fi

CONFIG_FILE="$MODULE_DIR/$FILENAME"

if [ -f "$CONFIG_FILE" ]; then
    echo "Restoring $APP_NAME..."
    
    # 1. Kill App
    killall "$APP_NAME" 2>/dev/null
    
    # 2. Import settings
    defaults import "$BUNDLE_ID" "$CONFIG_FILE"
    
    # 3. Refresh System Preferences
    killall cfprefsd
    
    # 4. Relaunch (Skip for Finder/Dock as they auto-restart or shouldn't be opened like normal apps)
    if [ "$APP_NAME" != "Finder" ] && [ "$APP_NAME" != "Dock" ]; then
        open -a "$APP_NAME"
    elif [ "$APP_NAME" == "Dock" ]; then
        killall Dock
    fi
else
    echo "Config file not found: $CONFIG_FILE"
fi
