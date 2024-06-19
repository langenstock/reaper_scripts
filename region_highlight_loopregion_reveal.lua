-- Note, at the moment you need to give the region name exactly for it to work


function main()
    local activeProj = 0

    -- Count Project Markers
    local _, num_markers, num_regions = reaper.CountProjectMarkers(activeProj)
    local totalMarkers = num_markers + num_regions
    
    -- Get user input for desired region name
    local _, desiredRgnName = reaper.GetUserInputs('Region Name', 1, '', '')
    
    local foundRegion = false
    local foundRegionStart, foundRegionEnd
    for i = 0, totalMarkers - 1 do
        local _, isrgn, pos, rgnend, name, rgn_idx= reaper.EnumProjectMarkers2(activeProj, i)
        
        if isrgn then
            if name == desiredRgnName then
                 foundRegion = true
                 foundRegionStart = pos
                 foundRegionEnd = rgnend
            end
        end
    end
    
    if foundRegion then
        local isSet, isLoop, allowAutoSeek = true, true, false
        reaper.GetSet_LoopTimeRange(isSet, isLoop,foundRegionStart, foundRegionEnd, allowAutoSeek)
    end
end


main()
