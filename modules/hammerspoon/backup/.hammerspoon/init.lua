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
local sharedGlobalHotkeys = require("hotkeys.global").definitions
local sharedAppBasedHotkeys    = require("hotkeys.app-based").definitions

local profileGlobalHotkeys = require("profile.hotkeys.global").definitions
local profileAppBasedHotkeys    = require("profile.hotkeys.app-based").definitions

-- 4. Merge App-Based Hotkeys (Map Merge with List Concatenation)

helpers.mergeAppBasedHotkeys(, profileAppHotkeys)
helpers.mergeGlobalHotkeys(, mergedApp)

require("hotkeys.bind").init(mergedGlobal, mergedApp)
require("profile.init")

-- Final confirmation message
hs.alert.show("Hammerspoon Config & Profile Reloaded!")