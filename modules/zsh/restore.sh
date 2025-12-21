#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
cp "$SCRIPT_DIR/.functions" "$HOME/.functions"
cp "$SCRIPT_DIR/.aliases" "$HOME/.aliases"
cp "$SCRIPT_DIR/.zsh_prompt" "$HOME/.zsh_prompt"
