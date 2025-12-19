#!/bin/bash
# core/git_push.sh

# Find repo root relative to this script
CORE_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$CORE_DIR/.." && pwd)"

# Define the specific SSH command for this repo
# We use $HOME to ensure the path is absolute and robust
SSH_KEY="$HOME/.ssh/blueprint_deploy_key"
SSH_CMD="ssh -i $SSH_KEY -o IdentitiesOnly=yes"

cd "$REPO_ROOT" || exit
git add .

if ! git diff-index --quiet HEAD --; then
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    
    # 1. Commit with GPG signing explicitly DISABLED for this command (-c commit.gpgsign=false)
    git -c commit.gpgsign=false commit -m "Auto-backup: $TIMESTAMP"
    
    # 2. Push using the custom SSH command (-c core.sshCommand="...")
    git -c core.sshCommand="$SSH_CMD" push origin main
fi