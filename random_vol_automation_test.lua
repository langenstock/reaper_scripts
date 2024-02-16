-- Function to generate random volume automation points within selected items range
function randomizeVolumeAutomationSelectedItems(track)
    local --[[_, ]]numSelectedItems = reaper.CountSelectedMediaItems(0)

    if numSelectedItems == 0 then
        reaper.ShowMessageBox("No items selected on the track.", "Error", 0)
        return
    end

    -- Get the track envelope (volume envelope in this case)
    local envelope = reaper.GetTrackEnvelopeByName(track, "Volume")

    if not envelope then
        --envelope = reaper.GetTrackEnvelope(track, 0) -- Volume envelope
        reaper.ShowMessageBox("You might not have the volume envelope lane open on screen", "Error", 0)
        return
    end
    
    minimumRandomVolume = -100 -- default value
    local retval, userInputMinimumVolume = reaper.GetUserInputs("User Input", 1, "Set Minimum Volume", "") 
    if userInputMinimumVolume then
        minimumRandomVolume = tonumber(userInputMinimumVolume)
    end
    
    maximumRandomVolume = 0 -- default value
    local retval, userInputMaximumVolume = reaper.GetUserInputs("User Input", 1, "Set Maximum Volume", "")
    if userInputMaximumVolume then
        maximumRandomVolume = tonumber(userInputMaximumVolume)
    end
    
    if maximumRandomVolume < minimumRandomVolume then
        reaper.ShowMessageBox("Learn how numbers work.", "Error", 0)
        return
    end
    
    -- Iterate through selected items
    for i = 0, numSelectedItems - 1 do
        local item = reaper.GetSelectedMediaItem(0, i)
        local startTime = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local endTime = startTime + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        
        do
          for i = 0, reaper.CountEnvelopePoints(envelope) - 1 do
              local retval, time, value, shape, tension, selected = reaper.GetEnvelopePoint(envelope, i)
              reaper.ShowConsoleMsg(string.format("Point %d - Time: %f, Value: %f \n", i + 1, time, value))
          end
        end

        -- Generate a random volume
        local randomVolumeDecibels = math.random() * (maximumRandomVolume - minimumRandomVolume) + minimumRandomVolume
        -- Convert volume value to decibels
        local randomVolumeLinear = 10^(randomVolumeDecibels/20) 
        
        local scaling_mode = reaper.GetEnvelopeScalingMode(envelope)
        local scaledRandomVolume = reaper.ScaleToEnvelopeMode(scaling_mode,randomVolumeDecibels)
        
        local str = "randomVolumeDecibels: "..randomVolumeDecibels.." , maximumRandomVolume: "..maximumRandomVolume.." ,minimumRandomVolume: "..minimumRandomVolume
        reaper.ShowConsoleMsg(string.format(str, i + 1, time, value))
        --reaper.ShowMessageBox("randomVolumeDecibels: "..randomVolumeDecibels.." , maximumRandomVolume: "..maximumRandomVolume.." ,minimumRandomVolume: "..minimumRandomVolume , "Error", 0)

        -- Insert automation point at a random position within the time range of the selected item
        local randomTime = math.random() * (endTime - startTime) + startTime
        local shape = 0
        local tension = 0
        
        reaper.InsertEnvelopePointEx(envelope, -1, randomTime, scaledRandomVolume, shape, tension, false, false)
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

    -- Randomize volume automation within selected items range
    randomizeVolumeAutomationSelectedItems(track)
end

-- Run the main function
reaper.Undo_BeginBlock()
main()
reaper.Undo_EndBlock("Randomize Volume Automation (Selected Items)", -1)

