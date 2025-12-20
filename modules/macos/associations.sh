#!/bin/bash
# associations.sh
# Sets default applications for file types using 'duti'

if ! command -v duti &> /dev/null; then
    echo "❌ 'duti' is not installed. Skipping file associations."
    echo "   Run: brew install duti"
    exit 1
fi

echo "🔗 Setting File Associations..."

# VS Code Bundle ID
VSCODE="com.microsoft.VSCode"

# --- DEVELOPMENT ---
duti -s $VSCODE .ts all
duti -s $VSCODE .tsx all
duti -s $VSCODE .js all
duti -s $VSCODE .jsx all
duti -s $VSCODE .json all
duti -s $VSCODE .py all
duti -s $VSCODE .sh all
duti -s $VSCODE .zsh all
duti -s $VSCODE .bash all
duti -s $VSCODE .lua all
duti -s $VSCODE .yaml all
duti -s $VSCODE .yml all
duti -s $VSCODE .toml all
duti -s $VSCODE .md all
duti -s $VSCODE .css all
duti -s $VSCODE .scss all
duti -s $VSCODE .html all
duti -s $VSCODE .xml all
duti -s $VSCODE .plist all
duti -s $VSCODE .c all
duti -s $VSCODE .cpp all
duti -s $VSCODE .h all
duti -s $VSCODE .txt all
duti -s $VSCODE .csv all
duti -s $VSCODE .log all
duti -s $VSCODE .sql all
duti -s $VSCODE .tf all        # Terraform
duti -s $VSCODE .tfvars all    # Terraform vars

echo "✅ File associations updated."