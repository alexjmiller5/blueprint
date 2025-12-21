#!/bin/bash

if ! command -v duti &> /dev/null; then
    echo "❌ 'duti' is not installed. Skipping file associations."
    echo "   Run: brew install duti"
    exit 1
fi

echo "🔗 Setting File Associations..."

curl "https://raw.githubusercontent.com/github/linguist/master/lib/linguist/languages.yml" \
| yq -r "to_entries | (map(.value.extensions) | flatten) - [null] | unique | .[]" \
| xargs -L 1 -I "{}" duti -s com.microsoft.VSCode {} all

VSCODE="com.microsoft.VSCode"
QUICKTIME="com.apple.QuickTimePlayerX"
LIBREOFFICE="org.libreoffice.script" 

duti -s $VSCODE .cherri all

duti -s $QUICKTIME .mp3 all
duti -s $QUICKTIME .wav all
duti -s $QUICKTIME .mp4 all
duti -s $QUICKTIME .mov all

if [ -d "/Applications/LibreOffice.app" ]; then
    duti -s $LIBREOFFICE .docx all
    duti -s $LIBREOFFICE .doc all
    duti -s $LIBREOFFICE .pptx all
    duti -s $LIBREOFFICE .ppt all
    duti -s $LIBREOFFICE .xlsx all
    duti -s $LIBREOFFICE .xls all
fi

echo "✅ File associations updated."