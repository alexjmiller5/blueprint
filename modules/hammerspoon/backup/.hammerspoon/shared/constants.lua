local M = {}
M.hyperKeyMods = {"cmd", "alt", "ctrl", "shift"}

-- Application Bundle IDs
M.appBundleIds = {
  ghostty         = "com.mitchellh.ghostty",
  notes           = "com.apple.Notes",
  vscode          = "com.microsoft.VSCode",
  spotify         = "com.spotify.client",
  hammerspoon     = "org.hammerspoon.Hammerspoon",
  systemSettings  = "com.apple.systempreferences",
  zoom            = "us.zoom.xos",
  slack           = "com.tinyspeck.slackmacgap",
  chrome          = "com.google.Chrome",
}

M.paths = {
  searchClipTab                 = M.home .. "/.local/bin/search-from-clipboard-in-new-tab.sh",
  searchClipWindow              = M.home .. "/.local/bin/search-from-clipboard-in-new-window.sh",
  searchClipIncognito           = M.home .. "/.local/bin/search-incognito-from-clipboard.sh",
  hsConfig                      = M.home .. "/.hammerspoon",
  artifactoryRepo               = M.home .. "/Library/CloudStorage/GoogleDrive-alexander.miller@capitalone.com/My Drive/Desktop/repos/Artifactory-Artifactory",
  driveDesktop                  = M.home .. "/Library/CloudStorage/GoogleDrive-alexander.miller@capitalone.com/My Drive/Desktop",
  driveDownloads                = M.home .. "/Library/CloudStorage/GoogleDrive-alexander.miller@capitalone.com/My Drive/Downloads",
  driveDocuments                = M.home .. "/Library/CloudStorage/GoogleDrive-alexander.miller@capitalone.com/My Drive/Documents",
}

return M