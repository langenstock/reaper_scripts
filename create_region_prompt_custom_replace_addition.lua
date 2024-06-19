-- A script to prompt you for a name when creating a region
-- Highlight the items for which you want to create a region around and run the script

local CUSTOM_REMOVE = '.wav'
local CUSTOM_ADD = 'id11_'


function main()
    local itemCount = reaper.CountSelectedMediaItems(project)
    
    local regionStartPos, regionEndPos
    if itemCount == 0 then
        regionStartPos, regionEndPos = createRegionBasedOnItemSelections()
    else
        regionStartPos, regionEndPos = createRegionBasedOnTimelineSelection(itemCount)
    end
    
    -- get the user's input
    
    local retval, userInput = reaper.GetUserInputs("User Input", 1, "Enter the region name", "")
    
    -- If you click cancel or press ESC then don't place a region. Press Enter or click OK for an unnamed region to be created
    if retval then
        local finalString = CUSTOM_ADD .. userInput -- amends id1_ or similar on the start of string
        finalString = string.gsub(finalString, '.wav', '') -- remove the .wav from the end
        
        -- Count project markers
        local _, num_markers, num_regions = reaper.CountProjectMarkers(0)
        local total = num_markers + num_regions
        
        for i = 0, total - 1 do
            local retval, b_isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, i)
            if retval then
                if name == finalString then
                    local msg = 'Same region name: '..name ..' , at position: '..pos
                    reaper.ShowMessageBox(msg, 'Warning: Duplicate Rgn Name', 0)
                end
            end
        end
        
        -- Create a region for each item
        local isrgn = true
        local regionIndex = reaper.AddProjectMarker2(project, isrgn, regionStartPos, regionEndPos, finalString, -1, 0)
    end
end

function createRegionBasedOnItemSelections()
    local isSet = false
    local isLoop = false
    local autoSeek = false
    local regionStartPos, regionEndPos = reaper.GetSet_LoopTimeRange2(0, isSet, isLoop, nil, nil, autoSeek)
    
    return regionStartPos, regionEndPos
end

function createRegionBasedOnTimelineSelection(itemCount)
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
    
    return regionStartPos, regionEndPos
end

main()
