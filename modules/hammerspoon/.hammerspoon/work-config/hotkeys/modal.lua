local constants = require("constants")
local helpers = require("helpers")

local M = {}

M.driveModal = hs.hotkey.modal.new()

-- Modal Actions

-- TODO: also check if google chrome is the frontmost application and if the front window / active tab is the script tab
-- TODO: This will prevent the script from running if the user is not on the correct tab or not on Google Chrome
local function action_createMeetingNotes()
  M.driveModal:exit()
  helpers.activateAppsScript("meeting-notes")
end

local function action_blankDocument()
  M.driveModal:exit()
  helpers.activateAppsScript("blank-document")
end

local function action_openDriveApp()
  M.driveModal:exit()
  hs.application.launchOrFocusByBundleID(constants.appBundleIds.googleDrive)
  hs.task.new("/usr/bin/osascript", nil, {constants.paths.clickMyDrive}):start()
end

local function action_openDriveSearch()
  M.driveModal:exit()
  hs.eventtap.keyStroke({"cmd", "alt"}, "g")
  M.driveModal:exit()
end

-- Write injected js via applescript to go to the correct tab based on the date
local function action_openWeekly1010Notes()
  M.driveModal:exit()
  os.execute("'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' --new-window " .. constants.Urls.weekly1010Nash .. " " .. constants.Urls.weekly1010Personal .. " >/dev/null 2>&1 &")
end

-- Write injected js via applescript to go to the correct tab based on the date
local function action_openDailyStandupNotes()
  M.driveModal:exit()
  os.execute("'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' --new-window " .. constants.Urls.dailyStandup .. " >/dev/null 2>&1 &")
end

-- Bind the actions to the hotkeys inside the modal
M.driveModal:bind({}, "m", action_createMeetingNotes) -- m = meeting notes
M.driveModal:bind({}, "n", action_openDriveApp) -- n = notion / documents
M.driveModal:bind({}, "k", action_openDriveSearch) -- k = search
M.driveModal:bind({}, "b", action_blankDocument) -- b = blank document
M.driveModal:bind({}, "t", action_openWeekly1010Notes) -- t = tenten
M.driveModal:bind({}, "d", action_openDailyStandupNotes) -- d = daily standup
M.driveModal:bind({}, "escape", function() M.driveModal:exit() end)

return M