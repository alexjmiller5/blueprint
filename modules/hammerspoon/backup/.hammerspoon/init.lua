-- Set up logging
log = hs.logger.new("Hammerspoon", "debug")

-- Activate the hammerspoon cli
require("hs.ipc")

-- Load the diagnostic key logger based on config
-- require("keylogger"):start()


-- Load Core
local helpers = require("helpers")
require("constants")
require("spoons")

-- --- DATA LOADING & MERGING ---

-- 1. Load Main Definitions
local mainGlobal = require("hotkeys.global").definitions
local mainApp    = require("hotkeys.app-based").definitions

-- 2. Load Profile Definitions
-- We use pcall just in case the profile files have syntax errors,
-- but we assume the files exist based on your structure.
local profileGlobal = require("profile.hotkeys.global").definitions
local profileApp    = require("profile.hotkeys.app-based").definitions

-- 3. Merge Global Hotkeys (Array Merge)
local mergedGlobal = {}
for _, v in ipairs(mainGlobal) do table.insert(mergedGlobal, v) end
for _, v in ipairs(profileGlobal) do table.insert(mergedGlobal, v) end

-- 4. Merge App-Based Hotkeys (Map Merge with List Concatenation)
local mergedApp = {}

helpers.copyAppDefs(mainApp)
helpers.copyAppDefs(profileApp)

require("hotkeys.bind").init(mergedGlobal, mergedApp)
require("profile.init")

-- Final confirmation message
hs.alert.show("Hammerspoon Config & Profile Reloaded!")