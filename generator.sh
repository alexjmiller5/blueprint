#!/bin/bash
# refactor_plists_v2.sh
# Fixes the pathing bug by explicitly passing target directories.

PROJECT_ROOT="$(pwd)"
echo "🛠️ Refactoring Plist Modules (Fixed Paths) at: $PROJECT_ROOT"

mkdir -p "$PROJECT_ROOT/core/helpers"

# --- 1. REWRITE HELPERS (Now accepting TARGET_DIR) ---

# Helper: DUMP PLIST
cat << 'EOF' > "$PROJECT_ROOT/core/helpers/dump_plist.sh"
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
EOF
chmod +x "$PROJECT_ROOT/core/helpers/dump_plist.sh"

# Helper: RESTORE PLIST
cat << 'EOF' > "$PROJECT_ROOT/core/helpers/restore_plist.sh"
#!/bin/bash
APP_NAME="$1"
FILENAME="$2"
TARGET_DIR="$3" # <--- New Argument

if [ "$APP_NAME" == "Finder" ]; then BUNDLE_ID="com.apple.finder";
elif [ "$APP_NAME" == "Dock" ]; then BUNDLE_ID="com.apple.dock";
else
    BUNDLE_ID=$(osascript -e "id of app \"$APP_NAME\"" 2>/dev/null)
fi

CONFIG_FILE="$TARGET_DIR/$FILENAME"

if [ -f "$CONFIG_FILE" ]; then
    echo "Restoring $APP_NAME..."
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
EOF
chmod +x "$PROJECT_ROOT/core/helpers/restore_plist.sh"

# --- 2. REWRITE MODULES (Pass SCRIPT_DIR as 3rd arg) ---

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
    
    # Dump Script: Passes "$SCRIPT_DIR" as the 3rd argument
    cat << EOF > "$PROJECT_ROOT/modules/$MODULE/dump.sh"
#!/bin/bash
SCRIPT_DIR="\$(cd "\$(dirname "\$0")" && pwd)"
REPO_ROOT="\$(cd "\$SCRIPT_DIR/../../" && pwd)"
"\$REPO_ROOT/core/helpers/dump_plist.sh" "$APP_NAME" "$FILENAME" "\$SCRIPT_DIR"
EOF
    chmod +x "$PROJECT_ROOT/modules/$MODULE/dump.sh"

    # Restore Script: Passes "$SCRIPT_DIR" as the 3rd argument
    cat << EOF > "$PROJECT_ROOT/modules/$MODULE/restore.sh"
#!/bin/bash
SCRIPT_DIR="\$(cd "\$(dirname "\$0")" && pwd)"
REPO_ROOT="\$(cd "\$SCRIPT_DIR/../../" && pwd)"
"\$REPO_ROOT/core/helpers/restore_plist.sh" "$APP_NAME" "$FILENAME" "\$SCRIPT_DIR"
EOF
    chmod +x "$PROJECT_ROOT/modules/$MODULE/restore.sh"
    
done

echo "✅ Refactor Complete. Paths are now explicit."