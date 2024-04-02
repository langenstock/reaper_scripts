coloursTable = {
    reaper.ColorToNative(255, 0, 0), -- red
    reaper.ColorToNative(0, 255, 0), -- green
    reaper.ColorToNative(41, 120, 56), -- dark green
    reaper.ColorToNative(0, 0, 255), -- blue
    reaper.ColorToNative(200, 117, 40), -- orange
    reaper.ColorToNative(218, 129, 211), -- pink
    reaper.ColorToNative(117, 97, 77), -- brown
    reaper.ColorToNative(226, 196, 44), -- yellow
}

priorityRuleOne = {
    [' v'] = reaper.ColorToNative(41, 120, 56),-- dark green
    [' d'] = reaper.ColorToNative(41, 120, 56),-- dark green
}

priorityRuleTwo = {
    -- Drums
    ['Drums'] = reaper.ColorToNative(117, 97, 77),-- brown
    ['Kick'] = reaper.ColorToNative(117, 97, 77),-- brown
    ['k '] = reaper.ColorToNative(117, 97, 77),-- brown
    ['sn '] = reaper.ColorToNative(117, 97, 77),-- brown
    ['HH'] = reaper.ColorToNative(117, 97, 77),-- brown
    ['OH '] = reaper.ColorToNative(117, 97, 77),-- brown
    
    -- Guitars
    ['Guitar'] = reaper.ColorToNative(255, 0, 0), -- red
    ['Gtr '] = reaper.ColorToNative(255, 0, 0), -- red
    
    -- Pianos and Symths
    ['Pn '] = reaper.ColorToNative(0, 255, 0), -- green
    ['Piano'] = reaper.ColorToNative(0, 255, 0), -- green
    ['Symth'] = reaper.ColorToNative(0, 255, 0), -- green
    ['Rhodes'] = reaper.ColorToNative(0, 255, 0), -- green
    ['Strings'] = reaper.ColorToNative(0, 255, 0), -- green
    
    ['Bass'] = reaper.ColorToNative(0, 0, 255),-- blue
    ['Vocals'] = reaper.ColorToNative(218, 129, 211),-- pink
    ['Vox'] = reaper.ColorToNative(218, 129, 211),-- pink
    ['BV'] = reaper.ColorToNative(218, 129, 211),-- pink
    
    ['Dx'] = reaper.ColorToNative(226, 196, 44), -- yellow
    ['ADR'] = reaper.ColorToNative(226, 196, 44), -- yellow
    ['VO'] = reaper.ColorToNative(226, 196, 44), -- yellow
    
    ['SFX'] = reaper.ColorToNative(200, 117, 40), -- orange
    ['Foley'] = reaper.ColorToNative(0, 0, 255), -- blue
    ['Atmos'] = reaper.ColorToNative(0, 255, 0), -- green
    ['Mx'] = reaper.ColorToNative(218, 129, 211), -- pink
}

function main()
    retval, userSelection = reaper.GetUserInputs('Type of Colour Scheme', 1, 'Type r for random', '')
    
    if userSelection == 'r' then
        randomiseTrackColours()
    else
        colourTracksByRules()
    end
end

function colourTracksByRules()
    -- count the tracks in the project
    local activeProject = 0
    local numOfTracks = reaper.CountTracks(activeProject)    
    
    -- using a for loop, go through each track
    for i = 0, numOfTracks - 1, 1 do
        -- get a reference to the track
        local track = reaper.GetTrack(activeProject, i)
        
        -- get the name of the track
        local retval, trName = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", '', false)
        
        local colour
        -- See if there is a match in priority rule one
        for k, v in pairs(priorityRuleOne) do
            -- pairs for loops do not traverse through the table in order
            -- they go in seemingly random order
            
            if string.find(trName, k) then
                colour = v
                --break (optional, end if the loop if we find a match)
            end
        end
        
        -- If there was not a match in rule one, then look through rule two
        if colour == nil then
            -- Look through rule two table
            for k, v in pairs(priorityRuleTwo) do
                if string.find(trName, k) then
                    colour = v
                end
            end
        end
        
        -- Only try and colour the track if we have found a match
        if colour then
            reaper.SetTrackColor(track, colour)
        end
    end
end

function randomiseTrackColours()
    
    -- Get the number of tracks in the project
    local activeProject = 0
    local numOfTracks = reaper.CountTracks(activeProject)
    
    local previousColourIndex
    
    for i = 0, numOfTracks - 1, 1 do
        -- get a reference to the track
        local track = reaper.GetTrack(activeProject, i)
        
        -- find out how many colours are in our coloursTable (#coloursTable)
        local numOfColours = #coloursTable
        
        -- pick a random integer between 1 and #coloursTable (randomIndex)
        local randomIndex = math.random(1, numOfColours)
        
        -- use that index to pick a colour
        
        -- If randomIndex is the same as the index of the previous colour used,         
        if randomIndex == previousColourIndex then
            -- if the index is 2 or more
            if randomIndex > 1 then
            
              -- move one index up in the table
                randomIndex = randomIndex - 1
            -- however if the index is 1
            elseif randomIndex == 1 then
                randomIndex = #coloursTable
                -- change the index to #coloursTable
            end
        end
        
        -- Get the actual colour from the coloursTable
        local randomColour = coloursTable[randomIndex]        
                
        -- Keep track of this colour to compare it to the colour chosen in the next
          -- iteration of the loop
        previousColourIndex = randomIndex
        
        -- colour the track that random colour
        reaper.SetTrackColor(track, randomColour)
    end
end



main()
