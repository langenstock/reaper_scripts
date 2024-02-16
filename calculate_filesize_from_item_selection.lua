local calculationsList = {
    { sr = 44100, bit = 16, channels = 1, sr_str = '44.1k' },
    { sr = 44100, bit = 24, channels = 1, sr_str = '44.1k' },
    { sr = 44100, bit = 16, channels = 2, sr_str = '44.1k' },
    { sr = 44100, bit = 24, channels = 2, sr_str = '44.1k' },
    { sr = 48000, bit = 16, channels = 1, sr_str = '48k' },
    { sr = 48000, bit = 24, channels = 1, sr_str = '48k' },
    { sr = 48000, bit = 16, channels = 2, sr_str = '48k' },
    { sr = 48000, bit = 24, channels = 2, sr_str = '48k' },
}

function main()
    local project = 0 -- 0 represents the active project, change if needed
    local itemCount = reaper.CountSelectedMediaItems(project)
    
    -- Check if there are any items in the project
    if itemCount == 0 then
        reaper.ShowMessageBox("No selected items found.", "Error", 0)
        return
    end
    
    local startPosition = math.huge
    local endPosition = -math.huge
    
    for i = 0, itemCount - 1 do
        local item = reaper.GetSelectedMediaItem(project, i)
        local active_take = reaper.GetActiveTake(item)
        
        local itemStartPosition = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local itemLength = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        local itemEndPosition = itemStartPosition + itemLength
        
        if itemStartPosition < startPosition then
            startPosition = itemStartPosition
        end
        if itemEndPosition > endPosition then
            endPosition = itemEndPosition
        end
    end
    
    local duration = endPosition - startPosition
    
    -- Check if anything has changed. If not then do nothing
    if startPosition < math.huge and endPosition > -math.huge then
        messageOutputs(duration)
    end
end

function messageOutputs(duration)
    local durationTwoDecPl = math.floor(duration * 100) / 100
    local durStr = tostring(durationTwoDecPl).. ' s'
    local sep = ' , '
    
    for _, v in ipairs(calculationsList) do
        local calculation = getCalculation(v.sr, v.bit, v.channels, duration)
        local msg = durStr .. sep .. v.sr_str .. sep .. v.bit .. ' bit, channels: ' .. v.channels .. ' : ' .. calculation .. '\n'
        reaper.ShowConsoleMsg(msg)
    end
end

function getCalculation(SR, bit, channels, duration)
    
    local sizeInKB = ((SR * bit * channels * duration)/8) / 1024
    local sizeInMB = sizeInKB / 1024
    if sizeInMB < 1 then
        return tostring(math.ceil(sizeInKB))..  ' kb'
    else
        local scaledUpMB = sizeInMB * 100
        local scaledUpMBRoundedDown = math.floor(scaledUpMB)
        local mBToTwoDecPlace = scaledUpMBRoundedDown / 100
        return tostring(mBToTwoDecPlace) .. ' mb'
    end
end

main()

