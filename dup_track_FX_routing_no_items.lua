-- Copy Routing and FX from One Track to Another

function main()
    local proj = 0
    local sourceTrack = reaper.GetSelectedTrack(proj, 0)
    
    if not sourceTrack then return end
    
    local numTracks = reaper.CountTracks(proj)
    
    local usedTrackIndices = {}
    if numTracks > 0 then
        reaper.ShowConsoleMsg("Track indexes in use:\n")

        for i = 0, numTracks - 1 do
            local track = reaper.GetTrack(proj, i)
            local trackName = reaper.GetMediaTrackInfo_Value(track, "P_NAME")
            local trackIndex = reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER")
            usedTrackIndices[trackIndex] = true

            reaper.ShowConsoleMsg("Track Index: " .. trackIndex .. ", Track Name: " .. trackName .. "\n")
        end
    end
    
    -- Insert a new track just below the selected track
    local selectedTrackIndex = reaper.GetMediaTrackInfo_Value(sourceTrack, "IP_TRACKNUMBER")
    local newIndex = selectedTrackIndex + 1
    while usedTrackIndices[newIndex] == true
    do
        newIndex = newIndex + 1
    end
--    reaper.ShowConsoleMsg('newIndex: '..newIndex..' , selectedTrackIndex: '..selectedTrackIndex)
    local _ = reaper.InsertTrackAtIndex(newIndex, true)
    local newTrack = reaper.GetTrack(proj, newIndex)
    --local newTrack = reaper.GetSelectedTrack(proj, newIndex)
    assert(newTrack)
    
    -- Prompt the user for a new name
    local userOK, newTrackName = reaper.GetUserInputs("Rename New Track", 1, "New Track Name:,extrawidth=200", "")
    if not userOK then
        newTrackName = ''
    end

    reaper.GetSetMediaTrackInfo_String(newTrack, "P_NAME", newTrackName, true)
    --local destinationTrack = reaper.GetSelectedTrack(0, 1) -- change to be a duplicate situation
    
    -- Check if both source and destination tracks are selected
    if sourceTrack and newTrack then
        -- Copy routing
        local _, sourceRoutingChunk = reaper.GetTrackStateChunk(sourceTrack, "", false)
        reaper.SetTrackStateChunk(newTrack, sourceRoutingChunk, false)
    
        -- Reset the track name to user input
        if userOK then
            reaper.GetSetMediaTrackInfo_String(newTrack, "P_NAME", newTrackName, true)
        end
    
        -- Copy FX
        local numFX = reaper.TrackFX_GetCount(sourceTrack)
        for i = 0, numFX - 1 do
            local _, fxName = reaper.TrackFX_GetFXName(sourceTrack, i, "")
            reaper.TrackFX_AddByName(newTrack, fxName, false, -1)
        end
    
        reaper.UpdateArrange() -- Update the arrangement
        --reaper.MB("Routing and FX copied successfully!", "Success", 0)
    else
        --reaper.MB("Please select both source and destination tracks.", "Error", 0)
    end
end

main()
