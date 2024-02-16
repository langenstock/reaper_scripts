-- Insert 1 track and prompt for name

function main()
    local index = reaper.GetNumTracks()
    local selectedTrack = reaper.GetSelectedTrack(0, 0)
    if selectedTrack then
        local selectedTrackIndex = reaper.GetMediaTrackInfo_Value(selectedTrack, "IP_TRACKNUMBER")
        index = selectedTrackIndex or reaper.GetNumTracks()   -- Get the index for the last track
    end
    
    -- Prompt the user for a new name
    local userOK, newTrackName = reaper.GetUserInputs("Rename New Track", 1, "New Track Name:,extrawidth=200", "")

    if userOK == false then return end
    
    reaper.InsertTrackAtIndex(index, true)
    
    -- Get the newly created track
    local newTrack = reaper.GetTrack(0, index)
    
    if newTrack then
        if userOK == true then
            -- Set the track name to the user's input
            reaper.GetSetMediaTrackInfo_String(newTrack, "P_NAME", newTrackName, true)
        end
    end
end

main()
