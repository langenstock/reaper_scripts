function main()
    -- Count selected items
    local numOfSelItems = reaper.CountSelectedMediaItems(activeProj)
    
    if numOfSelItems > 0 then
        -- Get selected item
        local firstItem = reaper.GetSelectedMediaItem(activeProj, 0)
        
        -- Get pos of item
        local itemPos = reaper.GetMediaItemInfo_Value(firstItem, "D_POSITION")
        
        -- Count markers
        local _, numMarkers, numRegions = reaper.CountProjectMarkers(activeProj)
        local totalMarkers = numMarkers + numRegions
        
        if totalMarkers > 0 then
        
            local closestMarkerDistance = math.huge
            local closestMarkerPos

            for i = 0, totalMarkers - 1 do
                
                local _, isrgn, markerPos, rgnend, name, markrgnid, _ = reaper.EnumProjectMarkers3(activeProj, i)
                
                if not isrgn then
                    if math.abs(markerPos - itemPos) < closestMarkerDistance then
                        closestMarkerDistance = math.abs(markerPos - itemPos)
                        closestMarkerPos = markerPos
                    end
                end
            end
            
            if closestMarkerPos ~= math.huge then
                reaper.SetMediaItemPosition(firstItem, closestMarkerPos, true)
            end
        end
    end
end


main()
