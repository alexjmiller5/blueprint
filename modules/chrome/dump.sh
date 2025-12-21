#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
CHROME_SUPPORT_DIR="$HOME/Library/Application Support/Google/Chrome"
BACKUP_DIR="$SCRIPT_DIR/backup"
mkdir -p "$BACKUP_DIR"
OUT="$BACKUP_DIR/extensions_list.md"

echo "# Chrome Extensions" > "$OUT"

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
    echo "No Chrome profile found." >> "$OUT"
    exit 0
fi

PREFS_FILE="$PROFILE_DIR/Preferences"
EXT_DIR="$PROFILE_DIR/Extensions"

if [ ! -f "$PREFS_FILE" ] || [ ! -d "$EXT_DIR" ]; then
    echo "Chrome Preferences or Extensions directory not found in $PROFILE_DIR" >> "$OUT"
    exit 0
fi

ALL_EXT_INFO=$(mktemp)
# Get all extension IDs and names
find "$EXT_DIR" -name "manifest.json" -mindepth 2 -maxdepth 3 -print0 | while IFS= read -r -d $'\0' m; do
    EXT_ID=$(basename "$(dirname "$(dirname "$m")")")
    NAME=$(jq -r '.name' "$m" 2>/dev/null | tr -d '"')
    if [[ ! -z "$NAME" && ! "$NAME" =~ "__MSG" ]]; then
        echo "$EXT_ID $NAME" >> "$ALL_EXT_INFO"
    fi
done

PINNED_IDS=$(jq -r '(.extensions.pinned_extensions // []) | .[]' "$PREFS_FILE")
SETTINGS_JSON=$(jq '.extensions.settings' "$PREFS_FILE")
PINNED_OUT=$(mktemp)
OTHER_OUT=$(mktemp)

# Process pinned extensions
for pinned_id in $PINNED_IDS; do
    line=$(grep "^$pinned_id " "$ALL_EXT_INFO")
    if [[ -z "$line" ]]; then continue; fi
    name=${line#* }

    state=$(echo "$SETTINGS_JSON" | jq -r --arg id "$pinned_id" '.[$id].state // 0')
    state_icon=$([ "$state" == "1" ] && echo "[x]" || echo "[ ]")

    echo " - $state_icon $name" >> "$PINNED_OUT"
done

# Process other extensions
while read -r line; do
    ext_id=${line%% *}
    name=${line#* }

    is_pinned=false
    for pinned_id in $PINNED_IDS; do [[ "$ext_id" == "$pinned_id" ]] && is_pinned=true && break; done

    if ! $is_pinned; then
        state=$(echo "$SETTINGS_JSON" | jq -r --arg id "$ext_id" '.[$id].state // 0')
        state_icon=$([ "$state" == "1" ] && echo "[x]" || echo "[ ]")
        echo " - $state_icon $name" >> "$OTHER_OUT"
    fi
done < "$ALL_EXT_INFO"

# Assemble final file
if [ -s "$PINNED_OUT" ]; then
    echo "## Pinned" >> "$OUT"
    cat "$PINNED_OUT" >> "$OUT"
    echo "" >> "$OUT"
fi
if [ -s "$OTHER_OUT" ]; then
    echo "## Other Extensions" >> "$OUT"
    sort -u "$OTHER_OUT" >> "$OUT"
fi

rm "$ALL_EXT_INFO" "$PINNED_OUT" "$OTHER_OUT"

"$REPO_ROOT/core/git_push.sh"
