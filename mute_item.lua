-- A script that will combine item mute and item unmute into a single shortcut

function main()
    local project = 0
    local muteCommand = 40719
    
    local unmuteCommand = 40720
    
    local item = reaper.GetSelectedMediaItem(project, 0) -- hard set to first selected item for now
    if item then
        local muted = reaper.GetMediaItemInfo_Value(item, "B_MUTE")
        
        if muted == 1 then
            reaper.Main_OnCommandEx(unmuteCommand, 0, project)
        elseif muted == 0 then
            reaper.Main_OnCommandEx(muteCommand, 0, project)
        end
    end
end

main()
