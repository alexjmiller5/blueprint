local constants = require("constants")
local helpers = require("helpers")
local driveModal = require("hotkeys.modal").driveModal

local M = {}

local actions = {
  -- App Launchers
  launchGmail = function()
    hs.application.launchOrFocusByBundleID(constants.appBundleIds.gmail)
  end,
  launchGoogleCalendar = function()
    hs.application.launchOrFocusByBundleID(constants.appBundleIds.googleCalendar)
  end,
  launchGoogleTasks = function()
    hs.application.launchOrFocusByBundleID(constants.appBundleIds.googleTasks)
  end,
  launchSlack = function()
    hs.application.launchOrFocusByBundleID(constants.appBundleIds.slack)
  end,
  launchGoogleDrive = function()
    hs.application.launchOrFocusByBundleID(constants.appBundleIds.googleDrive)
  end,
  openArtifactoryInVscode = function()
    hs.task.new("/usr/bin/open", nil, {"vscode://file/" .. constants.paths.artifactoryRepo .. "?windowId=_blank"}):start()
  end,
  clickMyDrive = function()
    hs.osascript.applescriptFromFile(constants.paths.clickMyDrive)
  end,
  openChromePasswords = function()
    hs.osascript.applescriptFromFile(constants.paths.openGooglePasswordsManager)
  end,
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
    action = actions.openDriveDesktop
  },
  {
    mods = {"alt", "shift"},
    key = "w",
    action = actions.openDriveDownloads
  },
  {
    mods = {"alt", "shift"},
    key = "e",
    action = actions.openDriveDocuments
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