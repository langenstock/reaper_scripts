local DEBUG_CONSOLE_ON = false -- Change this to true in order to spam console with info about the controller being touched

local activeProj = 0
local linearPlus_1dB = 1.122
local linearMinus_1dB = 0.89
local linearValuePlus50dB = 316.2
local linearValueMinus50dB = 0.0028

function clamp(a, min, max)
    if a > min then
        return math.min(a, max)
    elseif a < max then
        return math.max(a, min)
    else
        return a
    end
end
--[[
function nudgeItemVolume(val, items)
    for i, v in ipairs(items) do
        local item = v.item
        
        -- Get active take
        local take = reaper.GetActiveTake(item)

        -- Get current take vol value
        local currentVol = reaper.GetMediaItemTakeInfo_Value(take, 'D_VOL')
        

        local newvalue
        if val == 0.0 then
            newvalue = currentVol * linearMinus_1dB
        
        elseif val == 1.0 then
            newvalue = currentVol * linearPlus_1dB
        
        end

        if newvalue then
            -- clamp value to between -50 and +50 db
            newvalue = clamp(newvalue, linearValueMinus50dB, linearValuePlus50dB)
            reaper.SetMediaItemTakeInfo_Value(take, 'D_VOL', newvalue)
        end

    end
    reaper.UpdateTimeline()
end]]

function nudgePlayRate(val, items)
    for i, v in ipairs(items) do

        local take = reaper.GetActiveTake(v.item)
        local currentPlayRate = reaper.GetMediaItemTakeInfo_Value(take, 'D_PLAYRATE')

        local newvalue
        if val == 0.0 then
            if currentPlayRate > 1 then
                newvalue = currentPlayRate - 0.2
            else
                newvalue = currentPlayRate * 0.9
            end
        elseif val == 1.0 then
            if currentPlayRate > 1 then
                newvalue = currentPlayRate + 0.2
            else
                newvalue = currentPlayRate * 1.1
            end
        end

        if newvalue then
            reaper.SetMediaItemTakeInfo_Value(take, 'D_PLAYRATE', newvalue)
        end
    end
    reaper.UpdateTimeline()
