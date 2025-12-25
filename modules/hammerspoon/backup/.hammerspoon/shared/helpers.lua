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

function M.activateAppsScript(scriptPath)
  os.execute("'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' --new-window " .. constants.Urls.appsScript .. " " .. "?type=" .. scriptPath .. " " .. ">/dev/null 2>&1 &")
end

local function checkLoading()
  local success, isLoading = hs.osascript.applescript('tell application "Google Chrome" to return loading of active tab of front window')
  if isLoading == false then
     hs.timer.doAfter(0.1, function()
       M.tryMenuItem({"Edit", "Select All"})
       hs.timer.doAfter(0.1, function()
         M.tryMenuItem({"Edit", "Copy"})
         hs.timer.doAfter(0.1, function()
           local newDocUrl = hs.pasteboard.getContents()
           if newDocUrl and newDocUrl:find("https://docs.google.com/") then
             hs.osascript.applescript('tell application "Google Chrome" to set URL of active tab of front window to "' .. newDocUrl .. '"')
           end
         end)
       end)
     end)
  else
    hs.timer.doAfter(0.1, checkLoading)
  end
end

hs.timer.doAfter(4, checkLoading)
M.driveModal:exit()
end

return M