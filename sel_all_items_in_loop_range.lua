function main()
    local isSet = false
    local isLoop = false
    local allowautoseek = false
    local startRange, endRange = reaper.GetSet_LoopTimeRange(isSet, isLoop,0, 1, allowautoseek)
    
    local activeProj = 0
    --local tracksInSession = reaper.CountTracks(activeProj)
    local totalItems = reaper.CountMediaItems(activeProj)
    
    for i = 0, totalItems - 1 do
        local item = reaper.GetMediaItem(activeProj, i)
        local itemStartPos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        
        if itemStartPos > startRange and itemStartPos < endRange then
            -- item is in our range
            local selected = true
            reaper.SetMediaItemSelected(item, selected)
        end
    end
    
    reaper.UpdateTimeline()
end


main()
