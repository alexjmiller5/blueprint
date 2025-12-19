#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
EXT_DIR="$HOME/Library/Application Support/Google/Chrome/Default/Extensions"
OUT="$SCRIPT_DIR/extensions_list.md"
echo "# Chrome Extensions" > "$OUT"
if [ -d "$EXT_DIR" ]; then
    find "$EXT_DIR" -name "manifest.json" -depth 3 | while read m; do
        name=$(python3 -c "import json; print(json.load(open('$m'))['name'])" 2>/dev/null)
        [ ! -z "$name" ] && echo "- $name" >> "$OUT"
    done
fi
"$REPO_ROOT/core/git_push.sh"
