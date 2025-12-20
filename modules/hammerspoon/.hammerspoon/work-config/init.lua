-- Set up logging
hs.logger.new("Hammerspoon", "debug")

-- Load core configuration files
local config = require("config")

-- Load the diagnostic key logger based on config
if config.enableKeyLogger then
  require("keylogger"):start()
end

-- Load the Hyper Key module based on config
if config.enableHyperKey then
  require("hotkeys.hyperkey"):start()
end

require("helpers")
require("constants")
require("spoons")
require("hotkeys.bind")

-- Final confirmation message
hs.alert.show("Hammerspoon Config Reloaded!")