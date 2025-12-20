#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/backup"
mkdir -p "$BACKUP_DIR"
sqlite3 "$HOME/Library/Application Support/com.apple.TCC/TCC.db" "SELECT service, client, auth_value FROM access" > "$BACKUP_DIR/tcc_dump.txt"
"$REPO_ROOT/core/git_push.sh"
