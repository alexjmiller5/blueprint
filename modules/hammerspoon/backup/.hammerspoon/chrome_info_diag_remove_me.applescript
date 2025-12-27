-- Create an empty string to hold all the information.
set allWindowInfo to ""

tell application "Google Chrome"
    -- First, check if there are any windows open at all.
    if (count of windows) is 0 then
        return "No Google Chrome windows are open."
    end if

    -- Loop through every window that's currently open.
    repeat with theWindow in every window
        -- Add this window's main details to our string.
        set allWindowInfo to allWindowInfo & "## WINDOW (" & (index of theWindow) & ") ##" & linefeed
        set allWindowInfo to allWindowInfo & "ID: " & (id of theWindow) & linefeed
        set allWindowInfo to allWindowInfo & "Title: " & (title of theWindow) & linefeed
        set allWindowInfo to allWindowInfo & "Mode: " & (mode of theWindow) & linefeed
        set allWindowInfo to allWindowInfo & "Bounds (Position/Size): " & (bounds of theWindow as text) & linefeed
        set allWindowInfo to allWindowInfo & "Visible: " & (visible of theWindow) & linefeed & linefeed

        set allWindowInfo to allWindowInfo & "    --- Tabs ---" & linefeed

        -- Now, loop through every tab inside the current window.
        repeat with theTab in every tab of theWindow
            set allWindowInfo to allWindowInfo & "    - URL: " & (URL of theTab) & linefeed
            set allWindowInfo to allWindowInfo & "      Title: " & (title of theTab) & linefeed
        end repeat

        -- Add a separator for readability before the next window.
        set allWindowInfo to allWindowInfo & "--------------------------------" & linefeed & linefeed
    end repeat
end tell

-- Print the final string to the Script Editor's log console.
log allWindowInfo