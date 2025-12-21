#!/bin/bash

# Setup
sudo -v
osascript -e 'tell application "System Preferences" to quit'

# Display & Night Shift
if command -v nightlight &>/dev/null; then
    nightlight schedule 19:00 12:00
    nightlight temp 100
fi
sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Automatic Display Enabled" -bool false

# Input (Keyboard, Mouse, Trackpad)
defaults write -g com.apple.trackpad.scaling -float 5.0
defaults write -g com.apple.mouse.scaling -float 5.0
defaults write NSGlobalDomain InitialKeyRepeat -int 10
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Accessibility (Zoom)
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

# Window Management
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false
defaults write com.apple.dock mru-spaces -bool false

# Hot Corners (Top Left: Mission Control, Bottom Right: Disable Quick Note)
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-br-corner -int 0
defaults write com.apple.dock wvous-br-modifier -int 0

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -int 0
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock minimize-to-application -bool true

# Finder
defaults write com.apple.finder QuitMenuItem -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder StandardViewSettings -dict-add ExtendedListViewSettings_calculateAllSizes -bool true
defaults write com.apple.finder ListViewSettings -dict-add calculateAllSizes -bool true

# System & Network
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
defaults write com.apple.bird optimize-storage -bool true
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
xattr -w com.apple.fileprovider.pinned 1 ~/Desktop

# Applications
defaults write com.google.Chrome DisablePrintPreview -bool true

# Shortcuts & Settings Updates
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "{enabled = 0; value = { parameters = (32, 49, 1048576); type = 'standard'; }; }"
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:64:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

# Restart Services
echo "  Restarting apps..."
killall Dock Finder SystemUIServer cfprefsd bird