function main()
    -- Count selected items
    local numOfSelItems = reaper.CountSelectedMediaItems(activeProj)
    
    if numOfSelItems > 0 then
        -- Get selected item
        local firstItem = reaper.GetSelectedMediaItem(activeProj, 0)
        
        local retval, userInput = reaper.GetUserInputs('Spot to Time', 1, 'Time in seconds', '')
        
        if retval and tonumber(userInput) then
            local timeToMoveTo = tonumber(userInput)
            reaper.SetMediaItemPosition(firstItem, timeToMoveTo, true)
        end
    end
end


main()

