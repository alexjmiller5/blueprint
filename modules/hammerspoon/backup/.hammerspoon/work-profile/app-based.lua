local helpers = require("helpers")
local constants = require("constants")

local M = {}

local actions = {
  -- PWA Actions
  pwaCloseWindow = function()
    hs.eventtap.keyStroke({"cmd"}, "h")
  end,
  pwaDevTools = function()
    hs.eventtap.keyStroke({"cmd", "alt"}, "i")
  end,
  -- Application-Specific Actions
  zoomToggleMute = function()
    hs.eventtap.keyStroke({"cmd", "shift"}, "a")
  end,
  slackSearch = function()
    hs.eventtap.keyStroke({"cmd"}, "g")
    -- helpers.tryMenuItem({"Edit", "Search"})
  end,
  slackToggleSidebar = function()
    hs.eventtap.keyStroke({"cmd", "shift"}, "d")
  end,
  spotifyToggleSidebars = function()
    hs.eventtap.keyStroke({"alt", "shift"}, "l")
    hs.eventtap.keyStroke({"alt", "shift"}, "r")
  end,
  chromeDuplicateTab = function()
    helpers.tryMenuItem({"Tab", "Duplicate Tab"})
    helpers.tryMenuItem({"Tab", "Select Previous Tab"})
  end,
  chromeDuplicateAndGoBack = function()
    helpers.tryMenuItem({"Tab", "Duplicate Tab"})
    helpers.tryMenuItem({"History", "Back"})
  end,
  chromeBookmarkTab = function()
    helpers.tryMenuItem({"Bookmarks", "Bookmark This Tab..."})
  end,
  chromeToggleDevTools = function()
    helpers.tryMenuItem({"View", "Developer", "Developer Tools"})
  end,
  vscodeDuplicateFile = function()
    hs.eventtap.keyStroke({"cmd"}, "c")
    hs.eventtap.keyStroke({"cmd"}, "v")
  end,
  vscodeRenameSymbol = function()
    hs.eventtap.keyStroke({"fn"}, "f12")
  end,
  hammerspoonReload = function()
    hs.reload()
  end
}

M.definitions = {
  [constants.appBundleIds.googleTasks]    = { {mods = {"cmd"}, key = "w", action = actions.pwaCloseWindow}, {mods = {"cmd", "shift"}, key = "d", action = actions.pwaDevTools} },
  [constants.appBundleIds.googleCalendar] = { {mods = {"cmd"}, key = "w", action = actions.pwaCloseWindow}, {mods = {"cmd", "shift"}, key = "d", action = actions.pwaDevTools} },
  [constants.appBundleIds.gmail]          = { {mods = {"cmd"}, key = "w", action = actions.pwaCloseWindow}, {mods = {"cmd", "shift"}, key = "d", action = actions.pwaDevTools} },
  [constants.appBundleIds.googleDrive]    = { {mods = {"cmd"}, key = "w", action = actions.pwaCloseWindow}, {mods = {"cmd", "shift"}, key = "d", action = actions.pwaDevTools} },
}

return M