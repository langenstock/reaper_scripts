function main()
    local activeProj = 0
    
    local numOfSelItems = reaper.CountSelectedMediaItems(activeProj)
    
    if numOfSelItems > 0 then
        -- Get first selected item
        local firstItem = reaper.GetSelectedMediaItem(activeProj, 0)
        
        local firstItemPos = reaper.GetMediaItemInfo_Value(firstItem, "D_POSITION")
    
        local thisItemsTrack = reaper.GetMediaItemTrack(firstItem)
    
        local numOfItems = reaper.CountMediaItems(activeProj)
        
        for i = 0, numOfItems - 1 do
            local item = reaper.GetMediaItem(activeProj, i)
            
            if reaper.GetMediaItemTrack(item) == thisItemsTrack then
                if reaper.GetMediaItemInfo_Value(item, "D_POSITION") > firstItemPos then
                    reaper.SetMediaItemSelected(item, true)
                end
            end
        end
        
        reaper.UpdateTimeline()
    end
end


main()
