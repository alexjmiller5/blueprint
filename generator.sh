#!/bin/bash
# refactor_plists.sh
# Refactors plist-based modules to use shared helper scripts.

PROJECT_ROOT="$(pwd)"
echo "🛠️ Refactoring Plist Modules at: $PROJECT_ROOT"

# 1. Create Helpers Directory
mkdir -p "$PROJECT_ROOT/core/helpers"

# --- 2. CREATE SHARED HELPERS ---

# Helper: DUMP PLIST
# Usage: ./dump_plist.sh "App Name" "filename.plist"
cat << 'EOF' > "$PROJECT_ROOT/core/helpers/dump_plist.sh"
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
EOF
chmod +x "$PROJECT_ROOT/core/helpers/dump_plist.sh"

# Helper: RESTORE PLIST
# Usage: ./restore_plist.sh "App Name" "filename.plist"
cat << 'EOF' > "$PROJECT_ROOT/core/helpers/restore_plist.sh"
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
EOF
chmod +x "$PROJECT_ROOT/core/helpers/restore_plist.sh"

# --- 3. REWRITE MODULES ---

# List of modules to refactor
# Format: "ModuleFolder|AppName|PlistFileName"
PLIST_MODULES=(
    "alttab|AltTab|com.blackhole.alttab.plist"
    "rectangle|Rectangle|com.knollsoft.Rectangle.plist"
    "betterdisplay|BetterDisplay|pro.betterdisplay.BetterDisplay.plist"
    "keyclu|KeyClu|com.sergey-software.keyclu.plist"
    "monitorcontrol|MonitorControl|me.guillaumeb.MonitorControl.plist"
    "finder|Finder|com.apple.finder.plist"
    "dock|Dock|com.apple.dock.plist"
)

for ENTRY in "${PLIST_MODULES[@]}"; do
    MODULE="${ENTRY%%|*}"
    REMAINDER="${ENTRY#*|}"
    APP_NAME="${REMAINDER%%|*}"
    FILENAME="${REMAINDER##*|}"
    
    echo "  -> Updating $MODULE..."
    
    # Write dump.sh
    cat << EOF > "$PROJECT_ROOT/modules/$MODULE/dump.sh"
#!/bin/bash
# Use shared helper
SCRIPT_DIR="\$(cd "\$(dirname "\$0")" && pwd)"
REPO_ROOT="\$(cd "\$SCRIPT_DIR/../../" && pwd)"
"\$REPO_ROOT/core/helpers/dump_plist.sh" "$APP_NAME" "$FILENAME"
EOF
    chmod +x "$PROJECT_ROOT/modules/$MODULE/dump.sh"

    # Write restore.sh
    cat << EOF > "$PROJECT_ROOT/modules/$MODULE/restore.sh"
#!/bin/bash
# Use shared helper
SCRIPT_DIR="\$(cd "\$(dirname "\$0")" && pwd)"
REPO_ROOT="\$(cd "\$SCRIPT_DIR/../../" && pwd)"
"\$REPO_ROOT/core/helpers/restore_plist.sh" "$APP_NAME" "$FILENAME"
EOF
    chmod +x "$PROJECT_ROOT/modules/$MODULE/restore.sh"
    
done

echo "✅ Refactor Complete."