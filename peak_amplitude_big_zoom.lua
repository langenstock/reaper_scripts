-- Work in Progress. Not yet functioning as intended

function bigZoom()
    -- Get the active project
    local activeProjectIndex = 0
    local activeProject = reaper.EnumProjects(activeProjectIndex, 0)
    
    local forceCast = 0
    local zoomClicks = -1 -- negative numbers zoom in, positive numbers zoom out
    --local applyToWholeProject = true
    local centremode = -1
    --reaper.adjustZoom(activeProjectIndex, forceCast, zoomClicks, centremode)
end

bigZoom()
