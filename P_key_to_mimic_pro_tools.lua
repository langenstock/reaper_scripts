function main()
    local currentProj = 0
    local selectedTrack = reaper.GetSelectedTrack(currentProj, 0)
    local trackIndex = reaper.GetMediaTrackInfo_Value(selectedTrack, 'IP_TRACKNUMBER')
    --reaper.SetTrackSelected(selectedTrack, false)
    
    -- check if it is the top track?
    
    local oneTrackUpId = reaper.GetMediaTrackInfo_Value(selectedTrack, "IP_TRACKNUMBER") + 1
    local oneTrackUpMediaTrack = reaper.GetTrack(currentProj, oneTrackUpId)
    reaper.SetTrackSelected(oneTrackUpMediaTrack, true)
    
    reaper.SetTrackSelected(selectedTrack, false)
end

main()
