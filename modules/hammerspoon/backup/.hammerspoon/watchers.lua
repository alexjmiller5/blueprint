local hotkeysHelpers = require("hotkeys.helpers")
local M = {}

function M.startAppWatcher(previousBundleID, appSpecificHotkeys)
  local appWatcher = hs.application.watcher.new(function(appName, eventType, appObject)
    if eventType == hs.application.watcher.activated then
      previousBundleID = hotkeysHelpers.updateAppHotkeys(
        appObject,
        appSpecificHotkeys,
        previousBundleID
      )
    end
  end)

  appWatcher:start()
  return appWatcher
end

function M.start

return M