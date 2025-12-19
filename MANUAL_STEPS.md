# Manual Setup Steps
- [ ] **Permissions**: Grant Accessibility/Screen Recording to apps manually.
- [ ] **Chrome**: Install extensions from list.
- [ ] **System Settings**: Set Permissions manually.
# Manual Setup Steps

These steps cannot be automated via script due to macOS System Integrity Protection (SIP), binary database limitations, or complex UI interactions.

## 1. Security & Privacy Permissions (SIP Protected)
macOS will not allow scripts to grant these permissions. You must grant them manually when the apps first launch.

- [ ] **Accessibility** (`System Settings > Privacy & Security > Accessibility`):
    - Alfred
    - Rectangle
    - AltTab
    - Hammerspoon
    - Karabiner-Elements
    - BetterDisplay
- [ ] **Screen Recording** (`System Settings > Privacy & Security > Screen Recording`):
    - AltTab (Required for window previews)
    - CleanShot X
    - Zoom
    - Slack
- [ ] **Input Monitoring** (`System Settings > Privacy & Security > Input Monitoring`):
    - Karabiner-Elements (Required for key remapping)
- [ ] **Full Disk Access** (`System Settings > Privacy & Security > Full Disk Access`):
    - Terminal / Ghostty (Required to run Blueprint backup scripts)
    - Visual Studio Code

## 2. Google Chrome
- [ ] **Extensions**: Open `modules/chrome/extensions_list.md` and click the links to install missing extensions.
- [ ] **PWA Link Capturing** (Cannot be scripted):
    - **YouTube**: Open App Info (⋮ > App Info) > Settings > Select "Open in YouTube".
    - **Spotify**: Open App Info > Settings > Select "Open in Spotify".
    - **Google Drive/Docs**: Ensure Offline mode is enabled.

## 3. Communication Apps
### Slack
- [ ] **Theme**: Appearance > Color Mode > **Tritanopia**.
- [ ] **Sidebar**: 
    - Navigation: **Icons Only** (removes text labels).
    - Sort: **By Recent**.
    - Sections: Create **"Support NYC"** and **"Announcements"**.
- [ ] **Notifications**: 
    - Sound: **"Whoa!"** (Global).
    - Schedule: Weekdays **9:00 AM - 5:00 PM** only.
    - Badges: Disable "Show a badge on Slack's icon" (Dock).
- [ ] **Profile**: Update Title/Role to match Gmail signature.

### Zoom
- [ ] **Profile**: Upload professional headshot.
- [ ] **Integration**: Connect Zoom to Slack app.
- [ ] **Audio**: Test microphone input levels (disable auto-adjust if noisy).

## 4. Google Workspace
### Gmail
- [ ] **General Settings**:
    - **Undo Send**: Set to **10 seconds** (Default is 5).
    - **Reading Pane**: Enable "Right of inbox".
- [ ] **Filters**:
    - Create Filter: Has words "Routine Notification" -> Apply Label **"Red"** / Skip Inbox.

### Google Calendar
- [ ] **Settings**: Enable **Offline Calendar**.
- [ ] **Locations**: Set "Working Location" -> Office Building (NYC) vs Remote days.
- [ ] **Notifications**: Verify Slack integration is sending daily digests.

### Google Drive
- [ ] **Sync**: Install Google Drive for Desktop.
- [ ] **Configuration**: 
    - Set to **Stream files** (Mirroring often disabled by policy).
    - Mark "Desktop" and "Documents" folders as **Available Offline** manually if mirroring is unavailable.

## 5. Workday & HR
- [ ] **Contact Info**: Update Personal Contact & Emergency Contact in Workday.
- [ ] **Referrals**: Restore "Referrals" bookmark folder from Chrome backup.

## 6. Miscellaneous
- [ ] **Spotify**: Disable "Hardware Acceleration" in settings if VPN/Firewall causes stuttering.
- [ ] **Finder Favorites**: Manually drag "Google Drive", "Downloads", and "Code" to the Finder Sidebar (Sidebar order cannot be strictly enforced via plist).
- [ ] Disable SIP - this will allow permissions management via automation as well as the use o the `yabai` cli