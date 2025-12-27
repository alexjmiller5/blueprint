local M = {}
local log = hs.logger.new("Helpers", "debug")

function M.bindGlobalHotkeys(globalDefs)
  log.i("Binding " .. #globalDefs .. " global hotkeys.")

  for _, hotkey in ipairs(globalDefs) do
    hs.hotkey.bind(hotkey.mods, hotkey.key, hotkey.action)
  end
end

function M.bindAppBasedHotkeys(appDefs, hotkeyStorage)
  for bundleID, definitions in pairs(appDefs) do
    if not hotkeyStorage[bundleID] then
      hotkeyStorage[bundleID] = {}
    end

    for _, definition in ipairs(definitions) do
      local hk = hs.hotkey.new(definition.mods, definition.key, definition.action)
      table.insert(hotkeyStorage[bundleID], hk)
    end
  end
end

function M.updateAppHotkeys(app, hotkeyStorage, previousBundleID)
  local newBundleID = app and app:bundleID() or nil
  
  if newBundleID == previousBundleID then 
    return previousBundleID 
  end

  if previousBundleID and hotkeyStorage[previousBundleID] then
    for _, hk in ipairs(hotkeyStorage[previousBundleID]) do
      hk:disable()
    end
  end

  if newBundleID and hotkeyStorage[newBundleID] then
    for _, hk in ipairs(hotkeyStorage[newBundleID]) do
      hk:enable()
    end
  end

  return newBundleID
end

return M