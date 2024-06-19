-- Doesn't work as intended

function main()
    _, num_markers, num_regions = reaper.CountProjectMarkers(0)
    
    local total = num_markers + num_regions
    reaper.ShowConsoleMsg('num_markers: '..num_markers..'\n')
    reaper.ShowConsoleMsg('num_regions: '..num_regions..'\n')

    -- enum all project markers, regions only
    for i = 0, total - 1 do
        _, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, i)
        
        if isrgn then
            reaper.ShowConsoleMsg('looking at region'..'\n')
            newRegionEnd = rgnend + 1
            reaper.SetProjectMarkerByIndex2(0, markrgnindexnumber, true, pos, newRegionEnd, -1, name, color, 1)
        end
    end

end


main()
