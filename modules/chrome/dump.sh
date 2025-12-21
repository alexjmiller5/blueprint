#!/bin/bash
# modules/chrome/dump_state.sh

CHROME_SUPPORT_DIR="$HOME/Library/Application Support/Google/Chrome"
OUTPUT_FILE="$(dirname "$0")/chrome_full_state.json"

# --- 1. INTELLIGENT PROFILE FINDER ---
# Strategy: Find the profile with the MOST pinned extensions.
PROFILE_DIR=""
MAX_PINNED=0

# Check Default + Profiles 1-20
PROFILES=("$CHROME_SUPPORT_DIR/Default")
for i in {1..20}; do PROFILES+=("$CHROME_SUPPORT_DIR/Profile $i"); done

echo "🔍 Searching for main Chrome profile..."

for dir in "${PROFILES[@]}"; do
    if [ -f "$dir/Preferences" ]; then
        # Count how many pinned extensions are in this profile
        COUNT=$(jq '.extensions.pinned_extensions | length' "$dir/Preferences" 2>/dev/null)
        
        # If COUNT is null, treat as 0
        if [ "$COUNT" = "null" ]; then COUNT=0; fi

        if [ "$COUNT" -gt "$MAX_PINNED" ]; then
            MAX_PINNED=$COUNT
            PROFILE_DIR="$dir"
            echo "   👉 Candidate: $(basename "$dir") ($COUNT pinned items)"
        fi
    fi
done

if [ -z "$PROFILE_DIR" ]; then
    echo "❌ No profiles with pinned extensions found."
    exit 1
fi

echo "✅ Selected Profile: $(basename "$PROFILE_DIR")"
PREFS_FILE="$PROFILE_DIR/Preferences"

# --- 2. EXTRACTION ---
# We use the keys confirmed by your debug output.
# We DROP 'extension_states' because your Preferences file doesn't have it.

jq '{
  # The ordered list of pinned extension IDs
  pinned_order: (.extensions.pinned_extensions // []),

  # Native Chrome Buttons (Translate, Side Panel, etc.)
  native_actions: (.pinned_actions // []),

  # Toolbar Toggles (Home, Bookmarks)
  toolbar_settings: {
    show_home_button: (.browser.show_home_button // false),
    show_bookmarks_bar: (.bookmark_bar.show_on_all_tabs // false)
  }
}' "$PREFS_FILE" > "$OUTPUT_FILE"

echo "💾 Saved Chrome UI state to $(basename "$OUTPUT_FILE")"
echo "   - Pinned Items:   $(jq '.pinned_order | length' "$OUTPUT_FILE")"
echo "   - Native Actions: $(jq '.native_actions | length' "$OUTPUT_FILE")"