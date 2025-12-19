#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"

sed -E 's/[[:<:]]([0-9]{1,3}\.){3}[0-9]{1,3}[[:>:]]/<REDACTED_IP>/g' "$HOME/.ssh/config" > "$SCRIPT_DIR/config"

"$REPO_ROOT/core/git_push.sh"