-- Function to create a region for each selected clip in the session
-- The names of the regions will be the track name, numbered with an underscore in between
-- The script will see if there is a parent track involved, and use that instead if there is one
-- e.g. if the track name is Audio, and there are 2 items, then regions will be 
-- 'Audio_1', 'Audio_2'

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
    local preiousItemTrackName = ''
    local runningRegionIndex = 1

    -- Iterate through each item and create a region
    for i = 0, itemCount - 1 do
        local item = reaper.GetSelectedMediaItem(project, i)
        local position = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        local track = reaper.GetMediaItem_Track(item)
        local _, trackName = reaper.GetTrackName(track, '')
        
        -- if the track has a parent track, we would like to use that for the labelling instead
        local parent_track = reaper.GetParentTrack(track)
        if parent_track then
          _, trackName = reaper.GetTrackName(parent_track, '')
        end

        -- If we are on a new track, or a track with a new name at least, region label index goes back to 1
        if preiousItemTrackName ~= trackName then
          runningRegionIndex = 1
        else
          runningRegionIndex = runningRegionIndex + 1
        end

        -- Create a region for each item
        local isrgn = true
        local regionIndex = reaper.AddProjectMarker2(project, isrgn, position, position + length, tostring(trackName)..'_' .. runningRegionIndex, -1, 0)
        if regionIndex == -1 then
          reaper.ShowMessageBox("Whoospied.", "Error", 0)
        end
        
        preiousItemTrackName = trackName
        -- If you want to color the regions, you can set the region color here
        -- reaper.SetProjectMarker4(project, regionIndex, false, 0, 0, 255)

    end

    -- End undo block
    reaper.Undo_EndBlock("Create Regions for Clips", -1)

    -- Update the arrange view to reflect the changes
    reaper.UpdateArrange()

end

-- Run the function
createRegionsForClips()

