function main()
    local _, textInputFreq = reaper.GetUserInputs("Input Base Frequency", 1, "Base Frequency:,extrawidth=200", "")
    local baseFrequency = tonumber(textInputFreq)
    if baseFrequency then
        local _, textInputInterval = reaper.GetUserInputs("Interval", 1, "Interval:,extrawidth=200", "")
        local interval = tonumber(textInputInterval)
        if interval then
            printOutcome(baseFrequency, interval) 
        end
    end
end

function printOutcome(freq, interval)
    local baseFreq = freq
    local toThePowOf = interval / 12
    local calcFreq = baseFreq * math.pow(2, toThePowOf)
    local msg = 'Base Freq: '..baseFreq..' Hz, Interval: '


    reaper.ShowMessageBox("Base:, "Error", 0)
end


main()
