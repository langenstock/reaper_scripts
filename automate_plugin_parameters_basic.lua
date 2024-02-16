-- Automate Plugin Parameters Script

local numberOfAutomationNodes

function main()

    local track = reaper.GetSelectedTrack(0, 0)
    if track then
        -- Get the number of selected items on the track
        local numSelectedItems = reaper.CountTrackMediaItems(track)
        
        -- Initialize variables for start and end positions
        local startPosition = math.huge
        local endPosition = -math.huge
        
        if numSelectedItems > 0 then
            
            -- Iterate through selected items to find start and end positions
            for i = 0, numSelectedItems - 1 do
                local item = reaper.GetTrackMediaItem(track, i)
                local itemStartPosition = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
                local itemLength = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
                local itemEndPosition = itemStartPosition + itemLength

                -- Update start position if current item's start position is earlier
                if itemStartPosition < startPosition then
                    startPosition = itemStartPosition
                end
        
                -- Update end position if current item's end position is later
                if itemEndPosition > endPosition then
                    endPosition = itemEndPosition
                end
           end
        end

        local _, userInputEnvelopeIndex = reaper.GetUserInputs("User Input", 1, "Which lane?", "")
        local envelopeIndex = tonumber(userInputEnvelopeIndex)
        if envelopeIndex then
            envelope = reaper.GetTrackEnvelope(track, envelopeIndex)
            if envelope then
                local pluginIndex = 0  -- Adjust based on the plugin you want to automate
                local parameterIndex = 0  -- Adjust based on the parameter you want to automate
        
                --local projectLength = math.floor(reaper.GetProjectLength())
                
                local _, userInputAutomationPoints = reaper.GetUserInputs("User Input", 1, "How many nodes, brodes?", "")
                numberOfAutomationNodes = tonumber(userInputAutomationPoints)
                
                --local selectionLength = endPosition - startPosition
                --local randomPositionOffset = math.random(0, math.ceil(selectionLength))
                --local automationNodePosition = startPosition + randomPositionOffset
                local automationNodePosition = math.random(math.floor(startPosition), math.ceil(endPosition))
                
                for i = 1, numberOfAutomationNodes do
                    --local endTime = math.floor(reaper.GetProjectLength())
                    local automationNodeValue = math.random()
                    reaper.InsertEnvelopePoint(envelope, automationNodePosition, automationNodeValue, 0, 0, false, false)
                    --local _, value = reaper.Envelope_Evaluate(envelope, automationNodePosition, 0, 0)
                    --reaper.InsertEnvelopePoint(envelope, automationNodePosition, automationNodeValue, 0, 0, false, false)
                    --reaper.GetSetAutomationItemInfo(envelope, 0, "", automationNodePosition, math.floor(endPosition), 1)
                    local str = 'node inserted at: '..automationNodePosition..' , startPosition: '..startPosition .. ' , endPosition: '..endPosition
                    reaper.ShowConsoleMsg(str.."\n")
                end
             end
        end
    end
    
    -- Type y to repeat the process again
    local _, userInputContinuePrompt = reaper.GetUserInputs("User Input", 1, "Type y to continue", "")
    return userInputContinuePrompt
end


while main() == 'y' do end


