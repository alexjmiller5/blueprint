-- Set up logging
hs.logger.new("Hammerspoon", "debug")

-- Activate the hammerspoon cli
require("hs.ipc")

-- Load the diagnostic key logger based on config
-- require("keylogger"):start()

require("helpers")
require("constants")
require("spoons")
require("hotkeys.bind")

-- Final confirmation message
hs.alert.show("Hammerspoon Config Reloaded!")