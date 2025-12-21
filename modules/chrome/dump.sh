#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
CHROME_SUPPORT_DIR="$HOME/Library/Application Support/Google/Chrome"
BACKUP_DIR="$SCRIPT_DIR/backup"
mkdir -p "$BACKUP_DIR"
OUT="$BACKUP_DIR/extensions_list.md"
TMP_OUT=$(mktemp)

echo "# Chrome Extensions" > "$OUT"

PROFILE_PATHS=("$CHROME_SUPPORT_DIR/Default/Extensions" "$CHROME_SUPPORT_DIR/Profile "*/Extensions)

for EXT_DIR in "${PROFILE_PATHS[@]}"; do
    if [ ! -d "$EXT_DIR" ]; then
        continue
    fi
    find "$EXT_DIR" -name "manifest.json" -mindepth 2 | while read m; do
        name=$(python3 -c "import json; print(json.load(open('$m')).get('name', ''))" 2>/dev/null)
        if [[ ! -z "$name" && ! "$name" =~ "__MSG" ]]; then
            echo "- $name" >> "$TMP_OUT"
        fi
    done
done

sort -u "$TMP_OUT" >> "$OUT"
rm "$TMP_OUT"

"$REPO_ROOT/core/git_push.sh"
