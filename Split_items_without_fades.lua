-- Note that this script is intended for use if you normally use automatic fades on splitting an item
-- If you use this script it will exit the script with automatic fades enabled, which you might not want!

function runScripty()
    
    --reaper.Main_OnCommand(actionCommandID, 0)
    local disableAutoCrossFadeOnSplit = 40928 -- scripted using Reaper v6.81
    local enableAutoCrossFadeOnSplit = 40927
    local splitItemAtCursor = 40196
    
    local integerFlag = 0
    local project = nil -- nil should give you the active project
    
    --reaper.Main_OnCommandEx(disableAutoCrossFadeOnSplit, integerFlag, project)
    --reaper.Main_OnCommandEx(splitItemAtCursor, integerFlag, project)
    --reaper.Main_OnCommandEx(enableAutoCrossFadeOnSplit, integerFlag, project)
    
    reaper.Main_OnCommand(enableAutoCrossFadeOnSplit, integerFlag)
    reaper.Main_OnCommand(splitItemAtCursor, integerFlag)
    reaper.Main_OnCommand(disableAutoCrossFadeOnSplit, integerFlag)
end

runScripty()
