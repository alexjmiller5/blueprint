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
}

M.definitions = {
  [constants.appBundleIds.googleTasks]    = { {mods = {"cmd"}, key = "w", action = actions.pwaCloseWindow}, {mods = {"cmd", "shift"}, key = "d", action = actions.pwaDevTools} },
  [constants.appBundleIds.googleCalendar] = { {mods = {"cmd"}, key = "w", action = actions.pwaCloseWindow}, {mods = {"cmd", "shift"}, key = "d", action = actions.pwaDevTools} },
  [constants.appBundleIds.gmail]          = { {mods = {"cmd"}, key = "w", action = actions.pwaCloseWindow}, {mods = {"cmd", "shift"}, key = "d", action = actions.pwaDevTools} },
  [constants.appBundleIds.googleDrive]    = { {mods = {"cmd"}, key = "w", action = actions.pwaCloseWindow}, {mods = {"cmd", "shift"}, key = "d", action = actions.pwaDevTools} },
}

return M