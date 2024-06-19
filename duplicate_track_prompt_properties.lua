function main()
    -- count selected tracks
    local activeProj = 0
    local numOfSelectedTracks = reaper.CountSelectedTracks(activeProj)
    
    if numOfSelectedTracks > 0 then
    
        -- Make a reference of all current tracks
        local totalNumTracks = reaper.GetNumTracks()
        local allTracksBeforeDupe = {}
        for i = 0, totalNumTracks - 1 do
            local track = reaper.GetTrack(activeProj, i)
            allTracksBeforeDupe[track] = 'i exist'
        end
    
        local _, userInputMedia = reaper.GetUserInputs("Copy media?", 1, 'Type y for yes', '')
        
        -- Run basic duplicate track command
        local duplicateTrackCommandId = 40062
        local flag = 0
        reaper.Main_OnCommandEx(duplicateTrackCommandId, flag, activeProj)
        
        if userInputMedia == 'y' then

        else
            local newTotalNumTracks = reaper.GetNumTracks()
            local newTrackReference
            for i = 0, newTotalNumTracks - 1 do
                local track = reaper.GetTrack(activeProj, i)
                if not allTracksBeforeDupe[track] then
                    newTrackReference = track -- reference to the newly created track
                end
            end
            
            local allMediaItemsCount = reaper.CountMediaItems(activeProj)
            for i = 0, allMediaItemsCount - 1 do
                local item = reaper.GetMediaItem(activeProj, i)
                local thisTrack = reaper.GetMediaItemTrack(item)
                
                if thisTrack == newTrackReference then
                    reaper.DeleteTrackMediaItem(thisTrack, item)
                end
            end
        end
    end
end
--[[
function clearAllItemsFromTrack()
    -- Get total number of tracks
    local totalNumTracks = reaper.GetNumTracks()
    local newTrackIndex = totalNumTracks
    
    local wantDefaults = true
    reaper.InsertTrackAtIndex(newTrackIndex, wantDefaults)
    
    local newTrack = reaper.GetTrack(activeProj, newTrackIndex)
    
    -- Prompt the user for a new name
    local userOK, newTrackName = reaper.GetUserInputs("Rename New Track", 1, "New Track Name:,extrawidth=200", "")
    if not userOK then
        newTrackName = ''
    end

    reaper.GetSetMediaTrackInfo_String(newTrack, "P_NAME", newTrackName, true) -- true means set new value
end
]]

main()
