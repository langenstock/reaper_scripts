

local SPACING_FACTOR = 1

function initialCheck()
    local initialSelectedItemscount = reaper.CountSelectedMediaItems(0)

    if initialSelectedItemscount < 2 then
        reaper.ShowMessageBox("Select at least 2 clips, dipshit.", "Error", 0)
        return false
    end
    return true
end

function getSpacingValueFromUser()
    -- Get user input using reaper.GetUserInputs
    local retval, userInput = reaper.GetUserInputs("Grid-like Start Positions", 1, "Interval of Start Points:", "")
    if retval then
        local numericValue = tonumber(userInput)
        if numericValue then
            SPACING_FACTOR = numericValue
            return true
        else
            reaper.ShowConsoleMsg("Invalid input. Please enter a number.\n")
            return false
        end
    else
        reaper.ShowConsoleMsg("User canceled the input.\n")
        return false
    end
end

function spaceOutSelectedItems()

    -- Get the selected items
    selectedItems = reaper.CountSelectedMediaItems(0)
    
    -- Check if there are at least two items selected
    if selectedItems < 2 then
        reaper.ShowMessageBox("Please select at least two items to space out.", "Error", 0)
        return
    end
    
    local firstItem = reaper.GetSelectedMediaItem(0, 0)
    local firstItemPos = reaper.GetMediaItemInfo_Value(firstItem, "D_POSITION")

    previousClipEndPos = math.huge
    
    
    for i = 0, selectedItems - 1 do
        local item = reaper.GetSelectedMediaItem(0, i)
        local currentPosition = reaper.GetMediaItemInfo_Value(item, "D_POSITION")

        local currentItemsLength = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")

        local positionToMoveTo = firstItemPos + (SPACING_FACTOR * i)

        local msg = 'previousPos: '..currentPosition..' , moving to: '..positionToMoveTo .. ' , previousClipEndPos: '..previousClipEndPos
        -- reaper.ShowMessageBox(msg, "Error", 0)        
        reaper.SetMediaItemInfo_Value(item, "D_POSITION", positionToMoveTo)
        
        previousClipEndPos = positionToMoveTo + currentItemsLength
    end
    

    reaper.UpdateArrange()
end

function someItemBoundariesAreTouching()
    local clipsTable = {}
    for i = 0, selectedItems - 1 do
        local item = reaper.GetSelectedMediaItem(0, i)
        local startPos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        local endPos = startPos + length
        local entry = { item = item, startPos = startPos, length = length, endPos = endPos }
        table.insert(clipsTable, entry)
    end
    
    for i, item in ipairs(clipsTable) do
        for j, clip in ipairs(clipsTable) do
            if item.startPos == clip.endPos then
                return true
            end
        end
    end
    
    return true
end

function main()
    if initialCheck() then
        reaper.Undo_BeginBlock()
        
        if getSpacingValueFromUser() == true then
            for i = 1, 10 do
                spaceOutSelectedItems()
            end
        end
    end
    reaper.Undo_EndBlock("Space Out Selected Items", -1)
end

-- Run main
main()



