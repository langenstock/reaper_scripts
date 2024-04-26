-- Function to create a region for each selected clip in the session
-- The names of the regions will be the the same as the file name
-- Use this script for editing an already named asset where we want to 
-- rerender the file with the exact same file name

function main()
    local project = 0 -- 0 represents the active project, change if needed

    local itemCount = reaper.CountSelectedMediaItems(project)

    if itemCount > 0 then
  
        -- Get front buffer time
        _, userInputFrontBuffer = reaper.GetUserInputs('Time at front of region?', 1, '', '')
        local frontEndBuffer = 0
        if tonumber(userInputFrontBuffer) then
            frontEndBuffer = tonumber(userInputFrontBuffer)
        end
        
        -- Get back end buffer time - use for including reverb tails etc.
        _, userInputBackEndBuffer = reaper.GetUserInputs('Time at end of region?', 1, '', '')
        local backEndBuffer = 0
        if tonumber(userInputBackEndBuffer) then
            backEndBuffer = tonumber(userInputBackEndBuffer)
        end
    
        -- Iterate through each item and create a region
        for i = 0, itemCount - 1 do
            local item = reaper.GetSelectedMediaItem(project, i)
            
            local itemMuteState = reaper.GetMediaItemInfo_Value(item, "B_MUTE")
            local muteStateValue = 1
            
            -- If the item is muted then skip this one
            if itemMuteState ~= muteStateValue then
                local active_take = reaper.GetActiveTake(item)
                local _, take_name = reaper.GetSetMediaItemTakeInfo_String(active_take, "P_NAME", "", false)
                
                local position = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
                local length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
                
                local regionStart = position - frontEndBuffer
                -- make sure we are not going left of 0
                regionStart = math.max(0, regionStart)
                
                local regionEnd = position + length + backEndBuffer
                
                -- Create a region for each item
                local isrgn = true
                local regionIndex = reaper.AddProjectMarker2(project, isrgn, regionStart, regionEnd, take_name, -1, 0)
                if regionIndex == -1 then
                  reaper.ShowMessageBox("Whoopsied.", "Error", 0)
                end
            end
        end
    
        reaper.UpdateArrange()
    end
end


main()

