-- Set up logging
log = hs.logger.new("Hammerspoon", "debug")

-- Activate the hammerspoon cli
require("hs.ipc")

-- Load the diagnostic key logger based on config
-- require("keylogger"):start()

local helpers = require("helpers")
local hotkeysHelpers = require("hotkeys.helpers")
local watchers = require("watchers")

local mergedGlobalHotkeys = {}
local mergedAppBasedHotkeys = {}

local sharedGlobalHotkeys = require("hotkeys.global").definitions
local sharedAppBasedHotkeys = require("hotkeys.app_based").definitions

helpers.mergeAppBasedHotkeys(sharedAppBasedHotkeys, mergedAppBasedHotkeys)
helpers.mergeGlobalHotkeys(sharedGlobalHotkeys, mergedGlobalHotkeys)

local profileName = "None"
local profileLoaded = false

local status, profileConstants = pcall(require, "profile.constants")

if status then
    profileLoaded = true
    profileName = profileConstants.profileName or "Unnamed Profile"
    log.i("✅ PROFILE FOUND: " .. profileName)

    local pInitStatus, profileInit = pcall(require, "profile.init")

    if pInitStatus then
        log.i(profileName .. " profile init.lua loaded successfully.")
    else
        log.e("Failed to load profile init.lua: " .. tostring(profileInit))
    end

    local pGlobalStatus, profileGlobal = pcall(require, "profile.hotkeys.global")

    if pGlobalStatus then
        helpers.mergeGlobalHotkeys(profileGlobal.definitions, mergedGlobalHotkeys)
    end

    local pAppStatus, profileApp = pcall(require, "profile.hotkeys.app_based")

    if pAppStatus then
        helpers.mergeAppBasedHotkeys(profileApp.definitions, mergedAppBasedHotkeys)
    end

else
    log.w("⚠️ NO PROFILE LOADED (Could not find profile/constants.lua)")
end

appSpecificHotkeys = {}
previousBundleID = nil

hotkeysHelpers.bindGlobalHotkeys(mergedGlobalHotkeys)
hotkeysHelpers.bindAppBasedHotkeys(mergedAppBasedHotkeys, appSpecificHotkeys)

appWatcher = watchers.startAppWatcher(previousBundleID, appSpecificHotkeys)

if profileLoaded then
    hs.alert.show("Hammerspoon: " .. profileName .. " Active")
else
    hs.alert.show("Hammerspoon: No Profile Active")
end