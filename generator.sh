#!/bin/bash
# generate_portable_blueprint.sh
# Creates a location-agnostic Blueprint setup.

# Determine where we are running this script
PROJECT_ROOT="$(pwd)"

echo "🚀 Initializing Portable Blueprint at: $PROJECT_ROOT"

# 1. Create Directory Structure
mkdir -p core
mkdir -p modules/{zsh,vscode,homebrew,raycast,chrome,chrome_pwas,manual_apps,login_items,dock,permissions,macos,git,ssh,hammerspoon,karabiner,finder}
mkdir -p modules/{alttab,rectangle,betterdisplay,keyclu,monitorcontrol}
mkdir -p modules/raycast/data
mkdir -p modules/vscode/snippets

# --- ROOT FILES ---

echo "📝 Creating Configs..."

cat << 'EOF' > settings.yaml
modules:
  zsh: true
  vscode: true
  raycast: true
  homebrew: true
  chrome: true
  chrome_pwas: true
  dock: true
  login_items: true
  permissions: true
  manual_apps: true
  alttab: true
  rectangle: true
  betterdisplay: true
  keyclu: true
  monitorcontrol: true
  finder: true
  git: true
  ssh: false
  hammerspoon: true
  karabiner: true
EOF

# --- INSTALL SCRIPT (The Magic Linker) ---
# This script replaces {{ROOT}} with the actual path when installing
cat << 'EOF' > install.sh
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
EOF
chmod +x install.sh

cat << 'EOF' > MANUAL_STEPS.md
# Manual Setup Steps
- [ ] **Permissions**: Grant Accessibility/Screen Recording to apps manually.
- [ ] **Chrome**: Install extensions from list.
- [ ] **System Settings**: Set Permissions manually.
EOF

# --- CORE LOGIC (Dynamic Pathing) ---

echo "⚙️ Creating Core Logic..."

cat << 'EOF' > core/git_push.sh
#!/bin/bash
# Find repo root relative to this script
CORE_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$CORE_DIR/.." && pwd)"

cd "$REPO_ROOT" || exit
git add .
if ! git diff-index --quiet HEAD --; then
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    # echo "[$TIMESTAMP] Changes detected. Pushing..." >> /tmp/blueprint_backup.log
    git commit -m "Auto-backup: $TIMESTAMP"
    git push origin main
fi
EOF

# --- MODULES ---

echo "📦 Creating Modules..."

# ZSH
cat << 'EOF' > modules/zsh/dump.sh
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"

cp "$HOME/.zshrc" "$SCRIPT_DIR/.zshrc"
cp "$HOME/.aliases" "$SCRIPT_DIR/.aliases"
"$REPO_ROOT/core/git_push.sh"
EOF
cat << 'EOF' > modules/zsh/restore.sh
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
cp "$SCRIPT_DIR/.aliases" "$HOME/.aliases"
EOF
cat << 'EOF' > modules/zsh/com.alexmiller.blueprint.zsh.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>com.alexmiller.blueprint.zsh</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>{{ROOT}}/modules/zsh/dump.sh</string>
    </array>
    <key>WatchPaths</key>
    <array><string>/Users/alexmiller/.zshrc</string><string>/Users/alexmiller/.aliases</string></array>
    <key>ThrottleInterval</key><integer>10</integer>
</dict>
</plist>
EOF

# VSCODE
cat << 'EOF' > modules/vscode/dump.sh
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
USER_DIR="$HOME/Library/Application Support/Code/User"

