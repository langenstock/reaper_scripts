-- Function to move the edit cursor to the closer of the next clip's start or end on the selected track
function moveToCloserPositionOnSelectedTrack()
    local project = 0 -- 0 represents the active project, change if needed

    -- Get the currently selected track
    local selectedTrack = reaper.GetSelectedTrack(project, 0)

    -- Check if a track is selected
    if not selectedTrack then
        reaper.ShowMessageBox("No track highlighted.", "Error", 0)
        return
    end

    -- Get the current edit cursor position
    local currentPosition = reaper.GetCursorPosition()

    -- Initialize variables for the closest positions
    local closestStartPosition = math.huge
    local closestEndPosition = math.huge

    -- Iterate through all media items in the project
    for i = 0, reaper.CountMediaItems(project) - 1 do
        local item = reaper.GetMediaItem(project, i)
        local itemStartPosition = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local itemEndPosition = itemStartPosition + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")

        -- Check if the item is on the selected track
        local itemTrack = reaper.GetMediaItemTrack(item)
        if itemTrack == selectedTrack then
            -- Check if the item is closer in terms of start or end position
            if itemStartPosition > currentPosition and itemStartPosition < closestStartPosition then
                closestStartPosition = itemStartPosition
            end
            if itemEndPosition > currentPosition and itemEndPosition < closestEndPosition then
                closestEndPosition = itemEndPosition
            end
        end
    end

    -- Move the edit cursor to the closer position
    if closestStartPosition ~= math.huge or closestEndPosition ~= math.huge then
        local closerPosition = math.min(closestStartPosition, closestEndPosition)
        reaper.SetEditCurPos2(0, closerPosition, false, false)
        
        -- Check if the new cursor position is not in view and center the view
        local screenStart, screenEnd = reaper.GetSet_ArrangeView2(0, false, 0, 0)
        if closerPosition < screenStart or closerPosition > screenEnd then
            --reaper.adjustZoom(1, 1, true, 0, closerPosition)
        end
    else
        reaper.ShowMessageBox("No next clip found on the selected track.", "Info", 0)
    end
end

-- Run the function
moveToCloserPositionOnSelectedTrack()

