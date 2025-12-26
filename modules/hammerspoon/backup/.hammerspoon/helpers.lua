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

-- Copy app definitions from one table to another
function M.copyAppDefs(sourceTable)
  for bundleID, defs in pairs(sourceTable) do
    if not mergedApp[bundleID] then
      mergedApp[bundleID] = {}
    end
    for _, def in ipairs(defs) do
      table.insert(mergedApp[bundleID], def)
    end
  end
end

return M