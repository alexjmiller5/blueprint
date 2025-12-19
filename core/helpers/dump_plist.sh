#!/bin/bash
APP_NAME="$1"
FILENAME="$2"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# Calculate Repo Root (This script lives in core/helpers, so up 2 levels)
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
MODULE_DIR="$(pwd)" # The caller script's directory

# 1. Get Bundle ID dynamically
if [ "$APP_NAME" == "Finder" ]; then BUNDLE_ID="com.apple.finder";
elif [ "$APP_NAME" == "Dock" ]; then BUNDLE_ID="com.apple.dock";
else
    BUNDLE_ID=$(osascript -e "id of app \"$APP_NAME\"" 2>/dev/null)
fi

if [ -z "$BUNDLE_ID" ]; then
    echo "Error: Could not find Bundle ID for $APP_NAME"
    exit 1
fi

echo "  Drafting settings for $APP_NAME ($BUNDLE_ID)..."

# 2. Export settings using 'defaults export' (Location Agnostic)
# We export to a temporary binary file first, then convert
TEMP_FILE="/tmp/${FILENAME}.tmp"
defaults export "$BUNDLE_ID" "$TEMP_FILE"

# 3. Convert to XML1 and save to Module Directory
plutil -convert xml1 "$TEMP_FILE" -o "$MODULE_DIR/$FILENAME"
rm "$TEMP_FILE"

# 4. Push
"$REPO_ROOT/core/git_push.sh"
