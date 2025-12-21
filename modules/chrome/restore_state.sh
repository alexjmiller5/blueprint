#!/bin/bash
# modules/chrome/restore_state.sh

# Check for jq
command -v jq >/dev/null 2>&1 || { echo >&2 "I require jq but it's not installed. Please run brew install jq. Aborting."; exit 1; }

#!/bin/bash
# modules/chrome/restore_state.sh

# Check for jq
command -v jq >/dev/null 2>&1 || { echo >&2 "I require jq but it's not installed. Please run brew install jq. Aborting."; exit 1; }

CHROME_SUPPORT_DIR="$HOME/Library/Application Support/Google/Chrome"
BACKUP_FILE="$(dirname "$0")/pinned_extensions.json"

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

# 1. Safety Check
if pgrep "Google Chrome" > /dev/null; then
    echo "⚠️  Chrome is running!"
    echo "   You MUST close Chrome to modify preferences."
    echo "   Run: pkill 'Google Chrome' and try again."
    exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ No pinned_extensions.json found."
    exit 1
fi

echo "💉 Injecting Pinned Extensions into $PROFILE_DIR..."

# 2. Create a temporary file (jq cannot edit in place safely)
TMP_PREFS=$(mktemp)

# 3. Use jq to swap out the toolbar list with our backup list
# We pass the backup file as 'pins' and update the .extensions.toolbar key
jq --slurpfile pins "$BACKUP_FILE" \
   '.extensions.pinned_extensions = $pins[0]' \
   "$PREFS_FILE" > "$TMP_PREFS"

# 4. Overwrite the real preferences file
mv "$TMP_PREFS" "$PREFS_FILE"

echo "✅ Done. Open Chrome to see your pinned icons."
