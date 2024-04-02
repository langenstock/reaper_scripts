-- A script that will prompt the user for a desired gap, and then space out all
-- selected items with that gap in between

-- Define the main set of instructions
function main()
    -- Set the value to 1 in case the user doesnt make a choice
    userSpecifiedGap = 1

    -- Prompt the user in a textbox for a desired gap and store as a variable
    retval, userInput = reaper.GetUserInputs('What do you want the gap to be?', 1, 'Type a number:', '')
    
    local userInputNumber = tonumber(userInput)
    -- here, userInputNumber will either be a number or nil
    
    if userInputNumber then
        userSpecifiedGap = userInputNumber
    end
    
    -- Count the number of selected items and store that number as a variable
    numOfSelectedItems = reaper.CountSelectedMediaItems(0)
    
    -- Check that we have at least 2 item selected
    if numOfSelectedItems > 1 then
    
        -- Get the first selected item and store a reference to it
        firstItem = reaper.GetSelectedMediaItem(0, 0)
        
        -- Get the starting position of the first selected item
        firstItemStartPos = reaper.GetMediaItemInfo_Value(firstItem, "D_POSITION")
        -- Get the length of the first item
        firstItemLength = reaper.GetMediaItemInfo_Value(firstItem, "D_LENGTH")
        -- Get the ending position of the first item
        previousItemEndPos = firstItemStartPos + firstItemLength
      
        
        for i = 0, numOfSelectedItems - 1, 1 do -- single = refers to an assignment
            if i == 0 then -- double == refers to a comparison
                -- do nothing
            else
                -- Move items accordingly
                
                -- Get a reference to this ith item
                local item = reaper.GetSelectedMediaItem(0, i)
                
                local newPosition = previousItemEndPos + userSpecifiedGap
                
                reaper.SetMediaItemPosition(item, newPosition, true)
                
                -- get the length of this item
                local thisItemsLength = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
                
                -- Store this item's end position (after it has moved) as a variable
                previousItemEndPos = newPosition + thisItemsLength
            end
        end
    end
end


-- Execute the main set of instructions
main()
