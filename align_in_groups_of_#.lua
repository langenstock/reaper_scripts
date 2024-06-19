function main()
    -- Set a spacer between our clumps of items -- Promp user for input, failing that defaults to 3 seconds
    local spacer = 3
    local _, userInputSpacer = reaper.GetUserInputs("User Input", 1, "Space between item groups:", "")
    local userInputSpacerNum = tonumber(userInputSpacer)
    if userInputSpacerNum then
        spacer = userInputSpacerNum
    end
    
    -- Set the number of tracks we want to distribute items over. Prompt user, failing that defaults to 3 tracks
    local tracksToDistributeOver = 3
    local _2, userInputTracks = reaper.GetUserInputs("User Input", 1, "How many tracks:", "")
    local userInputTracksNum = tonumber(userInputTracks)
    if userInputTracksNum then
        tracksToDistributeOver = userInputTracksNum
    end

    -- Get the selected items
    local selectedItems = {}
    local numSelectedItems = reaper.CountSelectedMediaItems(0)
    
    -- We want to place the items on the selected track and below that, not above
    local selectedTrack = reaper.GetSelectedTrack(0, 0)
    
    if not selectedTrack then return end
    
    local trackIndex
    if selectedTrack then
        -- Get the track index
        trackIndex = reaper.GetMediaTrackInfo_Value(selectedTrack, "IP_TRACKNUMBER")
        --reaper.ShowConsoleMsg("Selected Track Index: " .. trackIndex .. "\n")
    end
    
    local topMostTrack = trackIndex
    
    -- Check if there are selected items
    if numSelectedItems > 0 then
        for i = 0, numSelectedItems - 1 do
            local item = reaper.GetSelectedMediaItem(0, i)
            table.insert(selectedItems, item)
        end
        
        local startTime = reaper.GetMediaItemInfo_Value(selectedItems[1], "D_POSITION")
        local endTime = reaper.GetMediaItemInfo_Value(selectedItems[#selectedItems], "D_POSITION") + reaper.GetMediaItemInfo_Value(selectedItems[#selectedItems], "D_LENGTH")
        
        -- Get the number of tracks
        local numTracks = reaper.CountTracks(0)
    
        -- Iterate through the selected items and distribute them horizontally
        for i, item in ipairs(selectedItems) do
            -- Find the track to place the item based on its time position
            --local trackIndex = math.floor((reaper.GetMediaItemInfo_Value(item, "D_POSITION") - startTime) / timeInterval) + 1
    
            -- Get the track at the calculated index
            local track = reaper.GetTrack(0, trackIndex - 1)
    
            -- Set the track for the item
            reaper.MoveMediaItemToTrack(item, track)
            
            -- Move to align with above
            reaper.SetMediaItemInfo_Value(item, "D_POSITION", startTime)
            
            if trackIndex < (topMostTrack + tracksToDistributeOver - 1) then
                trackIndex = trackIndex + 1
            elseif trackIndex == (topMostTrack + tracksToDistributeOver - 1) then
                trackIndex = topMostTrack
                startTime = startTime + spacer
            end
        end
    
        reaper.UpdateArrange()
    end
    
    -- Prompt user if they want to randomise the item positions slightly
    local _, userInputRandPos = reaper.GetUserInputs("User Input", 1, "Type y to randomise item pos", "")
    if userInputRandPos == 'y' then
    
        -- Get the selected items
        selectedItems = {}
        local numSelectedItems = reaper.CountSelectedMediaItems(0)
        
        -- Prompt user for random offset amount
        local randomOffsetAmount = 0.1
        local _, userInputRandAmount = reaper.GetUserInputs("User Input", 1, "Maximum random amount: ", "")
        local userInputRandAmountNumb = tonumber(userInputRandAmountNumb)
        if userInputRandAmountNumb then
            randomOffsetAmount = userInputRandAmountNumb
        end
        
        if numSelectedItems > 0 then
            for i = 0, numSelectedItems - 1 do
                local item = reaper.GetSelectedMediaItem(0, i)
                table.insert(selectedItems, item)
            end
            
            for i, item in ipairs(selectedItems) do
                local track = reaper.GetMediaItemTrack(item)
            
                -- Set the track for the item
                reaper.MoveMediaItemToTrack(item, track)
                
                local startPos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
                local offsetAmount = math.random() * randomOffsetAmount
                
                -- Move to align with above
                reaper.SetMediaItemInfo_Value(item, "D_POSITION", startPos + offsetAmount)
                
            end
            
        end
    end 
end

main()

