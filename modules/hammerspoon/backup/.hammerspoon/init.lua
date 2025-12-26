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

-- 1. Initialize empty tables
local mergedGlobalHotkeys = {}
local mergedAppBasedHotkeys = {}

-- 2. Load SHARED (Main) Hotkeys
local sharedGlobalHotkeys = require("hotkeys.global").definitions
local sharedAppBasedHotkeys = require("hotkeys.app-based").definitions

-- FIX: Merge Shared App -> Merged App (was merging into Global)
helpers.mergeAppBasedHotkeys(sharedAppBasedHotkeys, mergedAppBasedHotkeys)
-- FIX: Merge Shared Global -> Merged Global (was merging into App)
helpers.mergeGlobalHotkeys(sharedGlobalHotkeys, mergedGlobalHotkeys)

-- 3. Load PROFILE Hotkeys (Safely)
local profileName = "None"
local profileLoaded = false

-- We use pcall (protected call) to try loading the profile constants first
-- This prevents a crash if the 'profile' folder is empty or missing
local status, profileConsts = pcall(require, "profile.constants")

if status then
    profileLoaded = true
    -- Check if you added a name field to your constants, otherwise use default
    profileName = profileConsts.profileName or "Unnamed Profile"
    log.i("✅ PROFILE FOUND: " .. profileName)

    -- Load Profile Definitions
    -- We assume if constants exist, these likely exist too, but pcall is safer
    local pGlobalStatus, profileGlobal = pcall(require, "profile.hotkeys.global")
    local pAppStatus, profileApp = pcall(require, "profile.hotkeys.app-based")

    if pGlobalStatus then
        helpers.mergeGlobalHotkeys(profileGlobal.definitions, mergedGlobalHotkeys)
    end
    
    if pAppStatus then
        helpers.mergeAppBasedHotkeys(profileApp.definitions, mergedAppBasedHotkeys)
    end

    -- Run Profile Init
    pcall(require, "profile.init")
else
    log.w("⚠️ NO PROFILE LOADED (Could not find profile/constants.lua)")
end

-- 4. Bind Everything
require("hotkeys.bind").init(mergedGlobalHotkeys, mergedAppBasedHotkeys)

-- Final confirmation message
if profileLoaded then
    hs.alert.show("Hammerspoon: " .. profileName .. " Active")
else
    hs.alert.show("Hammerspoon: No Profile Active")
end