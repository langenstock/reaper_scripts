-- Set the desired colors for each prefix
local colorTable = {
    P = 0xFF0000, -- Red
    v = 0x00FF00, -- Green
    SFX = 0x0000FF, -- Blue
    -- Add more prefixes and colors as needed
}

-- Function to set track color based on the first letter of the track name
function colorTracksByPrefix()
    -- Get the total number of tracks in the project
    local numTracks = reaper.CountTracks(0)

    -- Loop through each track
    for i = 0, numTracks - 1 do
        -- Get the track object
        local track = reaper.GetTrack(0, i)

        -- Get the track name
        local _, trackName = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)

        -- Extract the first letter of the track name
        local firstLetter = trackName:sub(1, 1)

        -- Check if the first letter has a corresponding color in the table
        if colorTable[firstLetter] then
            -- Set the track color
            reaper.SetTrackColor(track, colorTable[firstLetter])
        end
    end
end

-- Run the function
colorTracksByPrefix()

