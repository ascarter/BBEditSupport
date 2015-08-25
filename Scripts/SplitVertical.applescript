-- Emulate splitting a window vertically by opening the active document
-- in a new window and arranging both windows side by side

on run
    tell application "BBEdit"
        -- Calculate the bounds for target window
        -- bounds are left, top, right, bottom
        set b to bounds of text window 1
        set x1 to (item 3 of b) + 4
        set y1 to (item 2 of b)
        set x2 to x1 + ((item 3 of b) - (item 1 of b))
        set y2 to (item 4 of b)
    
        -- Adjust for file list if visible
        if files visible of text window 1 is true then
            set x2 to (x2 - 222)
        end if
    
        -- Create new window
        set tw to make new text window with properties {bounds:{x1, y1, x2, y2}}
        move document 1 of text window 2 to tw
    
        -- Cleanup
        set files visible of tw to false
        tell text document 2 of tw
            close without saving
        end tell
        select tw
    end tell
end run