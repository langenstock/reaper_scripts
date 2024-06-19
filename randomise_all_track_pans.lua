
local previousRandomValue = 0
local rangeFactor = 0.3

function main()
    -- Get the total number of tracks in the session
    numTracks = reaper.CountTracks(0)
    
    -- Iterate through each track
    for i = 0, numTracks - 1 do
        -- Get the track at index i
        track = reaper.GetTrack(0, i)
    
        if track then
            local panValue = getRandomPan(i)
            reaper.SetMediaTrackInfo_Value(track, "D_PAN", panValue)
        end
    end
end

function getRandomPan(i)
    -- A value of 1 means 100 R; a value of -1 means 100 L
    local j = i + 1
    
    local value
    -- every second one will be the opposite value of the previous so to maintain some l/r balance
    if j % 2 == 0 then
        value = math.random() * rangeFactor
        previousRandomValue = value
    else
        value = - previousRandomValue
    end
    return value
end


main()
