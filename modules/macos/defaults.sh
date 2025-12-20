#!/bin/bash
sudo -v
# Night Shift
if command -v nightlight &>/dev/null; then
    nightlight schedule 19:00 12:00
    nightlight temp 100
fi
# Displays
sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Automatic Display Enabled" -bool false
# Input
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 2

# Close System Preferences
osascript -e 'tell application "System Preferences" to quit'

###############################################################################
# 1. INPUT (Trackpad, Mouse, Keyboard)                                        #
###############################################################################
# Set trackpad scroll speed (max is usually 3, forcing 5)
defaults write -g com.apple.trackpad.scaling -float 5.0
# Set mouse sensitivity
defaults write -g com.apple.mouse.scaling -float 5.0

# Key repeat (Fastest)
defaults write NSGlobalDomain InitialKeyRepeat -int 10
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Disable "Natural" scrolling (Optional - remove if you like Natural scrolling)
# defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Accessibility: Scroll gesture with modifier key to zoom
# (This maps to: Use scroll gesture with modifier keys to zoom -> ^ Control)
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

###############################################################################
# 2. WINDOW MANAGEMENT & MISSION CONTROL (Sequoia+)                           #
###############################################################################
# Disable "Click wallpaper to reveal desktop" (Only in Stage Manager)
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

# Disable "Tiled windows have margins" (macOS 15+)
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false

# Stage Manager: Group apps (Disable "Show recent apps in Stage Manager" strip if desired)
# defaults write com.apple.WindowManager Globals -dict-add "AutoHide" -bool true

# Hot Corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen
# 14: Quick Note (Disable this!)

# Top Left: Mission Control (2)
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0

# Bottom Right: Disable Quick Note (Set to 0)
defaults write com.apple.dock wvous-br-corner -int 0
defaults write com.apple.dock wvous-br-modifier -int 0

###############################################################################
# 3. DOCK                                                                     #
###############################################################################
# Autohide instantly
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -int 0

# Don't show recent applications
defaults write com.apple.dock show-recents -bool false

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

###############################################################################
# 4. FINDER                                                                   #
###############################################################################
# Allow quitting Finder
defaults write com.apple.finder QuitMenuItem -bool true

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show full path in window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Show path bar & status bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Keep folders on top
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# List view by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Search the current folder by default (not "This Mac")
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

###############################################################################
# 5. OTHER APPS (Mail, Safari, Time Machine)                                  #
###############################################################################
# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Chrome: Disable print preview (Optional, from generic dev setups)
defaults write com.google.Chrome DisablePrintPreview -bool true

###############################################################################
# 6. RESTART                                                                  #
###############################################################################
echo "  Restarting apps..."
killall Dock Finder SystemUIServer cfprefsd