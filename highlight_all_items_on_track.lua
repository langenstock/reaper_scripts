function main()
    -- Count selected tracks
    local activeProj = 0
    local numOfSelTracks = reaper.CountSelectedTracks(activeProj)
    
    if numOfSelTracks > 0 then
        for i = 1, numOfSelTracks do
            local j = i - 1
            
            -- Get selected track
            local track = reaper.GetSelectedTrack(activeProj, j)
            
            -- Count all media items
            local countOfItems = reaper.CountMediaItems(activeProj)
            
            for k = 0, countOfItems - 1 do
                -- Get reference to item
                local item = reaper.GetMediaItem(activeProj, k)
                
                local itemsTrack = reaper.GetMediaItemTrack(item)
                
                if itemsTrack == track then
                    -- Set this item to selected
                    
                    reaper.SetMediaItemSelected(item, true)
                end
            end
        end
    end
    reaper.UpdateTimeline()
end


main()
