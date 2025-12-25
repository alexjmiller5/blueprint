local M = {}

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
  searchClipTab       = M.home .. "/.local/bin/search-from-clipboard-in-new-tab.sh",
  searchClipWindow    = M.home .. "/.local/bin/search-from-clipboard-in-new-window.sh",
  searchClipIncognito = M.home .. "/.local/bin/search-incognito-from-clipboard.sh",
  hsConfig            = M.home .. "/.hammerspoon"
}

return M
