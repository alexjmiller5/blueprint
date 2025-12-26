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

-- 1. Initialize empty master tables
local mergedGlobalHotkeys = {}
local mergedAppBasedHotkeys = {}

-- 1. Load Main Definitions
local sharedGlobalHotkeys = require("hotkeys.global").definitions
local sharedAppBasedHotkeys    = require("hotkeys.app-based").definitions

helpers.mergeAppBasedHotkeys(sharedAppBasedHotkeys, mergedGlobalHotkeys)
helpers.mergeGlobalHotkeys(sharedGlobalHotkeys, mergedAppBasedHotkeys)

local profileGlobalHotkeys = require("profile.hotkeys.global").definitions
local profileAppBasedHotkeys    = require("profile.hotkeys.app-based").definitions

helpers.mergeAppBasedHotkeys(profileAppBasedHotkeys, mergedGlobalHotkeys)
helpers.mergeGlobalHotkeys(profileGlobalHotkeys, mergedAppBasedHotkeys)

require("hotkeys.bind").init(mergedGlobalHotkeys, mergedApp)
require("profile.init")

-- Final confirmation message
hs.alert.show("Hammerspoon Config & Profile Reloaded!")