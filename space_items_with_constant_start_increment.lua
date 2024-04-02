function main()
    
    -- Count the selected items
    local activeProject = 0
    local numOfSelectedItems = reaper.CountSelectedMediaItems(activeProject)
    
    -- if number of selected items is 0 then do not proceed
    if numOfSelectedItems > 0 then
    
        -- get a reference to the first item
        local firstSelectedItemIndex = 0
        local firstItem = reaper.GetSelectedMediaItem(activeProject, firstSelectedItemIndex)
        
        -- get the start position of the first item
        local firstItemStartPos = reaper.GetMediaItemInfo_Value(firstItem, 'D_POSITION')
        
        -- prompt the user for the desired grid interval
        _, userInput = reaper.GetUserInputs('Grid Interval', 1, 'Type interval in seconds', '')
        
        if tonumber(userInput) then -- userInput contains non-numberic characters
                                    -- then tonumber(userInput) will be nil
            -- Proceed with the script
            
            -- store that gridInterval as a variable
            local gridInterval = tonumber(userInput)
            
            for i = 0, numOfSelectedItems - 1 do
                -- get a reference to that item
                local item = reaper.GetSelectedMediaItem(activeProject, i)
                
                -- the position of the item will be firstItemStartPos + gridInterval * i
                local newPosition = firstItemStartPos + gridInterval * i
                
                -- move the item
                local refreshUI = true
                reaper.SetMediaItemPosition(item, newPosition, refreshUI)
            end
            
        else
            -- if we are in here, then userInput either had non-numberic characters
                              -- or it was empty
            -- do nothing
        
        end
    end
        
end



main()
