-- A script to prompt you for a name when creating a region
-- Highlight either items or a timeline section for which you want to create a region around and run the script
-- This script checks for duplicate region names
-- If the last character is numerical it will suggest the next available number
CHECK_FOR_DUP_REG_NAMES = true
AUTO_INCREMENT_NUM_NAMES = true

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

        currentSuggestion = userInput
        while (retval and thisRegionNameAlreadyTaken(currentSuggestion)) do
            if AUTO_INCREMENT_NUM_NAMES then
                -- Get last character of the string and check if it is numerical
                local lastChar = currentSuggestion:sub(-1, -1)
                if tonumber(lastChar) then
                    currentSuggestion = incrementLastNumericalCharacterAndSuggest(currentSuggestion, lastChar)
                else -- last character is not a numerical digit
                    retval, currentSuggestion = reaper.GetUserInputs("NAME TAKEN", 1, "Try again?", currentSuggestion)
                end
            else
                retval, currentSuggestion = reaper.GetUserInputs("NAME TAKEN", 1, "Try again?", currentSuggestion)
            end
        end
        
        if currentSuggestion ~= userInput then -- i.e. if currentSuggestion is different to initial request
            retval, currentSuggestion = reaper.GetUserInputs("SUGGESTED:", 1, "This is available", currentSuggestion)
        end
    end
    
    -- If you click cancel or press ESC then don't place a region. Press Enter or click OK for an unnamed region to be created
    if retval then
        local newName = currentSuggestion or userInput
    
        -- Create a region for each item
        local isrgn = true
        local regionIndex = reaper.AddProjectMarker2(activeProj, isrgn, regionStartPos, regionEndPos, newName, -1, 0)
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

function incrementLastNumericalCharacterAndSuggest(userInput, lastChar)
    local suggestedName
    if lastChar == '9' then
        local intermediateString = userInput:sub(1, -3) -- chop off last 2 characters
         
        -- Check if last two characters are numerical
        local lastTwoDig = tonumber(userInput:sub(-2, -1))
        if lastTwoDig then -- for e.g. 'string_19
            lastTwoDig = lastTwoDig + 1
            suggestedName = intermediateString .. lastTwoDig
            
        else -- for e.g. 'string_9'
            local lastDig = userInput:sub(-1, -1)
            lastDig = tonumber(lastDig) + 1
            intermediateString = userInput:sub(1, -2) -- chop off last character
            suggestedName = intermediateString .. lastDig
        end
        
    else -- last Char is not 9
        local intermediateString = userInput:sub(1, -2) -- chop off last character
        lastChar = tonumber(lastChar) + 1
        suggestedName = intermediateString .. lastChar
    end
    
    if not suggestedName then
        return 'ERROR_IN_CODE'
    end
    
    return suggestedName
end

main()
