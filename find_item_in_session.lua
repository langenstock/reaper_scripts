function main()
    -- count all items in session
    local activeProj = 0
    local allItemsCount = reaper.CountMediaItems(activeProj)
    
    local matchFound = false
    -- if we find a match, we stop moving the screen, but we will continue to highlight other matches
    
    if allItemsCount > 0 then
        -- Prompt user for string to search
        local retval, search = reaper.GetUserInputs('Search Item Name', 1, '', '')
        
        if retval then
    
            for i = 0, allItemsCount - 1 do
                -- Get reference to item
                local item = reaper.GetMediaItem(activeProj, i)
                
                -- Get active take
                local take = reaper.GetActiveTake(item)
                
                -- Get name of item
                local takeName = reaper.GetTakeName(take)
                
                -- Make both lower case
                takeName = string.lower(takeName)
                search = string.lower(search)
                    
                
                if  takeName == search or string.find(takeName, search) then
                    -- We are looking at the correct take/item
                    
                    -- Get position of this item
                   local itemPos = reaper.GetMediaItemInfo_Value(item, 'D_POSITION')
                   local itemLength = reaper.GetMediaItemInfo_Value(item, 'D_POSITION')
                   local itemEndPos = itemPos + itemLength
                   
                   -- Set item to selected
                   reaper.SetMediaItemSelected(item, true)
                    
                    -- Move view to this item
                    local isSet = true
                    if matchFound == false then
                        reaper.GetSet_ArrangeView2(activeProj, isSet, 0, 0, itemPos, itemEndPos)
                        matchFound = true
                        reaper.UpdateTimeline()
                        break
                    end
                end
            end
        end
    else -- didn't find an item of this description
        local _, num_markers, num_regions = reaper.CountProjectMarkers(activeProj)
        local totalMarkers = num_markers + num_regions
        -- Now look through regions
        
        if num_regions > 0 then
            for i = 0, totalMarkers - 1 do
                local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers2
                                                                                            (activeProj, i)
                
                if isrgn then
                    if name == search then
                        reaper.GetSet_ArrangeView2(activeProj, isSet, 0, 0, pos, rgnend)
                        matchFound = true
                        
                        break
                    end
                end
            end
        end
    end
end


main()
