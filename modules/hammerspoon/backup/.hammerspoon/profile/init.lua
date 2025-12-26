local log = hs.logger.new("Profile", "debug")

-- 1. Load Profile-Specific Constants
-- (Only necessary if this file runs logic that needs them, but good for consistency)
require("profile.constants")

-- 2. Load Profile-Specific Helpers
require("profile.helpers")

require("profile.spoons")

log.i("Profile modules loaded.")