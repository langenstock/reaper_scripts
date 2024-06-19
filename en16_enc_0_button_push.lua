local activeProj = 0

function main()
    local numOfSelItems = reaper.CountSelectedMediaItems(activeProj)
    
    for i = 0, numOfSelItems - 1 do
        -- Get selected media items
        local item = reaper.GetSelectedMediaItem(activeProj, i)
        
        -- Get active take
        local take = reaper.GetActiveTake(item)
        
        -- Get take envelope for volume
        local create = true
        t_env = reaper.TakeFX_GetEnvelope(take, 0, 0x200, create)
        
        --TrackEnvelope reaper.GetTakeEnvelopeByName(MediaItem_Take take, string envname)
        
        -- command for Take: Show take volume envelope ?
    end
    
    
    
    
end


main()
