#!/bin/bash
# associations.sh
# Sets default applications for file types using 'duti'

if ! command -v duti &> /dev/null; then
    echo "❌ 'duti' is not installed. Skipping file associations."
    echo "   Run: brew install duti"
    exit 1
fi

echo "🔗 Setting File Associations..."

curl "https://raw.githubusercontent.com/github/linguist/master/lib/linguist/languages.yml" \
| yq -r "to_entries | (map(.value.extensions) | flatten) - [null] | unique | .[]" \
| xargs -L 1 -I "{}" duti -s com.microsoft.VSCode {} all

# Application Bundle IDs
VSCODE="com.microsoft.VSCode"
QUICKTIME="com.apple.QuickTimePlayerX"
LIBREOFFICE="org.libreoffice.script" 

# --- DEVELOPMENT (VS Code) ---
# Added .cherri per your notes
duti -s $VSCODE .cherri all

# Standard Dev Files
for ext in ts tsx js jsx json py sh zsh bash lua yaml yml toml md css scss html xml plist c cpp h txt csv log sql tf tfvars; do
    duti -s $VSCODE .$ext all
done

# --- MEDIA (QuickTime) ---
# Notes: "set mp3 to naturally open with quicktime instead of apple music"
duti -s $QUICKTIME .mp3 all
duti -s $QUICKTIME .wav all
duti -s $QUICKTIME .mp4 all
duti -s $QUICKTIME .mov all

# --- DOCUMENTS (LibreOffice) ---
# Notes: "tell .docx and .pptx ... to all be opened by libreoffice"
# Only runs if LibreOffice is actually installed
if [ -d "/Applications/LibreOffice.app" ]; then
    duti -s $LIBREOFFICE .docx all
    duti -s $LIBREOFFICE .doc all
    duti -s $LIBREOFFICE .pptx all
    duti -s $LIBREOFFICE .ppt all
    duti -s $LIBREOFFICE .xlsx all
    duti -s $LIBREOFFICE .xls all
fi

echo "✅ File associations updated."