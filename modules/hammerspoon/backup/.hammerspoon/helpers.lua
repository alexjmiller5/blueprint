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

function M.mergeGlobalHotkeys(source, destination)
  if type(source) ~= "table" then return end
  if type(destination) ~= "table" then
    log.e("mergeGlobalHotkeys: Destination is not a table")
    return
  end

  for _, def in ipairs(source) do
    table.insert(destination, def)
  end
end

function M.mergeAppBasedHotkeys(source, destination)
  if type(source) ~= "table" then return end
  if type(destination) ~= "table" then 
    log.e("mergeAppHotkeys: Destination is not a table")
    return 
  end

  for bundleID, defs in pairs(source) do
    if not destination[bundleID] then
      destination[bundleID] = {}
    end

    if type(defs) == "table" then
      for _, def in ipairs(defs) do
        table.insert(destination[bundleID], def)
      end
    end
  end
end

return M