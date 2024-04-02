-- Function to create a region for each selected clip in the session
-- The names of the regions will be the the same as the file name
-- Use this script for editing an already named asset where we want to 
-- rerender the file with the exact same file name

function main()
    local project = 0 -- 0 represents the active project, change if needed

    -- Get the total number of selected items in the project
    local itemCount = reaper.CountSelectedMediaItems(project)

    -- Check if there are any items in the project
    if itemCount == 0 then
        reaper.ShowMessageBox("No selected items found.", "Error", 0)
        return
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
            
            -- Create a region for each item
            local isrgn = true
            local regionIndex = reaper.AddProjectMarker2(project, isrgn, position, position + length, take_name, -1, 0)
            if regionIndex == -1 then
              reaper.ShowMessageBox("Whoopsied.", "Error", 0)
            end
        end
    end

    -- Update the arrange view to reflect the changes
    reaper.UpdateArrange()

end

-- Run the function
main()

