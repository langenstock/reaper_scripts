-- Function to create a region for each selected clip in the session
-- The names of the regions will be the the same as the file name
-- Use this script for editing an already named asset where we want to 
-- rerender the file with the exact same file name

function createRegionsForClips()
    local project = 0 -- 0 represents the active project, change if needed

    -- Get the total number of selected items in the project
    local itemCount = reaper.CountSelectedMediaItems(project)

    -- Check if there are any items in the project
    if itemCount == 0 then
        reaper.ShowMessageBox("No selected items found.", "Error", 0)
        return
    end

    -- Begin undo block
    reaper.Undo_BeginBlock()
    
    local r = math.random(80, 255)
    local g = math.random(80, 255)
    local b = math.random(80, 255)

    -- Iterate through each item and create a region
    for i = 0, itemCount - 1 do
        --reaper.ShowMessageBox("i: "..i, "Error", 0)
        local item = reaper.GetSelectedMediaItem(project, i)
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
        
        -- Each time we run the script, a random colour will be used for this batch of regions
        --reaper.SetProjectMarker4(project, regionIndex, false, r, g, b)
    end
    -- End undo block
    reaper.Undo_EndBlock("Create Regions for Clips", -1)

    -- Update the arrange view to reflect the changes
    reaper.UpdateArrange()

end

-- Run the function
createRegionsForClips()

