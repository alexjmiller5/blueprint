#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
sqlite3 "$HOME/Library/Application Support/com.apple.TCC/TCC.db" "SELECT service, client, auth_value FROM access" > "$SCRIPT_DIR/tcc_dump.txt"
"$REPO_ROOT/core/git_push.sh"
