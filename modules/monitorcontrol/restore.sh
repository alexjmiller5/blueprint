#!/bin/bash
# Use shared helper
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
"$REPO_ROOT/core/helpers/restore_plist.sh" "MonitorControl" "me.guillaumeb.MonitorControl.plist"
