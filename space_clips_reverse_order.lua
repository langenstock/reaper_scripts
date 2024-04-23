function main()
    local activeProj = 0

    -- Count selected items
    local numOfSelItems = reaper.CountSelectedMediaItems(activeProj)
    
    local items = {}
    if numOfSelItems > 0 then
        for i = 1, numOfSelItems do
             local j = i - 1
             
             local item = reaper.GetSelectedMediaItem(activeProj, j)
             
             local startPos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
             
             items[i] = {item = item, pos = startPos}
        end
        
        -- Sort the table in terms of startPos
        table.sort(items, function(a, b) return a.pos > b.pos end)
        
        -- Prompt user for gaps between the items
        local retval, userInput = reaper.GetUserInputs('Specify gap between items', 1, 'Type a number', '')

        userInput = tonumber(userInput)
        local specifiedGap = nil
        
        if userInput then
            specifiedGap = userInput
        end
        
        -- Get position of leftmost item
        local firstItem = reaper.GetSelectedMediaItem(activeProj, 0)
        local firstItemPos = reaper.GetMediaItemInfo_Value(firstItem, "D_POSITION")
        
        if specifiedGap then
            for i, v in ipairs(items) do
                local newPos = firstItemPos + (specifiedGap * (i - 1))
                
                reaper.SetMediaItemPosition(v.item, newPos, true)
            end
        end
    end
end


main()
