#!/bin/bash
# Get the absolute path of the repo
REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
AGENTS_DIR="$HOME/Library/LaunchAgents"

echo "📍 Blueprint Location: $REPO_ROOT"
echo "🔧 Setting permissions..."
chmod +x "$REPO_ROOT/core/"*.sh
chmod +x "$REPO_ROOT/modules/"*/*.sh

python3 -c "
import yaml
with open('$REPO_ROOT/settings.yaml', 'r') as f:
    config = yaml.safe_load(f)
for module, enabled in config['modules'].items():
    print(f'{module}:{enabled}')
" | while read line; do
    module=$(echo "$line" | cut -d':' -f1)
    enabled=$(echo "$line" | cut -d':' -f2)
    
    src_plist="$REPO_ROOT/modules/$module/com.alexmiller.blueprint.$module.plist"
    dest_plist="$AGENTS_DIR/com.alexmiller.blueprint.$module.plist"

    if [ "$enabled" == "True" ]; then
        if [ -f "$src_plist" ]; then
            echo "  [+] Activating: $module"
            
            # Read template, replace {{ROOT}} with actual path, write to LaunchAgents
            sed "s|{{ROOT}}|$REPO_ROOT|g" "$src_plist" > "$dest_plist"
            
            launchctl unload "$dest_plist" 2>/dev/null
            launchctl load "$dest_plist"
        else
            echo "  [!] Missing plist for: $module"
        fi
    else
        if [ -f "$dest_plist" ]; then
            echo "  [-] Deactivating: $module"
            launchctl unload "$dest_plist" 2>/dev/null
            rm "$dest_plist"
        fi
    fi
done
echo "✅ Blueprint configuration updated."
