local constants = require("constants")

local M = {}

-- Attempts to select a menu item on the frontmost application.
-- Returns true on success, false on failure.
function M.tryMenuItem(menuPath)
  local frontApp = hs.application.frontmostApplication()
  if not frontApp then return false end

  return pcall(function()
    if not frontApp:selectMenuItem(menuPath) then
      error("Menu item not found or action failed.")
    end
  end)
end

return M