end
--[[
function nudgeItemPitch(val, items)
    for i, v in ipairs(items) do

        local take = reaper.GetActiveTake(v.item)
        local currentPitch = reaper.GetMediaItemTakeInfo_Value(take, 'D_PITCH')

        local newValue
        if val == 0.0 then
            newValue = currentPitch - 0.5
        elseif val == 1.0 then
            newValue = currentPitch + 0.5
        end

        if newValue then
            reaper.SetMediaItemTakeInfo_Value(take, 'D_PITCH', newValue)
        end
    end
    reaper.UpdateTimeline()
end
--[[
function adjustSelectedTrackVol(val, items)
    local previousItemTrack = nil

    for i, v in ipairs(items) do

        -- Get the item's track
        local track = reaper.GetMediaItem_Track(v.item)
        
        -- Check if we have touched this track already
        if previousItemTrack ~= track then

            -- Get current track vol
            local currentVol = reaper.GetMediaTrackInfo_Value(track, 'D_VOL')

            local newvalue
            if val == 0.0 then
                newvalue = currentVol * linearMinus_1dB
            elseif val == 1.0 then
                newvalue = currentVol * linearPlus_1dB
            end

            if newvalue then
                reaper.SetMediaTrackInfo_Value(track, 'D_VOL', newvalue)
            end

            previousItemTrack = track
        end
    end
end


function adjustSelectedTrackPan(val, items)
    local previousItemTrack = nil

    for i, v in ipairs(items) do

        -- Get the item's track
        local track = reaper.GetMediaItem_Track(v.item)
        
        -- Check if we have touched this track already
        if previousItemTrack ~= track then

            -- Get current track vol
            local currentPan = reaper.GetMediaTrackInfo_Value(track, 'D_PAN')

            local newvalue
            if val == 0.0 then
                newvalue = currentPan - 0.01
            elseif val == 1.0 then
                newvalue = currentPan + 0.01
            end

            if newvalue then
                reaper.SetMediaTrackInfo_Value(track, 'D_PAN', newvalue)
            end

            previousItemTrack = track
        end
    end
end]]
--[[
local shelfTypes = {
    lowShelf = 1,
    highShelf = 4,
}

local eqParams = {
    gain = 1,
    freq = 0,
}

function trackEffectsShelfGain(val, items, shelf, parameterId) -- parameterId refers to gain, freq or Q
    local previousItemTrack = nil

    for i, v in ipairs(items) do

        -- Get the item's track
        local track = reaper.GetMediaItem_Track(v.item)
        
        -- Check if we have touched this track already
        if previousItemTrack ~= track then

            -- Get the index of the EQ, if it is not in the effects list, this will add it automatically
            local instantiate = true
            local eqTrackFXIndex = reaper.TrackFX_GetEQ(track, instantiate)

            local normval
            -- Get current Gain Value
            if shelf == shelfTypes.lowShelf then
                retval, bandtype, bandidx, paramtype, normval = reaper.TrackFX_GetEQParam(track, eqTrackFXIndex, parameterId) -- this only works for low shelf
            else

                -- AT the time of writing this, bands other than the low shelf are not very well supported in lua
                -- check the API at a later date for potential updates to the TrackFX_GetEQParam function :(
            end

            if normval then

                local newValue
                if parameterId == eqParams.gain then
                    if val == 0.0 then
                        newValue = normval * linearMinus_1dB
                    elseif val == 1.0 then
                        newValue = normval * linearPlus_1dB
                    end
                elseif parameterId == eqParams.freq then
                    if val == 0.0 then 
                        newValue = normval - 0.01
                    elseif val == 1.0 then
                        newValue = normval + 0.01
                    end
                end

                local isNorm = true
                


                bandidx = 0
                reaper.TrackFX_SetEQParam(track, eqTrackFXIndex, shelf, bandidx, parameterId, newValue, isNorm)

                reaper.TrackFX_SetOpen(track, eqTrackFXIndex, true)

                previousItemTrack = track
            else
                reaper.ShowConsoleMsg('Error: No value extracted from current EQ instance\n')
            end
        end
    end
end
]]

function main()
    -- Count Selected Items
    local numOfSelItems =  reaper.CountSelectedMediaItems(activeProj)
    
    if numOfSelItems > 0 then

        local isNewVal, fileName, sectionID, cmdID, mode, res, val, contextStr =  reaper.get_action_context()
        
        if contextStr and val then
            contextStr = tostring(contextStr)
            
            -- Get a table of all selected items
            local items = {}
            local earliestTime = math.huge
            for i = 0, numOfSelItems - 1 do
                local j = i + 1
                local item = reaper.GetSelectedMediaItem(activeProj, i)
                items[j] = { item = item }

                -- Get pos
                local pos = reaper.GetMediaItemInfo_Value(item, 'D_POSITION')
                if pos < earliestTime then
                    earliestTime = pos
                end
            end

            nudgePlayRate(val, items)

            val, contextStr = nil, nil

            -- Set playback head to the start of item selections
            if earliestTime ~= math.huge then
                reaper.SetEditCurPos2(activeProj, earliestTime, true, false)
            end
        end
        
        -- Spam console with info about controller values being touched
        if DEBUG_CONSOLE_ON then
            debugConsole(isNewVal, fileName, sectionID, cmdID, mode, res, val, contextStr)
        end
    end
end



function debugConsole(isNewVal, fileName, sectionID, cmdID, mode, res, val, contextStr)
    local msg = '' 
    
    if cmdID then
        msg = msg .. 'cmdID: '..cmdID
    end
    
    if val then 
        msg = msg .. 'val: '..val
    end
    
    if sectionID then
        msg = msg ..  ' sectionID: '..sectionID
    end
    
    if mode then
        msg = msg .. ' mode: '..mode
    end
    
    if res then
        msg = msg .. ' res: '..res
    end
    
    if contextStr then
        msg = msg .. ' contextStr: '..contextStr
    end
    
    if msg ~= '' then
        msg = msg .. '\n\n'
        reaper.ShowConsoleMsg(msg)
    end
end


main()

