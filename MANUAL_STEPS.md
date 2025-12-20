# Manual Setup Steps
- [ ] **Permissions**: Grant Accessibility/Screen Recording to apps manually.
- [ ] **Chrome**: Install extensions from list.
- [ ] **System Settings**: Set Permissions manually.
# Manual Setup Steps

These steps cannot be automated via script due to macOS System Integrity Protection (SIP), binary database limitations, or complex UI interactions.

## 1. Security & Privacy Permissions (SIP Protected)
macOS will not allow scripts to grant these permissions. You must grant them manually when the apps first launch.

## 2. Google Chrome
- [ ] **Extensions**: Open `modules/chrome/extensions_list.md` and click the links to install missing extensions.
- [ ] **PWA Link Capturing** (Cannot be scripted):
    - **YouTube**: Open App Info (⋮ > App Info) > Settings > Select "Open in YouTube".
    - **Spotify**: Open App Info > Settings > Select "Open in Spotify".
    - **Google Drive/Docs**: Ensure Offline mode is enabled.

## Finder

- Set the following order of the finder sidebar

## 6. Miscellaneous
- [ ] **Spotify**: Disable "Hardware Acceleration" in settings if VPN/Firewall causes stuttering.
- [ ] **Finder Favorites**: Manually drag "Google Drive", "Downloads", and "Code" to the Finder Sidebar (Sidebar order cannot be strictly enforced via plist).
- [ ] Disable SIP - this will allow permissions management via automation as well as the use o the `yabai` cli