-- Function to delete all region markers
function main()
    local project = 0
    local _, numMarkers, numRegions = reaper.CountProjectMarkers(project)
    --reaper.MB('numMarkers: '..numMarkers..', numRegions: '..numRegions, 'well', 0)
    for i = numRegions - 1, 0, -1 do
        local _, isrgn, _, _, _, _, _ = reaper.EnumProjectMarkers(i)
        if isrgn then
            reaper.DeleteProjectMarker(project, regionIndex, true)
        end
    end
end

-- Run the function
main()
