local updateHotkeyStates(app)
  log = hs.logger.new("Logger", "debug")

local globalHotkeys = require("hotkeys.global").definitions
local appHotkeys = require("hotkeys.app-based").definitions

-- Bind all global hotkeys
for _, hotkey in ipairs(globalHotkeys) do
  hs.hotkey.bind(hotkey.mods, hotkey.key, hotkey.action)
end

-- Bind all application-specific hotkeys
local appSpecificHotkeys = {}
local previousBundleID = nil

-- Create hotkey objects (initially disabled)
for bundleID, definitions in pairs(appHotkeys) do
  appSpecificHotkeys[bundleID] = {}
  for _, definition in ipairs(definitions) do
    local hotkey = hs.hotkey.new(definition.mods, definition.key, definition.action)
    table.insert(appSpecificHotkeys[bundleID], hotkey)
  end
end

-- Function to enable/disable hotkeys based on the frontmost app
local function updateHotkeyStates(app)
  local newBundleID = app and app:bundleID() or nil
  if newBundleID == previousBundleID then return end

  -- Disable hotkeys for the old app
  if previousBundleID and appSpecificHotkeys[previousBundleID] then
    for _, hotkey in ipairs(appSpecificHotkeys[previousBundleID]) do
      hotkey:disable()
    end
  end

  -- Enable hotkeys for the new app
  if newBundleID and appSpecificHotkeys[newBundleID] then
    for _, hotkey in ipairs(appSpecificHotkeys[newBundleID]) do
      hotkey:enable()
    end
  end

  previousBundleID = newBundleID
end

-- Create a watcher to track application changes and update hotkey states
-- This must be global otherwise it will get cleaned up by the Lua garbage collector
appWatcher = hs.application.watcher.new(function(appName, eventType, app)
  if eventType == hs.application.watcher.activated then
    updateHotkeyStates(app)
  end
end)

-- Start the watcher and set initial state
appWatcher:start()
updateHotkeyStates(hs.application.frontmostApplication())

log.i("Hotkeys bound!")