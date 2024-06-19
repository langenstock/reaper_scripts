-- not quite complete. Stack across tracks almost there

function main()
    local activeProj = 0

    -- Count selected items
    local numOfSelItems = reaper.CountSelectedMediaItems(activeProj)
    
    local items = {}
    if numOfSelItems > 1 then
        for i = 1, numOfSelItems do
             local j = i - 1
             
             local item = reaper.GetSelectedMediaItem(activeProj, j)
             
             local startPos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
             local length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
             local endPos = startPos + length
             
             local track = reaper.GetMediaItemTrack(item)
             
             items[i] = {item = item, pos = startPos, length = length, endPos = endPos, track = track }
        end
        
        -- Sort the table in terms of startPos
        table.sort(items, function(a, b) return a.pos < b.pos end)
        
        -- Prompt user for gaps between the items
        local retval, userInput = reaper.GetUserInputs('Specify gap between items', 1, 'Type a number', '')

        userInput = tonumber(userInput)
        local specifiedGap = nil
        
        if userInput then
            specifiedGap = userInput
        end
        
        -- Prompt the user as to whether they want to stack the items across tracks or keep separation 
        -- across tracks
        local _, userInputStack = reaper.GetUserInputs('Stack Across Tracks?', 1, 'type y for yes', '')
        local stackAcrossTracks = false
        if userInputStack == 'y' then
            stackAcrossTracks = true
        end
        
        -- Get position of leftmost item
        local firstItem = reaper.GetSelectedMediaItem(activeProj, 0)
        local firstItemPos = reaper.GetMediaItemInfo_Value(firstItem, "D_POSITION")
        
        local previousEndPos = nil
        local previousTracks = {}
        if specifiedGap then
            for i, v in ipairs(items) do
                local thisItemTrack = v.track
                local newPos
                
                if previousEndPos == nil then
                    newPos = firstItemPos
                else
                    newPos = previousEndPos + specifiedGap
                end
                
                if stackAcrossTracks then
                    local seenThisTrackBefore = false
                    local thisTrackIndex = 0
                    for i, p in ipairs(previousTracks) do
                        if thisItemTrack == p then
                            seenThisTrackBefore = true
                            thisTrackIndex = thisTrackIndex + 1
                        end
                    end
                    
                    table.insert(previousTracks, thisItemTrack)
                    
                    if seenThisTrackBefore == false then
                       
                        newPos = firstItemPos
                    else
                        --newPos = firstItemPos + (specifiedGap * thisTrackIndex)
                    end
                end
                
                reaper.SetMediaItemPosition(v.item, newPos, true)
                
                -- update previousEndPos for use in the next iteration
                previousEndPos = newPos + v.length
                previousTrack = v.track
            end
        end
    end
end


main()
