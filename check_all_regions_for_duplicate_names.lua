-- Note, needs work. Doesn't correctly identify duplicate entries

function main()
    local project = 0 -- reaper.GetProject(0)
    local _, numMarkers, numRegions = reaper.CountProjectMarkers(project)
    
    local regions = {}
    local nameAndShame = {}
    
    for i = 0, numRegions - 1 do
        local _, isrgn, position, _, name, _ = reaper.EnumProjectMarkers3(project, i)

        if isrgn then
            table.insert(regions, { name = name, position = position})
        end
        
    end
    
    local str = 'test:  name: '..regions[1].name
    reaper.ShowMessageBox(str, "Error", 0)
    return

    -- Check for duplicates
    for i, r in ipairs(regions) do
        for j, reg in ipairs(regions) do
            if r.name == reg.name then
                local str = 'match found '..reg.name..' '..r.name
                return
                table.insert(nameAndShame, { name = r.name, position = r.position })
            end
        end
    end

    local str = 'Duplicates: '
    if #nameAndShame > 0 then
        for i, r in ipairs(nameAndShame) do
            local name = r.name
            local pos = r.position
            str = str .. 'name: '..r.name .. ', pos: '..r.position .. '. '
        end
    elseif #nameAndShame == 0 then
        str = 'good job'
    end
    reaper.ShowMessageBox(str, "Error", 0)
end
    
main()
