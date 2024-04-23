-- A script to prompt you for a name when creating a region
-- Highlight either items or a timeline section for which you want to create a region around and run the script
-- This script checks for duplicate region names
CHECK_FOR_DUP_REG_NAMES = true
activeProj = 0

function main()
    local itemCount = reaper.CountSelectedMediaItems(activeProj)
    
    local regionStartPos, regionEndPos
    if itemCount == 0 then
        regionStartPos, regionEndPos = createRegionBasedOnItemSelections()
    else
        regionStartPos, regionEndPos = createRegionBasedOnTimelineSelection(itemCount)
    end
    
    -- get the user's input
    local retval, userInput = reaper.GetUserInputs("User Input", 1, "Enter the region name", "")
    
    if CHECK_FOR_DUP_REG_NAMES then
        while (retval and thisRegionNameAlreadyTaken(userInput)) do
            retval, userInput = reaper.GetUserInputs("NAME TAKEN", 1, "Try again?", "")
        end
    end
    
    -- If you click cancel or press ESC then don't place a region. Press Enter or click OK for an unnamed region to be created
    if retval then
    
        -- Create a region for each item
        local isrgn = true
        local regionIndex = reaper.AddProjectMarker2(activeProj, isrgn, regionStartPos, regionEndPos, userInput, -1, 0)
    end
end

function createRegionBasedOnItemSelections()
    local isSet = false
    local isLoop = false
    local autoSeek = false
    local regionStartPos, regionEndPos = reaper.GetSet_LoopTimeRange2(activeProj, isSet, isLoop, nil, nil, autoSeek)
    
    return regionStartPos, regionEndPos
end

function createRegionBasedOnTimelineSelection(itemCount)
    local regionStartPos = math.huge
    local regionEndPos = 0

    for i = 0, itemCount - 1 do
        local item = reaper.GetSelectedMediaItem(activeProj, i)
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
    
    return regionStartPos, regionEndPos
end

function thisRegionNameAlreadyTaken(nameToCheck)
    -- Count session markers
    local _, num_markers, num_regions = reaper.CountProjectMarkers(activeProj)
    
    local totalMarkers = num_markers + num_regions
    
    -- Enumerate all project markers
    for i = 0, totalMarkers - 1 do
        local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers2(activeProj, i)
        
        if isrgn then
            if name == nameToCheck then
                return true
            end
        end
    end
    
    return false
end

main()
