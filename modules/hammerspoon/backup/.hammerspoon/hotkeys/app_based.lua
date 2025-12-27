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
  [constants.appBundleIds.zoom] = {
    {mods = {"cmd"}, key = "u", action = actions.zoomToggleMute}
  },
  [constants.appBundleIds.slack] = {
    {mods = {"cmd"}, key = "\\", action = actions.slackToggleSidebar},
    {mods = {"cmd"}, key = "k", action = actions.slackSearch}
  },
  [constants.appBundleIds.spotify] = {
    {mods = {"cmd"}, key = "\\", action = actions.spotifyToggleSidebars},
  },
  [constants.appBundleIds.chrome] = {
    {mods = {"cmd"}, key = "d", action = actions.chromeDuplicateTab},
    {mods = {"cmd", "alt", "shift"}, key = "[", action = actions.chromeDuplicateAndGoBack},
    {mods = {"cmd"}, key = "b", action = actions.chromeBookmarkTab},
    {mods = {"cmd", "shift"}, key = "d", action = actions.chromeToggleDevTools},
  },
  [constants.appBundleIds.vscode] = {
    {mods = {"cmd"}, key = "d", action = actions.vscodeDuplicateFile},
    {mods = {"cmd", "shift"}, key = "r", action = actions.vscodeRenameSymbol}
  },
  [constants.appBundleIds.hammerspoon] = {
    {mods = {"cmd"}, key = "r", action = actions.hammerspoonReload},
  }
}

return M