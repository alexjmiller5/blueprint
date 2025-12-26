local M = {}
local log = hs.logger.new("Binder", "debug")

-- Store the watcher globally so it doesn't get garbage collected
M.appWatcher = nil

function M.bind(globalDefs, appDefs)
  log.i("Binding " .. #globalDefs .. " global hotkeys.")

  -- 1. Bind all global hotkeys
  for _, hotkey in ipairs(globalDefs) do
    hs.hotkey.bind(hotkey.mods, hotkey.key, hotkey.action)
  end

  -- 2. Prepare Application Specific Hotkeys
  local appSpecificHotkeys = {}
  local previousBundleID = nil

  -- Create hotkey objects (initially disabled)
  for bundleID, definitions in pairs(appDefs) do
    if not appSpecificHotkeys[bundleID] then
      appSpecificHotkeys[bundleID] = {}
    end
    
    for _, definition in ipairs(definitions) do
      local hk = hs.hotkey.new(definition.mods, definition.key, definition.action)
      table.insert(appSpecificHotkeys[bundleID], hk)
    end
  end

  -- Function to enable/disable hotkeys based on the frontmost app
  local function updateHotkeyStates(app)
    local newBundleID = app and app:bundleID() or nil
    if newBundleID == previousBundleID then return end

    -- Disable hotkeys for the old app
    if previousBundleID and appSpecificHotkeys[previousBundleID] then
      for _, hk in ipairs(appSpecificHotkeys[previousBundleID]) do
        hk:disable()
      end
    end

    -- Enable hotkeys for the new app
    if newBundleID and appSpecificHotkeys[newBundleID] then
      for _, hk in ipairs(appSpecificHotkeys[newBundleID]) do
        hk:enable()
      end
    end

    previousBundleID = newBundleID
  end

  -- 3. Start the Watcher
  M.appWatcher = hs.application.watcher.new(function(appName, eventType, app)
    if eventType == hs.application.watcher.activated then
      updateHotkeyStates(app)
    end
  end)

  M.appWatcher:start()
  updateHotkeyStates(hs.application.frontmostApplication())
  
  log.i("All hotkeys bound successfully.")
end

return M