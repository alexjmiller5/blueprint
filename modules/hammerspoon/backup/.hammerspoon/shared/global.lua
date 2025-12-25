local constants = require("constants")
local helpers = require("helpers")

local M = {}

local actions = {
  launchGhostty = function()
    hs.application.launchOrFocusByBundleID(constants.appBundleIds.ghostty)
  end,
  launchNotes = function()
    hs.application.launchOrFocusByBundleID(constants.appBundleIds.notes)
  end,
  launchVSCode = function()
    hs.application.launchOrFocusByBundleID(constants.appBundleIds.vscode)
  end,
  launchGemini = function()
    hs.application.launchOrFocusByBundleID(constants.appBundleIds.gemini)
  end,
  launchZoom = function()
    hs.application.launchOrFocusByBundleID(constants.appBundleIds.zoom)
  end,
  launchSpotify = function()
    hs.application.launchOrFocusByBundleID(constants.appBundleIds.spotify)
  end,
  launchYouTube = function()
    hs.application.launchOrFocusByBundleID(constants.appBundleIds.youtube)
  end,
  launchHammerspoon = function()
    hs.application.launchOrFocusByBundleID(constants.appBundleIds.hammerspoon)
  end,
  launchSlack = function()
    hs.application.launchOrFocusByBundleID(constants.appBundleIds.slack)
  end,
  launchSystemSettings = function()
    hs.application.launchOrFocusByBundleID(constants.appBundleIds.systemSettings)
  end,
  launchFinder = function()
    hs.osascript.applescript(
      'tell application "Finder" \n if not (exists window 1) then make new Finder window \n activate \n end tell'
    )
    end,
  
  -- Scripts
  searchClipTab = function()
    hs.task.new("/bin/sh", nil, { constants.paths.searchClipTab }):start()
  end,
  searchClipWindow = function()
    hs.task.new("/bin/sh", nil, { constants.paths.searchClipWindow }):start()
  end,
  searchClipIncognito = function()
    hs.task.new("/bin/sh", nil, { constants.paths.searchClipIncognito }):start()
  end,
  openHsConfigInVscode = function()
    hs.task.new("/usr/bin/open", nil, { "vscode://file/" .. constants.paths.hsConfig .. "?windowId=_blank" }):start()
  end,
  openDesktopFolder = function()
    hs.task.new("/usr/bin/open", nil, { constants.paths.desktopFolder }):start()
  end,
  openDownloadsFolder = function()
    hs.task.new("/usr/bin/open", nil, { constants.paths.downloadsFolder }):start()
  end,
  openDocumentsFolder = function()
    hs.task.new("/usr/bin/open", nil, { constants.paths.documentsFolder }):start()
  end,
  newIncognitoWindow = function()
    hs.osascript.applescript(
      'tell application "Google Chrome" to make new window with properties {mode:"incognito"} \n activate'
    )
  end,
  newChromeWindow = function()
    hs.osascript.applescript('tell application "Google Chrome" to make new window \n activate')
    hs.application.launchOrFocusByBundleID(constants.appBundleIds.chrome)
    end,
    forceQuitApp = function()
    os.execute(
      "kill -9 $(osascript -e 'tell application \"System Events\" to get unix id of first process whose frontmost is true and background only is false')"
    )
  end,

  -- Window Management
  windowCenter = function()
    -- Grid 1:4, start at index 1 (2nd col), span 2 cols. (Centered 50% width)
    hs.execute("/opt/homebrew/bin/yabai -m window --grid 1:4:1:0:2:1")
  end,

  windowLeft = function()
    -- Grid 1:2, start at 0, span 1 (Left Half)
    hs.execute("/opt/homebrew/bin/yabai -m window --grid 1:2:0:0:1:1")
  end,

  windowRight = function()
    if not helpers.tryMenuItem({ "Window", "Move & Resize", "Right" }) then
      -- Grid 1:2, start at 1, span 1 (Right Half)
      hs.execute("/opt/homebrew/bin/yabai -m window --grid 1:2:1:0:1:1")
    end
  end,

  windowMaximize = function()
    if not helpers.tryMenuItem({ "Window", "Fill" }) then
      -- Grid 1:1, full span (Maximize)
      hs.execute("/opt/homebrew/bin/yabai -m window --grid 1:1:0:0:1:1")
    end
  end,

  windowTopLeft = function()
    if not helpers.tryMenuItem({ "Window", "Move & Resize", "Top Left" }) then
      -- Grid 2:2, start 0,0 (Top Left Quarter)
      hs.execute("/opt/homebrew/bin/yabai -m window --grid 2:2:0:0:1:1")
    end
  end,

  windowBottomLeft = function()
    if not helpers.tryMenuItem({ "Window", "Move & Resize", "Bottom Left" }) then
      -- Grid 2:2, start 0,1 (Bottom Left Quarter)
      hs.execute("/opt/homebrew/bin/yabai -m window --grid 2:2:0:1:1:1")
    end
  end,

  windowTopRight = function()
    if not helpers.tryMenuItem({ "Window", "Move & Resize", "Top Right" }) then
      -- Grid 2:2, start 1,0 (Top Right Quarter)
      hs.execute("/opt/homebrew/bin/yabai -m window --grid 2:2:1:0:1:1")
    end
  end,

  windowBottomRight = function()
    if not helpers.tryMenuItem({ "Window", "Move & Resize", "Bottom Right" }) then
      -- Grid 2:2, start 1,1 (Bottom Right Quarter)
      hs.execute("/opt/homebrew/bin/yabai -m window --grid 2:2:1:1:1:1")
    end
  end,

  -- Native Hammerspoon
  reloadConfig = function()
    hs.reload()
  end,

}

