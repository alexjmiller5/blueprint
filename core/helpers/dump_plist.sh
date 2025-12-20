#!/bin/bash
APP_NAME="$1"
TARGET_DIR="$2"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"

# 1. Get Bundle ID
BUNDLE_ID=$(osascript -e "id of app \"$APP_NAME\"" 2>/dev/null)

if [ -z "$BUNDLE_ID" ]; then
    echo "Error: Could not find Bundle ID for $APP_NAME"
    exit 1
fi

FILENAME="${BUNDLE_ID}.plist"
echo "  Exporting $APP_NAME -> $FILENAME"

# 2. Export to Temp
TEMP_FILE="/tmp/${FILENAME}.tmp"
defaults export "$BUNDLE_ID" "$TEMP_FILE"

# 3. Convert & Save to Target Directory
BACKUP_DIR="$TARGET_DIR/backup"
mkdir -p "$BACKUP_DIR"
plutil -convert xml1 "$TEMP_FILE" -o "$BACKUP_DIR/$FILENAME"
rm "$TEMP_FILE"

# 4. Push
"$REPO_ROOT/core/git_push.sh"
