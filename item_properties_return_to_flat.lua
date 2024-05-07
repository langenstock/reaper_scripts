-- Returns item vol, pitch and playrate to normal

local activeProj = 0

function main()
    -- Get selected items
    local numOfSelItems = reaper.CountSelectedMediaItems(activeProj)
    
    if numOfSelItems > 0 then
        local earliestTime = math.huge
        for i = 0, numOfSelItems - 1 do
    
            -- Get media item reference
            local item = reaper.GetSelectedMediaItem(activeProj, i)
            
            -- Get pos
            local pos = reaper.GetMediaItemInfo_Value(item, 'D_POSITION')
            if pos < earliestTime then
                earliestTime = pos
            end            
            
            -- Get active take
            local take = reaper.GetActiveTake(item)
            
            -- Set vol to 0 dB
            local linear_0dB = 1
            reaper.SetMediaItemTakeInfo_Value(take, 'D_VOL', linear_0dB)
         
            -- set playrate to 1
            local playRate = 1
            reaper.SetMediaItemTakeInfo_Value(take, 'D_PLAYRATE', playRate)
            
            -- set pitch to 0
            local pitch = 0
            reaper.SetMediaItemTakeInfo_Value(take, 'D_PITCH', pitch)
        end
        reaper.UpdateTimeline()
        
        -- Set playback head to the start of item selections
        if earliestTime ~= math.huge then
            reaper.SetEditCurPos2(activeProj, earliestTime, true, false)
        end        
    end
end


main()
