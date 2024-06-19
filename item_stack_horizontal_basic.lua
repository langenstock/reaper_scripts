function main()
    -- Get the selected items
    local selectedItems = {}
    local numSelectedItems = reaper.CountSelectedMediaItems(0)
    
        
    -- We want to place the items on the selected track and below that, not above
    local selectedTrack = reaper.GetSelectedTrack(0, 0)
    
    local trackIndex
    if selectedTrack then
        -- Get the track index
        trackIndex = reaper.GetMediaTrackInfo_Value(selectedTrack, "IP_TRACKNUMBER")
        --reaper.ShowConsoleMsg("Selected Track Index: " .. trackIndex .. "\n")
    else
        --reaper.ShowConsoleMsg("No track selected.\n")
    end
    
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
        
    
        -- Calculate the time interval for each track
        -- local timeInterval = (endTime - startTime) / numTracks
    
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
            
            trackIndex = trackIndex + 1
        end
    
        reaper.UpdateArrange()
    else
        reaper.ShowConsoleMsg("No selected items.\n")
    end
end

main()
