-- Insert 1 or multiple tracks prompted with names
-- if you select more than 1 track, it will automatically amend '_1' etc. onto the end of each subsequent track name

function main()
    local _, quantityOfTracks = reaper.GetUserInputs("User Input", 1, "How many tracks, sports fan?", "")
    quantityOfNewTracks = tonumber(quantityOfTracks) or 1

    local selectedTrack = reaper.GetSelectedTrack(0, 0)
    local selectedTrackIndex = reaper.GetMediaTrackInfo_Value(selectedTrack, "IP_TRACKNUMBER")
    local index = selectedTrackIndex or reaper.GetNumTracks()   -- Get the index for the last track
    
    -- Prompt the user for a new name
    local userOK, newTrackName = reaper.GetUserInputs("Rename New Track", 1, "New Track Name:,extrawidth=200", "")
    
    for i = 1, quantityOfNewTracks do
        reaper.InsertTrackAtIndex(index, true)
        
        -- if we are making multiple tracks then amend a '_1' onto the track name, otherwise leave as is
        local i_trackName
        if quantityOfNewTracks > 1 then
            i_trackName = newTrackName .. '_' .. i
        else
            i_trackName = newTrackName
        end
        
        -- Get the newly created track
        local newTrack = reaper.GetTrack(0, index)
        
        if newTrack then
            if userOK then
                -- Set the track name to the user's input
                reaper.GetSetMediaTrackInfo_String(newTrack, "P_NAME", i_trackName, true)
            end
        end
        index = index + 1
    end
end

main()
