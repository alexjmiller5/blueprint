local constants = require("constants")
local helpers = require("helpers")

local M = {}

local actions = {
  -- App Launchers
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

  -- Other Launchers
  searchClipTab = function()
    hs.task.new("/bin/sh", nil, {constants.paths.searchClipTab}):start()
  end,
  searchClipWindow = function()
    hs.task.new("/bin/sh", nil, {constants.paths.searchClipWindow}):start()
  end,
  searchClipIncognito = function()
    hs.task.new("/bin/sh", nil, {constants.paths.searchClipIncognito}):start()
  end,
  openHsConfigInVscode = function()
    hs.task.new("/usr/bin/open", nil, {"vscode://file/" .. constants.paths.hsConfig .. "?windowId=_blank"}):start()
  end,
  openDesktopFolder = function()
    hs.task.new("/usr/bin/open", nil, {constants.paths.driveDesktop}):start()
  end,
  openDownloadsFolder = function()
    hs.task.new("/usr/bin/open", nil, {constants.paths.driveDownloads}):start()
  end,
  openDocumentsFolder = function()
    hs.task.new("/usr/bin/open", nil, {constants.paths.driveDocuments}):start()
  end,
  newIncognitoWindow = function()
    hs.osascript.applescript(
      'tell application "Google Chrome" to make new window with properties {mode:"incognito"} \n activate'
    )
  end,
  newFinderWindow = function()
    hs.osascript.applescript(
      'tell application "Finder" \n if not (exists window 1) then make new Finder window \n activate \n end tell'
    )
  end,
  newChromeWindow = function()
    hs.osascript.applescript('tell application "Google Chrome" to make new window \n activate')
    hs.application.launchOrFocusByBundleID(constants.appBundleIds.chrome)
  end,
  clickMyDrive = function()
    hs.osascript.applescriptFromFile(constants.paths.clickMyDrive)
  end,
  openChromePasswords = function()
    hs.osascript.applescriptFromFile(constants.paths.openGooglePasswordsManager)
  end,
  -- Window Management
  windowCenter = function()
    hs.execute("open -g 'rectangle://execute-action?name=center-half'")
  end,
  windowLeft = function()
    hs.execute("open -g 'rectangle://execute-action?name=left-half'")
  end,
  windowRight = function()
    if not helpers.tryMenuItem({"Window", "Move & Resize", "Right"}) then
      hs.execute("open -g 'rectangle://execute-action?name=right-half'")
    end
  end,
  windowMaximize = function()
    if not helpers.tryMenuItem({"Window", "Fill"}) then
      hs.execute("open -g 'rectangle://execute-action?name=maximize'")
    end
  end,
  windowTopLeft = function()
    hs.execute("open -g 'rectangle://execute-action?name=top-left'")
  end,
  windowBottomLeft = function()
    hs.execute("open -g 'rectangle://execute-action?name=bottom-left'")
  end,
  windowTopRight = function()
    hs.execute("open -g 'rectangle://execute-action?name=top-right'")
  end,
  windowBottomRight = function()
    hs.execute("open -g 'rectangle://execute-action?name=bottom-right'")
  end,

  -- System/Misc
  forceQuitApp = function()
    os.execute(
      "kill -9 $(osascript -e 'tell application \"System Events\" to get unix id of first process whose frontmost is true and background only is false')"
    )
  end,
  reloadConfig = function()
    hs.reload()
  end,
  enterDriveModal = function()
    driveModal:enter()
  end
}

-- Hotkey Definitions Table
-- This is now much cleaner and easier to read!
M.definitions = {
  {
    mods = {"alt"},
    key = "t",
    action = actions.launchGhostty
  },
  {
    mods = {"alt"},
    key = "n",
    action = actions.launchNotes
  },
  {
    mods = {"alt"},
    key = "m",
    action = actions.launchGmail
  },
  {
    mods = {"alt"},
    key = "c",
    action = actions.launchGoogleCalendar
  },
  {
    mods = {"alt"},
    key = "v",
    action = actions.launchVSCode
  },
  {
    mods = {"alt"},
    key = "g",
    action = actions.launchGemini
  },
  {
    mods = {"alt"},
    key = "h",
    action = actions.launchGoogleDrive
  },
  {
    mods = {"alt"},
    key = "z",
    action = actions.launchZoom
  },
  {
    mods = {"alt"},
    key = "s",
    action = actions.launchSpotify
  },
  {
    mods = {"alt"},
    key = "y",
    action = actions.launchYouTube
  },
  {
    mods = {"alt"},
    key = "h",
    action = actions.launchHammerspoon
  },
  {
    mods = {"alt"},
    key = "l",
    action = actions.openChromePasswords
  },
  {
    mods = {"alt", "shift"},
    key = "h",
    action = actions.openHsConfigInVscode
  },
  {
    mods = {"alt", "shift"},
    key = "n",
    action = actions.launchGoogleTasks
  },
  {
    mods = {"alt", "shift"},
    key = "m",
    action = actions.launchSlack
  },
  {
    mods = {"alt", "shift"},
    key = "s",
    action = actions.launchSystemSettings
  },
  {
    mods = {"alt", "shift"},
    key = "d",
    action = actions.openDesktopFolder
  },
  {
    mods = {"alt", "shift"},
    key = "w",
    action = actions.openDownloadsFolder
  },
  {
    mods = {"alt", "shift"},
    key = "e",
    action = actions.openDocumentsFolder
  },
  {
    mods = {"alt", "shift"},
    key = "t",
    action = actions.searchClipTab
  },
  {
    mods = {"alt", "shift"},
    key = "b",
    action = actions.searchClipWindow
  },
  {
    mods = {"alt", "shift"},
    key = "i",
    action = actions.searchClipIncognito
  },
  {
    mods = {"alt"},
    key = "i",
    action = actions.newIncognitoWindow
  },
  {
    mods = {"alt"},
    key = "f",
    action = actions.newFinderWindow
  },
  {
    mods = {"alt"},
    key = "b",
    action = actions.newChromeWindow
  },
  {
    mods = {"cmd", "shift"},
    key = "/",
    action = actions.windowCenter
  },
  {
    mods = {"cmd", "shift"},
    key = ",",
    action = actions.windowLeft
  },
  {
    mods = {"cmd", "shift"},
    key = ".",
    action = actions.windowRight
  },
  {
    mods = {"cmd", "shift"},
    key = "m",
    action = actions.windowMaximize
  },
  {
    mods = {"cmd", "shift"},
    key = "j",
    action = actions.windowTopLeft
  },
  {
    mods = {"cmd", "shift"},
    key = "k",
    action = actions.windowBottomLeft
  },
  {
    mods = {"cmd", "shift"},
    key = "o",
    action = actions.windowTopRight
  },
  {
    mods = {"cmd", "shift"},
    key = "l",
    action = actions.windowBottomRight
  },
  {
    mods = {"cmd", "shift"},
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