-- Usage: highlight an item (preferably just one)
-- press F3 (that's what I bind this to)
-- type in the marker name, not a region name
-- the script will suggest partial matches if it doesn't find exact matches


local activeProj = 0

function main()
    -- Count selected items
    local numOfSelItems = reaper.CountSelectedMediaItems(activeProj)
    
    if numOfSelItems > 0 then
        -- Get selected item
        local firstItem = reaper.GetSelectedMediaItem(activeProj, 0)
        
        -- Count markers
        local _, numMarkers, numRegions = reaper.CountProjectMarkers(activeProj)
        local totalMarkers = numMarkers + numRegions
        
        if totalMarkers > 0 then
            
            -- Prompt for search name
            local _, userInput = reaper.GetUserInputs('Spot to marker', 1, 'Type the marker name', '')
            
            for i = 0, totalMarkers - 1 do 
                local _, isrgn, pos, rgnend, name, markrgnid, _ = reaper.EnumProjectMarkers3(activeProj, i)
            
                if isrgn == false then
                    if name == userInput then
                        
                        reaper.SetMediaItemPosition(firstItem, pos, true)
                    else
                        -- Check for partial matches
                        local a, b = string.find(name, userInput)
                        if a and b then -- partial match found
                            local s = name
                            s = string.sub(s, a, b)
                            
                            local userAccept, userInput2 = reaper.GetUserInputs('Partial match', 1, 'Press Enter to accept', name)
                            
                            if userAccept and userInput2 == name then
                                reaper.SetMediaItemPosition(firstItem, pos, true)
                            end
                        
                        end
                    
                    end
                end
            end
        end
    end
end


main()
