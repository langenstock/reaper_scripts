-- Function to check if a track is empty
local colours = {
    yellow = 0x2AC5DC,
}

function isTrackEmpty(track)
    local itemCount = reaper.CountTrackMediaItems(track)
    return itemCount == 0
end

-- Function to set the track color to red
function setTrackColour(track, colour)
    reaper.SetTrackColor(track, colour)
end


function main()
    local project = 0
    local trackCount = reaper.CountTracks(project)

    for i = trackCount - 1, 0, -1 do
        local track = reaper.GetTrack(project, i)
        local isParent = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH") >= 1

        if not isParent and isTrackEmpty(track) then
            local colour = colours.yellow
            setTrackColour(track, colour)
            
            -- Here we should check if it has a parent and then check the parent for emptiness
        end
    end
end

-- Run the main function
reaper.Undo_BeginBlock()
main()
reaper.Undo_EndBlock("Color Empty Tracks Red", -1)