-- Hotkey Definitions Table
M.definitions = {
  -- App Launchers
  {
    mods = { "alt" },
    key = "t",
    action = actions.launchGhostty
  },
  {
    mods = { "alt" },
    key = "n",
    action = actions.launchNotes
  },
  {
    mods = { "alt" },
    key = "v",
    action = actions.launchVSCode
  },
  {
    mods = { "alt" },
    key = "g",
    action = actions.launchGemini
  },
  {
    mods = { "alt" },
    key = "z",
    action = actions.launchZoom
  },
  {
    mods = { "alt" },
    key = "s",
    action = actions.launchSpotify
  },
  {
    mods = { "alt" },
    key = "y",
    action = actions.launchYouTube
  },
  {
    mods = { "alt" },
    key = "h",
    action = actions.launchHammerspoon
  },

  {
    mods = { "alt", "shift" },
    key = "h",
    action = actions.openHsConfigInVscode
  },
  {
    mods = { "alt", "shift" },
    key = "m",
    action = actions.launchSlack
  },
  {
    mods = { "alt", "shift" },
    key = "s",
    action = actions.launchSystemSettings
  },
  {
    mods = { "alt" },
    key = "f",
    action = actions.launchFinder
  },
  {
    mods = { "alt", "shift" },
    key = "d",
    action = actions.openDesktopFolder
  },
  {
    mods = { "alt", "shift" },
    key = "w",
    action = actions.openDownloadsFolder
  },
  {
    mods = { "alt", "shift" },
    key = "e",
    action = actions.openDocumentsFolder
  },
  {
    mods = { "alt", "shift" },
    key = "t",
    action = actions.searchClipTab
  },
  {
    mods = { "alt", "shift" },
    key = "b",
    action = actions.searchClipWindow
  },
  {
    mods = { "alt", "shift" },
    key = "i",
    action = actions.searchClipIncognito
  },
  {
    mods = { "alt" },
    key = "i",
    action = actions.newIncognitoWindow
  },
  {
    mods = { "alt" },
    key = "b",
    action = actions.newChromeWindow
  },
  {
    mods = { "cmd", "shift" },
    key = "/",
    action = actions.windowCenter
  },
  {
    mods = { "cmd", "shift" },
    key = ",",
    action = actions.windowLeft
  },
  {
    mods = { "cmd", "shift" },
    key = ".",
    action = actions.windowRight
  },
  {
    mods = { "cmd", "shift" },
    key = "m",
    action = actions.windowMaximize
  },
  {
    mods = { "cmd", "shift" },
    key = "j",
    action = actions.windowTopLeft
  },
  {
    mods = { "cmd", "shift" },
    key = "k",
    action = actions.windowBottomLeft
  },
  {
    mods = { "cmd", "shift" },
    key = "o",
    action = actions.windowTopRight
  },
  {
    mods = { "cmd", "shift" },
    key = "l",
    action = actions.windowBottomRight
  },
  {
    mods = { "cmd", "shift" },
    key = "q",
    action = actions.forceQuitApp
  },
  {
    mods = constants.hyperKeyMods,
    key = "h",
    action = actions.reloadConfig
  }
}

return M