cp "$USER_DIR"/{settings.json,keybindings.json,tasks.json} "$SCRIPT_DIR/"
[ -f "$USER_DIR/mcp.json" ] && cp "$USER_DIR/mcp.json" "$SCRIPT_DIR/"
rm -rf "$SCRIPT_DIR/snippets" && cp -R "$USER_DIR/snippets" "$SCRIPT_DIR/"
command -v code >/dev/null && code --list-extensions > "$SCRIPT_DIR/extensions.txt"
"$REPO_ROOT/core/git_push.sh"
EOF
cat << 'EOF' > modules/vscode/restore.sh
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
USER_DIR="$HOME/Library/Application Support/Code/User"
mkdir -p "$USER_DIR"
cp "$SCRIPT_DIR"/{settings.json,keybindings.json,tasks.json} "$USER_DIR/"
[ -f "$SCRIPT_DIR/mcp.json" ] && cp "$SCRIPT_DIR/mcp.json" "$USER_DIR/"
cp -R "$SCRIPT_DIR/snippets" "$USER_DIR/"
command -v code >/dev/null && cat "$SCRIPT_DIR/extensions.txt" | xargs -n 1 code --install-extension --force
EOF
cat << 'EOF' > modules/vscode/com.alexmiller.blueprint.vscode.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>com.alexmiller.blueprint.vscode</string>
    <key>ProgramArguments</key><array><string>/bin/bash</string><string>{{ROOT}}/modules/vscode/dump.sh</string></array>
    <key>WatchPaths</key><array>
        <string>/Users/alexmiller/Library/Application Support/Code/User/settings.json</string>
        <string>/Users/alexmiller/.vscode/extensions</string>
    </array>
    <key>ThrottleInterval</key><integer>60</integer>
</dict>
</plist>
EOF

# HOMEBREW
cat << 'EOF' > modules/homebrew/dump.sh
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
cd "$SCRIPT_DIR" || exit
brew bundle dump --force
"$REPO_ROOT/core/git_push.sh"
EOF
cat << 'EOF' > modules/homebrew/restore.sh
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR" || exit
brew bundle install
EOF
cat << 'EOF' > modules/homebrew/com.alexmiller.blueprint.homebrew.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>com.alexmiller.blueprint.homebrew</string>
    <key>ProgramArguments</key><array><string>/bin/bash</string><string>{{ROOT}}/modules/homebrew/dump.sh</string></array>
    <key>WatchPaths</key><array><string>/opt/homebrew/Cellar</string></array>
    <key>ThrottleInterval</key><integer>60</integer>
</dict>
</plist>
EOF

# RAYCAST
cat << 'EOF' > modules/raycast/dump.sh
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
APP_DIR="$HOME/Library/Application Support/com.raycast.macos"

rsync -av --delete --exclude 'Cache/' --exclude 'Image Cache/' --exclude 'Favicons/' --exclude '*.log' "$APP_DIR/" "$SCRIPT_DIR/data/"
"$REPO_ROOT/core/git_push.sh"
EOF
cat << 'EOF' > modules/raycast/restore.sh
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_DIR="$HOME/Library/Application Support/com.raycast.macos"
killall Raycast 2>/dev/null
rsync -av "$SCRIPT_DIR/data/" "$APP_DIR/"
open -a Raycast
EOF
cat << 'EOF' > modules/raycast/com.alexmiller.blueprint.raycast.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>com.alexmiller.blueprint.raycast</string>
    <key>ProgramArguments</key><array><string>/bin/bash</string><string>{{ROOT}}/modules/raycast/dump.sh</string></array>
    <key>WatchPaths</key><array><string>/Users/alexmiller/Library/Application Support/com.raycast.macos/raycast.sqlite</string></array>
    <key>ThrottleInterval</key><integer>300</integer>
</dict>
</plist>
EOF

# GENERIC PLIST MODULES LOOP
PLIST_APPS=(
    "alttab|com.blackhole.alttab.plist"
    "rectangle|com.knollsoft.Rectangle.plist"
    "betterdisplay|pro.betterdisplay.BetterDisplay.plist"
    "keyclu|com.sergey-software.keyclu.plist"
    "monitorcontrol|me.guillaumeb.MonitorControl.plist"
    "finder|com.apple.finder.plist"
    "dock|com.apple.dock.plist"
)

for ENTRY in "${PLIST_APPS[@]}"; do
    APP="${ENTRY%%|*}"
    PLIST="${ENTRY##*|}"
    
    cat << EOF > modules/$APP/dump.sh
#!/bin/bash
SCRIPT_DIR="\$(cd "\$(dirname "\$0")" && pwd)"
REPO_ROOT="\$(cd "\$SCRIPT_DIR/../../" && pwd)"
SRC="\$HOME/Library/Preferences/$PLIST"
DST="\$SCRIPT_DIR/$PLIST"
[ -f "\$SRC" ] && plutil -convert xml1 "\$SRC" -o "\$DST"
"\$REPO_ROOT/core/git_push.sh"
EOF

    cat << EOF > modules/$APP/restore.sh
