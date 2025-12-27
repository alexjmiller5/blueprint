local M = {}

local home = os.getenv("HOME")

M.hyperKeyMods = { "cmd", "alt", "ctrl", "shift" }

-- Application Bundle IDs
M.appBundleIds = {
  ghostty        = "com.mitchellh.ghostty",
  notes          = "com.apple.Notes",
  vscode         = "com.microsoft.VSCode",
  spotify        = "com.spotify.client",
  hammerspoon    = "org.hammerspoon.Hammerspoon",
  systemSettings = "com.apple.systempreferences",
  zoom           = "us.zoom.xos",
  slack          = "com.tinyspeck.slackmacgap",
  chrome         = "com.google.Chrome",
  finder         = "com.apple.finder",
}

M.paths = {
  searchClipTab       = home .. "/.hammerspoon/scripts/search-from-clipboard-in-new-tab.sh",
  searchClipWindow    = home .. "/.hammerspoon/scripts/search-from-clipboard-in-new-window.sh",
  searchClipIncognito = home .. "/.hammerspoon/scripts/search-incognito-from-clipboard.sh",
  hsConfig            = home .. "/.hammerspoon"
}

return M