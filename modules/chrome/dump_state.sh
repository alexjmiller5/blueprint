#!/bin/bash
# modules/chrome/dump_state.sh

#!/bin/bash
# modules/chrome/dump_state.sh

CHROME_SUPPORT_DIR="$HOME/Library/Application Support/Google/Chrome"
OUTPUT_FILE="$(dirname "$0")/pinned_extensions.json"

# Find profile
PROFILE_DIR=""
if [ -d "$CHROME_SUPPORT_DIR/Default" ]; then
    PROFILE_DIR="$CHROME_SUPPORT_DIR/Default"
else
    for dir in "$CHROME_SUPPORT_DIR/Profile "*/; do
        if [ -d "$dir" ]; then
            PROFILE_DIR=$(echo "$dir" | sed 's:/*$::') # remove trailing slash
            break
        fi
    done
fi

if [ -z "$PROFILE_DIR" ]; then
    echo "❌ No Chrome profile found."
    exit 1
fi

PREFS_FILE="$PROFILE_DIR/Preferences"

if [ ! -f "$PREFS_FILE" ]; then
    echo "❌ Chrome Preferences not found in $PROFILE_DIR."
    exit 1
fi

echo "🔍 Extracting Pinned Extensions from $PROFILE_DIR..."

# Extract the array of pinned extension IDs
# The path is usually .extensions.toolbar (an array of ID strings)
jq '.extensions.pinned_extensions' "$PREFS_FILE" > "$OUTPUT_FILE"

echo "✅ Saved pinned list to $(basename "$OUTPUT_FILE")"
cat "$OUTPUT_FILE"
