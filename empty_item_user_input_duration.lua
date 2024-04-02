-- Create an empty item prompting the user for the desired duration

function main()
    -- Get user input for item length
    local user_input_result, user_input_str = reaper.GetUserInputs("Enter Item Length", 1, "Item Length (seconds):", "")
    if not user_input_result then return end -- User canceled

    -- Convert user input to a number
    local item_length = tonumber(user_input_str)
    if not item_length or item_length <= 0 then
        return
    end

    -- Get the selected track
    local project = 0
    local selected_track = reaper.GetSelectedTrack(project, 0)
    if not selected_track then
        return
    end

    -- get the playback head position
    local cursorPosition = reaper.GetCursorPosition()
    local startPosition = cursorPosition
    local endPosition = startPosition + item_length

    -- Create an empty item on the selected track
    local item = reaper.CreateNewMIDIItemInProj(selected_track, startPosition, endPosition)
    if not item then
        return
    end

    -- Update the arrangement
    reaper.UpdateArrange()
end


main()