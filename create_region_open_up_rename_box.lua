-- A script to prompt you for a name when creating a region
-- Highlight the items for which you want to create a region around and run the script

function main()
    local itemCount = reaper.CountSelectedMediaItems(project)
    
    if itemCount == 0 then
        return
    end
    
    local regionStartPos = math.huge
    local regionEndPos = 0

    local proj = 0
    for i = 0, itemCount - 1 do
        local item = reaper.GetSelectedMediaItem(proj, i)
        local active_take = reaper.GetActiveTake(item)
        local position = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        local endPos = position + length
        
        if position < regionStartPos then
            regionStartPos = position
        end
        
        if endPos > regionEndPos then
            regionEndPos = endPos
        end
    end
    
    -- get the user's input
    
    local retval, userInput = reaper.GetUserInputs("User Input", 1, "Enter the region name", "")
    
    -- Create a region for each item
    local isrgn = true
    local regionIndex = reaper.AddProjectMarker2(project, isrgn, regionStartPos, regionEndPos, userInput, -1, 0)
end

main()
