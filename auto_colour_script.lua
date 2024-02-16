-- Set the desired colors for each prefix
-- Colours are ordered in terms of priority

colourTable_priority_1 = {
    [' v'] = 0x264A16, -- Dark Green
    ['del'] = 0x264A16, -- Dark Green
}
    
colourTable_priority_2 = {
    -- insert other rules here if you wish
}

colourTable_priority_3 = {
    -- In Reaper, the format is 0xBBGGRR in hex
    Atmos = 0x227527, -- Green
    Foley = 0xAB4A43, -- Blue
    SFX = 0x4874CF,  -- Orange
    Dx = 0x2AC5DC,  -- Yellowa
    Mx = 0x8924C8, -- Pink
}

rulesTables = {
    [1] = colourTable_priority_1,
    [2] = colourTable_priority_2,
    [3] = colourTable,
}

function colourByRule(rulesTable, trackName, track)
    local matchFound = false
    for k, v in pairs(rulesTable) do
        local i, j = string.find(trackName, k)
        if i then
            local key = string.sub(trackName, i, j)
            local colourToChangeTo = rulesTable[key]
            reaper.SetTrackColor(track, colourToChangeTo)
            matchFound = true
        end
    end
    return matchFound
end 

-- Function to set track color based on the first letter of the track name
function runColourTracksByPrefix()
    -- Get the total number of tracks in the project
    local numTracks = reaper.CountTracks(0)

    -- Loop through each track
    for i = 0, numTracks - 1 do
        -- Get the track object
        local track = reaper.GetTrack(0, i)

        -- Get the track name
        local _, trackName = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)

        for i, k in ipairs(rulesTables) do
            local matchFound = colourByRule(k, trackName, track)
            if matchFound == true then
                break
            end
        end
    end
end

-- Run the function
runColourTracksByPrefix()

