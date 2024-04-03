-- Note that this script will also turn off Loop Source when touching an item

local incrementAmount = 0.1
local incrementDirection = 1

function main()
    local activeProj = 0
    
    -- Count selected items
    local numSelItems = reaper.CountSelectedMediaItems(activeProj)
    
    if numSelItems > 0 then
        for i = 0, numSelItems - 1 do
            -- Get reference to item
            local item = reaper.GetSelectedMediaItem(activeProj, i)
            
            -- Get main take of item
            local take = reaper.GetActiveTake(item)
            
            -- Turn off Loop Source
            local falso = 0
            reaper.SetMediaItemInfo_Value(item, "B_LOOPSRC", falso)
            
            -- Get current playrate value of take
            local currentPlayRate = reaper.GetMediaItemTakeInfo_Value(take, "D_PLAYRATE")
            
            local newvalue = currentPlayRate + (incrementAmount * incrementDirection)
            reaper.SetMediaItemTakeInfo_Value(take, "D_PLAYRATE", newvalue)
        end
    end
    
    -- Call UpdateTimeline to have the changes appear immediately on screen
    reaper.UpdateTimeline()
end


main()
