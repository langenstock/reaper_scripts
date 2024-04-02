function main()
    -- count the number of selected items
    local activeProject = 0
    local numOfSelectedItems = reaper.CountSelectedMediaItems(activeProject)
    
    -- if number of selected items == 0 then do not proceed
    if numOfSelectedItems > 0 then
    
        local leftMostPosition = math.huge
        local largestLength = 0
    
        for i = 0, numOfSelectedItems - 1 do
            -- Get a reference to this item
            local item = reaper.GetSelectedMediaItem(activeProject, i)
            
            -- Get the length of this item
            local length = reaper.GetMediaItemInfo_Value(item, 'D_LENGTH')
            
            -- Compare this length with the largestLength so far
            -- and if this length is greater than largestLength so far
            -- largestLength so far is now THIS length
            
            if length > largestLength then
                largestLength = length
            end
            
            -- Get the position of this item
            local pos = reaper.GetMediaItemInfo_Value(item, 'D_POSITION')
            if pos < leftMostPosition then
                leftMostPosition = pos
            end
        end
        
        local gridInterval = largestLength + 0.5
        
        local previousItemTrackIndex = nil
        local runningIndex = 0
            
        for i = 0, numOfSelectedItems - 1 do
            -- Get a reference to this item
            local item = reaper.GetSelectedMediaItem(activeProject, i)        
            
            -- get a reference to the track that it is sitting on
            local track = reaper.GetMediaItem_Track(item)
            
            -- get the track index of that track
            local trackIndex = reaper.GetMediaTrackInfo_Value(track, 'IP_TRACKNUMBER')
            
            if trackIndex == previousItemTrackIndex then
                runningIndex = runningIndex + 1
            elseif trackIndex ~= previousItemTrackIndex then
                runningIndex = 0
            end
            
            -- update previousItemTrackIndex for use in the next iteration
            previousItemTrackIndex = trackIndex
                
            -- the position that we will move this item to will be:
            -- leftMostItemPosition + gridInterval * runningIndex
            local newPosition = leftMostPosition + gridInterval * runningIndex
            
            -- move the item
            local refreshUI = true
            reaper.SetMediaItemPosition(item, newPosition, refreshUI)
        end
    end
end



main()
