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
         
            -- Random playrate between 0.1 and 10
            local playRate = math.random(1, 100) / 10
            reaper.SetMediaItemTakeInfo_Value(take, 'D_PLAYRATE', playRate)
            
            -- Random pitch between -36 and 36
            local pitch = math.random(-36, 36)
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
