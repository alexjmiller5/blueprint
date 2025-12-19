# #!/bin/bash
# SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
# APP_DIR="$HOME/Library/Application Support/com.raycast.macos"

# # Added --exclude 'RaycastWrapped/' to skip the heavy images
# rsync -av --delete \
#     --exclude 'Cache/' \
#     --exclude 'Image Cache/' \
#     --exclude 'Favicons/' \
#     --exclude 'RaycastWrapped/' \
#     --exclude '*.log' \
#     "$APP_DIR/" "$SCRIPT_DIR/data/"

# "$REPO_ROOT/core/git_push.sh"