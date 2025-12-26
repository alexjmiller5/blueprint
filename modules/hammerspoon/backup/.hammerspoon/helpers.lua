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
function M.mergeAppHotkeys(firstTable, secondTable)
    for bundleID, defs in pairs(firstTable) do
        if not secondTable[bundleID] then
            secondTable[bundleID] = {}
        end
        for _, def in ipairs(defs) do
            table.insert(secondTable[bundleID], def)
        end
    end
end

function M.mergeGlobalHotkeys(firstTable, secondTable)
  if not firstTable then return end
  for _, def in ipairs(firstTable) do
    table.insert(secondTable, def)
  end
end

return M