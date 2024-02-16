-- Not working as intended
-- Peak Pos is not being found properly


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
    else
        return
    end
    
    -- Check if there are selected items
    if numSelectedItems > 0 then
        -- Get the peak position of the first selected item
        local firstItem = reaper.GetSelectedMediaItem(0, 0)
        --local firstItemPeakPos = reaper.GetMediaItemInfo_Value(firstItem, "D_PEAKPOS")
        local firstItemPeakPos = findMaxAmplitudePosition(firstItem)
        reaper.ShowConsoleMsg("firstItemPeakPos: "..firstItemPeakPos.."\n")
        
        for i = 0, numSelectedItems - 1 do
            local item = reaper.GetSelectedMediaItem(0, i)
            table.insert(selectedItems, item)
        end
        
        local firstItemStartTime = reaper.GetMediaItemInfo_Value(firstItem, "D_POSITION")
        reaper.ShowConsoleMsg("firstItemStartTime: "..firstItemStartTime.."\n")
        --local endTime = reaper.GetMediaItemInfo_Value(selectedItems[#selectedItems], "D_POSITION") + reaper.GetMediaItemInfo_Value(selectedItems[#selectedItems], "D_LENGTH")
    
        local firstTimePeakOffSet = firstItemPeakPos - firstItemStartTime
        reaper.ShowConsoleMsg("firstTimePeakOffSet: "..firstTimePeakOffSet.."\n")
    
        -- Iterate through the selected items and distribute them horizontally
        for i, item in ipairs(selectedItems) do
            -- Get the peak position of the current item
            --local itemPeakPos = reaper.GetMediaItemInfo_Value(item, "D_PEAKPOS")
            local itemPeakPos = findMaxAmplitudePosition(item)
    
            -- Get the time difference between this item's peak and this item's start time
            local itemStartTime = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
            
            local itemPeakOffSet = itemPeakPos - itemStartTime
    
            -- Get the track at the calculated index
            local track = reaper.GetTrack(0, trackIndex - 1)
    
            -- Set the track for the item
            reaper.MoveMediaItemToTrack(item, track)
            
            -- Move item's start time to match start time of first item
            -- Move item back by the first time's peak offset
            -- Move item forward by this item's peak offset
            
            reaper.SetMediaItemInfo_Value(item, "D_POSITION", firstItemStartTime - firstTimePeakOffSet +itemPeakOffSet )
    
            trackIndex = trackIndex + 1
        end
    
        reaper.UpdateArrange()
    else
        reaper.ShowConsoleMsg("No selected items.\n")
    end
end


-- Function to find the position of the highest amplitude in an item
function findMaxAmplitudePosition(item)
    local take = reaper.GetActiveTake(item)
    local source = reaper.GetMediaItemTake_Source(take)

    local numChannels = reaper.GetMediaSourceNumChannels(source)
    local numSamples = reaper.GetMediaItemTakeInfo_Value(take, "D_LENGTH")
    --local numSamples = math.floor(reaper.GetMediaItemInfo_Value(item, "D_LENGTH") * reaper.GetMediaItemTakeInfo_Value(take, "D_STARTOFFS"))
    local sampleRate = reaper.GetMediaSourceSampleRate(source)
    reaper.ShowConsoleMsg("numSamples: "..numSamples.."\n")
    local maxPos = 0
    local maxValue = 0

    local sampleBuffer = {}

    for i = 0, numSamples - 1 do
        local sampleValue = 0
        -- for j = 1, numChannels do
        local retrievePeakValues = 0
        local val = reaper.GetMediaItemTake_Peaks(take, 0, i * (1 / sampleRate), numChannels, sampleRate, retrievePeakValues)
        reaper.ShowConsoleMsg("val: "..val.."\n")
        sampleValue = math.abs(val)
        --end

        if sampleValue > maxValue then
            maxValue = sampleValue
            maxPos = i / sampleRate
        end
    end

    return maxPos
end


main()
