function main()
    local activeProj = 0
    
    local numOfSelItems = reaper.CountSelectedMediaItems(activeProj)
    
    if numOfSelItems > 0 then
  
        -- Get references to all tracks that are involved with highlighted clips
        local tracks = {}
        local leftMostItemPos = math.huge
        for i = 0, numOfSelItems - 1 do
            local item = reaper.GetSelectedMediaItem(activeProj, i)
            
            local track = reaper.GetMediaItemTrack(item)
            
            local trackAlreadyInTable = false
            for k, tr in pairs(tracks) do
                if tr == track then
                    trackAlreadyInTable = true
                end
            end
            if trackAlreadyInTable == false then
                table.insert(tracks, track)
            end
            
            if reaper.GetMediaItemInfo_Value(item, "D_POSITION") < leftMostItemPos then
                leftMostItemPos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
            end
        end

        local numOfItems = reaper.CountMediaItems(activeProj)
        for i = 0, numOfItems - 1 do
            local item = reaper.GetMediaItem(activeProj, i)
            
            for k, tr in pairs(tracks) do
                if reaper.GetMediaItemTrack(item) == tr then
                    if reaper.GetMediaItemInfo_Value(item, "D_POSITION") > leftMostItemPos then
                        reaper.SetMediaItemSelected(item, true)
                    end
                end
            end
        end

        reaper.UpdateTimeline()
    end
end


main()
