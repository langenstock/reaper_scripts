-- Function to randomize parameters within a specified range
function randomizeParameter(track, fxIndex, parameter, minValue, maxValue)
    local randomValue = math.random() * (maxValue - minValue) + minValue
    reaper.TrackFX_SetParamNormalized(track, fxIndex, parameter, randomValue)
end

-- Function to randomize dry/wet mix parameter
function randomizeDryWetMix(track, fxIndex, wetParameter)
    randomizeParameter(track, fxIndex, wetParameter, 0, 1)
end

-- Function to place random automation points within active item range
function randomizeAutomationPoints(track, trackEnvelopeIndex)
    local itemCount = reaper.CountTrackMediaItems(track)

    if itemCount == 0 then
        reaper.ShowMessageBox("No active items on the track.", "Error", 0)
        return
    end
    
    -- get track envelope
    local envelope = reaper.GetTrackEnvelope(track, trackEnvelopeIndex)
    if envelope then
        reaper.ShowMessageBox("Envelope success.", "Error", 0)
    else
        reaper.ShowMessageBox("Envelope fail.", "Error", 0)
        return
    end

    -- Iterate through active items
    for i = 0, itemCount - 1 do
        local item = reaper.GetTrackMediaItem(track, i)
        local startTime = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local endTime = startTime + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")

        -- Randomize automation points within the time range of the item
        for j = 1, 5 do -- Adjust the number of points as needed
            local randomTime = math.random() * (endTime - startTime) + startTime
            local randomTime2 = math.random() * (endTime - startTime) + startTime
            reaper.InsertAutomationItem(envelope, -1, randomTime2, randomTime, true)
        end
    end
end

-- Main function
function main()
    -- Get the selected track
    local track = reaper.GetSelectedTrack(0, 0)

    if not track then
        reaper.ShowMessageBox("Please select a track.", "Error", 0)
        return
    end
    
    -- Get selected item
    

    -- Get the first inserted plugin on the track
    local fxIndex = 0

    -- Get the name of the plugin at fxIndex = 0
    local _, pluginName = reaper.TrackFX_GetFXName(track, fxIndex, "")

    -- Print the plugin name to the console
    reaper.ShowConsoleMsg("Plugin Name: " .. pluginName .. "\n")

    -- Specify the parameters you want to randomize (change these indices accordingly)
   -- local parameterToRandomize1 = 0 -- e.g., change this to the index of the first parameter
   -- local parameterToRandomize2 = 1 -- e.g., change this to the index of the second parameter

    for i = 0, 1 do
        -- Randomize parameters
        randomizeParameter(track, fxIndex, i, 0, 1)
        --randomizeParameter(track, fxIndex, i, -1, 1)
        
        -- Randomize automation points within active item range
        randomizeAutomationPoints(track, i)
    end

    -- Specify the wet parameter index (change this accordingly)
    local wetParameter = 3 -- e.g., change this to the index of the wet parameter

    -- Randomize dry/wet mix
    randomizeDryWetMix(track, fxIndex, wetParameter)
end

-- Run the main function
reaper.Undo_BeginBlock()
main()
reaper.Undo_EndBlock("Randomize Plugin Parameters and Automation Points", -1)

