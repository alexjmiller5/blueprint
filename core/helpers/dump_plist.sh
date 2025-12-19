#!/bin/bash
APP_NAME="$1"
FILENAME="$2"
TARGET_DIR="$3"  # <--- New Argument

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"

# 1. Get Bundle ID
if [ "$APP_NAME" == "Finder" ]; then BUNDLE_ID="com.apple.finder";
elif [ "$APP_NAME" == "Dock" ]; then BUNDLE_ID="com.apple.dock";
else
    BUNDLE_ID=$(osascript -e "id of app \"$APP_NAME\"" 2>/dev/null)
fi

if [ -z "$BUNDLE_ID" ]; then
    echo "Error: Could not find Bundle ID for $APP_NAME"
    exit 1
fi

# 2. Export to Temp
TEMP_FILE="/tmp/${FILENAME}.tmp"
defaults export "$BUNDLE_ID" "$TEMP_FILE"

# 3. Convert & Save to Specific Module Directory
# We use the explicitly passed TARGET_DIR
plutil -convert xml1 "$TEMP_FILE" -o "$TARGET_DIR/$FILENAME"
rm "$TEMP_FILE"

# 4. Push
"$REPO_ROOT/core/git_push.sh"
