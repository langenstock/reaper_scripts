-- Specify the plugin name you want to insert

local pluginName = 'Pro-Q 3'

function insertItemPropertiesFX()
    -- Get the active project
    local activeProjectIndex = 0
    local activeProject = reaper.EnumProjects(activeProjectIndex, 0)
    
    -- Get the selected item
    local selectedItem = reaper.GetSelectedMediaItem(activeProjectIndex, 0)
    
    -- Check if a valid item is selected
    if selectedItem then
        -- Get the first take of the selected item
        local take = reaper.GetMediaItemTake(selectedItem, 0)
    
        -- Check if a valid take is present
        if take then
            -- Get the take FX count
            local fxCount = reaper.TakeFX_GetCount(take)
    
            -- Search for the plugin in the plugin list
            local nextAvailableSlot = -1
            local pluginIndex = reaper.TakeFX_AddByName(take, pluginName, nextAvailableSlot)
    
            -- Check if the plugin was successfully inserted
            if pluginIndex ~= -1 then
                reaper.TakeFX_SetEnabled(take, pluginIndex, true) -- Enable the plugin
                reaper.TakeFX_SetOpen(take, pluginIndex, true) -- Open the plugin UI
            else
                reaper.ShowMessageBox("Plugin not found in the list.", "Error", 0)
            end
        else
            reaper.ShowMessageBox("No valid take found.", "Error", 0)
        end
    else
        -- If we are not selecting any item, then we want to see if we have a track selected
        local numOfSelTracks = reaper.CountSelectedTracks(activeProjectIndex)
        
        if numOfSelTracks > 0 then
            
            local firstSelTrack = reaper.GetSelectedTrack(activeProjectIndex, 0)
        
            local _, userConfirm = reaper.GetUserInputs('About to add plugin to Track Insert', 1, 'Press y to continue', '')
            
            --if userConfirm == 'y' then
            --    reaper.TrackFX_AddByName(firstSelTrack, pluginName, false, -1)
            --end
        end
    end
end


insertItemPropertiesFX()