#!/bin/bash
SCRIPT_DIR="\$(cd "\$(dirname "\$0")" && pwd)"
SRC="\$SCRIPT_DIR/$PLIST"
DST="\$HOME/Library/Preferences/$PLIST"
cp "\$SRC" "\$DST"
plutil -convert binary1 "\$DST"
killall cfprefsd
EOF
    # Dock needs special restart
    if [ "$APP" == "dock" ]; then
        echo "killall Dock" >> modules/$APP/restore.sh
    fi

    cat << EOF > modules/$APP/com.alexmiller.blueprint.$APP.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>com.alexmiller.blueprint.$APP</string>
    <key>ProgramArguments</key><array><string>/bin/bash</string><string>{{ROOT}}/modules/$APP/dump.sh</string></array>
    <key>WatchPaths</key><array><string>/Users/alexmiller/Library/Preferences/$PLIST</string></array>
    <key>ThrottleInterval</key><integer>60</integer>
</dict>
</plist>
EOF
done

# REMAINING MODULES (Git, SSH, etc - simplified for brevity, following same pattern)
# ... (I'll add the critical ones below)

# GIT
cat << 'EOF' > modules/git/dump.sh
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
cp "$HOME/.gitconfig" "$SCRIPT_DIR/.gitconfig"
"$REPO_ROOT/core/git_push.sh"
EOF
cat << 'EOF' > modules/git/com.alexmiller.blueprint.git.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>com.alexmiller.blueprint.git</string>
    <key>ProgramArguments</key><array><string>/bin/bash</string><string>{{ROOT}}/modules/git/dump.sh</string></array>
    <key>WatchPaths</key><array><string>/Users/alexmiller/.gitconfig</string></array>
</dict>
</plist>
EOF

# CHROME
cat << 'EOF' > modules/chrome/dump.sh
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
EXT_DIR="$HOME/Library/Application Support/Google/Chrome/Default/Extensions"
OUT="$SCRIPT_DIR/extensions_list.md"
echo "# Chrome Extensions" > "$OUT"
if [ -d "$EXT_DIR" ]; then
    find "$EXT_DIR" -name "manifest.json" -depth 3 | while read m; do
        name=$(python3 -c "import json; print(json.load(open('$m'))['name'])" 2>/dev/null)
        [ ! -z "$name" ] && echo "- $name" >> "$OUT"
    done
fi
"$REPO_ROOT/core/git_push.sh"
EOF
cat << 'EOF' > modules/chrome/com.alexmiller.blueprint.chrome.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>com.alexmiller.blueprint.chrome</string>
    <key>ProgramArguments</key><array><string>/bin/bash</string><string>{{ROOT}}/modules/chrome/dump.sh</string></array>
    <key>WatchPaths</key><array><string>/Users/alexmiller/Library/Application Support/Google/Chrome/Default/Extensions</string></array>
    <key>ThrottleInterval</key><integer>300</integer>
</dict>
</plist>
EOF

# CHROME PWAS
cat << 'EOF' > modules/chrome_pwas/dump.sh
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
PWA_DIR="$HOME/Applications/Chrome Apps"
OUT="$SCRIPT_DIR/pwa_list.md"
echo "# Chrome PWAs" > "$OUT"
[ -d "$PWA_DIR" ] && ls "$PWA_DIR" | grep ".app" >> "$OUT"
"$REPO_ROOT/core/git_push.sh"
EOF
cat << 'EOF' > modules/chrome_pwas/com.alexmiller.blueprint.chrome_pwas.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>com.alexmiller.blueprint.chrome_pwas</string>
    <key>ProgramArguments</key><array><string>/bin/bash</string><string>{{ROOT}}/modules/chrome_pwas/dump.sh</string></array>
    <key>WatchPaths</key><array><string>/Users/alexmiller/Applications/Chrome Apps</string></array>
    <key>ThrottleInterval</key><integer>60</integer>
</dict>
</plist>
EOF

# LOGIN ITEMS
cat << 'EOF' > modules/login_items/dump.sh
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
osascript -e 'tell application "System Events" to get the name of every login item' | sed 's/, /\n/g' > "$SCRIPT_DIR/items.txt"
"$REPO_ROOT/core/git_push.sh"
EOF
cat << 'EOF' > modules/login_items/com.alexmiller.blueprint.login_items.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>com.alexmiller.blueprint.login_items</string>
    <key>ProgramArguments</key><array><string>/bin/bash</string><string>{{ROOT}}/modules/login_items/dump.sh</string></array>
    <key>RunAtLoad</key><true/>
    <key>StartInterval</key><integer>3600</integer>
