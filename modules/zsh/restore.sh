#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
cp "$SCRIPT_DIR/.aliases" "$HOME/.aliases"
