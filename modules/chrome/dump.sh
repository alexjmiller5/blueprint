#!/bin/bash

# Target Profile 1
PROFILE_DIR="$HOME/Library/Application Support/Google/Chrome/Profile 1"
PREFS_FILE="$PROFILE_DIR/Preferences"

if [ ! -f "$PREFS_FILE" ]; then
    echo "❌ Error: File not found at $PREFS_FILE"
    exit 1
fi

echo "🔍 Scanning '$PREFS_FILE' for key settings..."
echo "---------------------------------------------------"

# Simple search: Find any path ending in these key names and print the value.
# We look for: home_button, show_on_all_tabs (bookmarks), pinned_actions, pinned_extensions

jq -r '
  paths 
  | select(.[-1] | tostring | test("home_button|show_on_all_tabs|pinned_actions|pinned_extensions")) as $path
  | "\($path | join(".")) = \(getpath($path))"
' "$PREFS_FILE"