</dict>
</plist>
EOF

# PERMISSIONS
cat << 'EOF' > modules/permissions/dump.sh
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
sqlite3 "$HOME/Library/Application Support/com.apple.TCC/TCC.db" "SELECT service, client, auth_value FROM access" > "$SCRIPT_DIR/tcc_dump.txt"
"$REPO_ROOT/core/git_push.sh"
EOF
cat << 'EOF' > modules/permissions/com.alexmiller.blueprint.permissions.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>com.alexmiller.blueprint.permissions</string>
    <key>ProgramArguments</key><array><string>/bin/bash</string><string>{{ROOT}}/modules/permissions/dump.sh</string></array>
    <key>StartInterval</key><integer>86400</integer>
</dict>
</plist>
EOF

# MANUAL APPS
cat << 'EOF' > modules/manual_apps/dump.sh
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
OUT="$SCRIPT_DIR/apps_list.md"
BREW=$(brew list --cask 2>/dev/null)
echo "# App Audit" > "$OUT"
find /Applications -name "*.app" -maxdepth 1 -print0 | xargs -0 basename -s .app | while read app; do
    if echo "$BREW" | grep -iq "$(echo "$app" | sed 's/ /-/g')"; then
        echo "- [Brew] $app" >> "$OUT"
    else
        echo "- [Manual] $app" >> "$OUT"
    fi
done
"$REPO_ROOT/core/git_push.sh"
EOF
cat << 'EOF' > modules/manual_apps/com.alexmiller.blueprint.manual_apps.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>com.alexmiller.blueprint.manual_apps</string>
    <key>ProgramArguments</key><array><string>/bin/bash</string><string>{{ROOT}}/modules/manual_apps/dump.sh</string></array>
    <key>WatchPaths</key><array><string>/Applications</string></array>
    <key>ThrottleInterval</key><integer>300</integer>
</dict>
</plist>
EOF

# HAMMERSPOON
cat << 'EOF' > modules/hammerspoon/dump.sh
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
cp "$HOME/.hammerspoon/init.lua" "$SCRIPT_DIR/init.lua"
"$REPO_ROOT/core/git_push.sh"
EOF
cat << 'EOF' > modules/hammerspoon/com.alexmiller.blueprint.hammerspoon.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>com.alexmiller.blueprint.hammerspoon</string>
    <key>ProgramArguments</key><array><string>/bin/bash</string><string>{{ROOT}}/modules/hammerspoon/dump.sh</string></array>
    <key>WatchPaths</key><array><string>/Users/alexmiller/.hammerspoon/init.lua</string></array>
</dict>
</plist>
EOF

# KARABINER
cat << 'EOF' > modules/karabiner/dump.sh
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
cp "$HOME/.config/karabiner/karabiner.json" "$SCRIPT_DIR/karabiner.json"
"$REPO_ROOT/core/git_push.sh"
EOF
cat << 'EOF' > modules/karabiner/com.alexmiller.blueprint.karabiner.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>com.alexmiller.blueprint.karabiner</string>
    <key>ProgramArguments</key><array><string>/bin/bash</string><string>{{ROOT}}/modules/karabiner/dump.sh</string></array>
    <key>WatchPaths</key><array><string>/Users/alexmiller/.config/karabiner/karabiner.json</string></array>
</dict>
</plist>
EOF

# SSH
cat << 'EOF' > modules/ssh/dump.sh
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
cp "$HOME/.ssh/config" "$SCRIPT_DIR/config"
"$REPO_ROOT/core/git_push.sh"
EOF
cat << 'EOF' > modules/ssh/com.alexmiller.blueprint.ssh.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>com.alexmiller.blueprint.ssh</string>
    <key>ProgramArguments</key><array><string>/bin/bash</string><string>{{ROOT}}/modules/ssh/dump.sh</string></array>
    <key>WatchPaths</key><array><string>/Users/alexmiller/.ssh/config</string></array>
</dict>
</plist>
EOF

echo "✅ Generation Complete. Run './install.sh' to activate."