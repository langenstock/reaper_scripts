-- Specify the plugin name you want to insert
-- NOTE - at the moment this doesn't facilitate adding the plugin to index 2 if there is already takeFX active
-- NOTE - at the moment, this doesn't quite work if you have multiple reaper projects and if it is not the first in the tab

local pluginName = 'Pro-R 2'

function insertItemPropertiesFX()
    -- Get the active project
    local activeProjectIndex = 0
    local activeProject = reaper.EnumProjects(activeProjectIndex, 0)
    
    -- Get the selected item
    local selectedItem = reaper.GetSelectedMediaItem(activeProject, 0)
    
    -- Check if a valid item is selected
    if selectedItem then
        -- Get the first take of the selected item
        local take = reaper.GetMediaItemTake(selectedItem, 0)
    
        -- Check if a valid take is present
        if take then
            -- Get the take FX count
            local fxCount = reaper.TakeFX_GetCount(take)
    
            -- Search for the plugin in the plugin list
            local pluginIndex = reaper.TakeFX_AddByName(take, pluginName, 1)
    
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
        reaper.ShowMessageBox("No item selected.", "Error", 0)
    end
end


insertItemPropertiesFX()

