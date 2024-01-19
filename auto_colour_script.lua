-- Set the desired colors for each prefix
local colourTable_priority = {
    [' v'] = 0x264A16, -- Dark Green
    [' del'] = 0x264A16, -- Dark Green
}

local colourTable = {
    -- In Reaper, the format is 0xBBGGRR in hex
    Atmos = 0x227527, -- Green
    Foley = 0xAB4A43, -- Blue
    SFX = 0x4874CF,  -- Orange
    Dx = 0x2AC5DC,  -- Yellow
    Mx = 0x8924C8, -- Pink
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

        local matchFound = false
        for k, v in pairs(colourTable_priority) do
            local i, j = string.find(trackName, k)
            if i then
                local key = string.sub(trackName, i, j)
                local colourToChangeTo = colourTable_priority[key]
                reaper.SetTrackColor(track, colourToChangeTo)
                matchFound = true
            end
        end

        if not matchFound then
            for k, v in pairs(colourTable) do
                local i, j = string.find(trackName, k)
                if i then
                    local key = string.sub(trackName, i, j)
                    local colourToChangeTo = colourTable[key]
                    reaper.SetTrackColor(track, colourToChangeTo)
                end
            end
        end
    end
end

-- Run the function
colorTracksByPrefix()

