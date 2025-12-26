
local soundPath = "/Users/alexmiller/Documents/icons-and-sound-bites/sound-bites/Mario Waow.mp3"
local powerConnectedSound = hs.sound.getByFile(soundPath)

powerConnectedSound:device("BuiltInSpeakerDevice")

-- Check to make sure the sound was correctly loaded
if not powerConnectedSound then
  log.i("Sound file not found at: " .. soundPath)
  hs.alert.show("Error: Sound file not found at " .. soundPath)
  return -- Stop the script if the sound can't be found
end



local previousPowerSource = hs.battery.powerSource()

-- Play the sound if the power adapter is connected
local function powerStateChanged()
  local currentPowerSource = hs.battery.powerSource()

  -- Display the current power source in a pop-up alert
  -- log.i("Current Power source: " .. currentPowerSource .. "\nPrevious Power source: " .. previousPowerSource)
  if currentPowerSource == "AC Power" and previousPowerSource == "Battery Power" then
    powerConnectedSound:play()
  end

  previousPowerSource = currentPowerSource
end

-- Create and start the watcher
local powerWatcher = hs.battery.watcher.new(powerStateChanged)
powerWatcher:start()

--- Attempts to select a menu item on the frontmost application.
-- @param menuPath A table of strings representing the menu path.
-- @return boolean - True on success, false on failure.
local function tryMenuItem(menuPath)
  local frontApp = hs.application.frontmostApplication()
  if not frontApp then return false end

  -- pcall returns `true` if the function runs without error, `false` otherwise.
  return pcall(function()
    if not frontApp:selectMenuItem(menuPath) then
      error("Menu item not found or action failed.")
    end
  end)
end

-- Hotkey: Cmd + shift + l = Launch Home Assistant webhook to toggle lights
hs.hotkey.bind({ "cmd", "shift" }, "l", function()
  os.execute("curl -X POST http://home-assistant:8123/api/webhook/-yUrGzgTyzR953PAr3ndMGQaD")
end)

hs.hotkey.bind({ "alt", "shift" }, "h", function()
  os.execute("/usr/bin/open 'vscode://file/Users/alexmiller/.hammerspoon?windowId=_blank'")
end)

hs.hotkey.bind({ "cmd", "alt", "shift" }, "h", function()
  os.execute("/usr/bin/open 'vscode://vscode-remote/ssh-remote+home-assistant-tailscale/homeassistant?windowId=_blank'")
end)

hs.hotkey.bind({ "cmd", "shift" }, "i", function()
  tryMenuItem({ "Edit", "Copy Link to Current Page" })
  hs.timer.usleep(100000)
  local url = hs.pasteboard.getContents()
  if not url then return end
  local clean_path = url:gsub("?.*", "")
  local id = clean_path:sub(-32)
  if id:match("^[a-fA-F0-9]+$") then
    -- hs.alert.show("Notion ID Extracted:\n" .. id)
    hs.timer.usleep(100000)
    hs.pasteboard.setContents(id)
  else
    hs.alert.show("No valid Notion ID found in clipboard")
  end
end)

hs.hotkey.bind({ "cmd", "shift" }, "l", function()
  os.execute("/usr/bin/open 'raycast://extensions/moored/git-repos/list'")
end)


hs.hotkey.bind({"cmd"}, "\\", function()
  log:d("------------------------------------------")
  log:d("Hotkey Triggered: Cmd + /")

  -- 1. Source of Truth: Hammerspoon gets the focused window details
  local focusedWindow = hs.window.focusedWindow()
  
  if not focusedWindow then 
    log:w("Aborting: No window is currently focused.")
    return 
  end
  
  local appName = focusedWindow:application():name()
  local targetTitle = focusedWindow:title()
  
  log:d(string.format("Focused App: '%s'", appName))
  log:d(string.format("Target Window Title: '%s'", targetTitle))
  
  -- Check if the focused app is correct (Gemini PWA or Chrome)
  if appName == "Gemini" or appName == "Google Chrome" then
    log:i("App Context Verified. Preparing injection...")
    
    -- 2. The JS Payload (Runs INSIDE the browser)
    local jsPayload = [[
        // TEST ALERT: Remove this line when satisfied
        alert("Hammerspoon Target Locked: " + document.title + "\nClicking Side Nav...");

        var btn = document.querySelector('[data-test-id="side-nav-menu-button"]');
        
        if (btn) { 
          btn.click(); 
          "Success: Button Clicked"; 
        } else {
          "Error: Button selector [data-test-id] not found";
        }
    ]]

    -- 3. The JXA Control Script (Runs in macOS to find the window)
    -- We pass 'targetTitle' to ensure we only run on the window Hammerspoon sees
    local controlScript = string.format([[
      var chrome = Application('Google Chrome');
      var wins = chrome.windows();
      var result = "JXA Error: No window found with title matching: " + "%s";
      var searchTitle = "%s";

      // Loop through Chrome windows to find the specific one we are looking at
      for (var i = 0; i < wins.length; i++) {
        var win = wins[i];
        var winName = win.name();
        
        // LOGIC: Check if JXA window name matches Hammerspoon window title
        if (winName === searchTitle) {
            // Found specific window, execute JS
            result = win.activeTab.execute({ javascript: `%s` });
            break;
        }
      }
      result;
    ]], targetTitle, targetTitle, jsPayload)

    -- 4. Execute
    log:d("Sending JXA payload...")
    local status, result, raw = hs.osascript.javascript(controlScript)
    
    -- 5. Log Results
    if status then
      log:i("JXA Completed. Browser Returned: " .. (result or "nil"))
    else
      log:e("JXA Failed.")
      if raw and raw.NSLocalizedDescription then
        log:e("System Error: " .. raw.NSLocalizedDescription)
      end
    end

  else
    log:d("Ignored: Focused app (".. appName ..") is not Gemini/Chrome.")
  end
end)