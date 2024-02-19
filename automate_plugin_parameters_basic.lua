-- Automate Plugin Parameters Script

local numberOfAutomationNodes
local b_firstTimeThrough = true

local laneProcessedAlready = {}

function main()
    local track = reaper.GetSelectedTrack(0, 0)
    if track then
        -- Get the number of selected items on the track
        local numSelectedItems = reaper.CountTrackMediaItems(track)
        
        -- Initialize variables for start and end positions
        local startPosition = math.huge
        local endPosition = -math.huge
        
        -- Iterate through selected items to find total start and end positions
        if numSelectedItems > 0 then
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
        else
            -- We break this loop if there are no items selected
            return 'n'
        end
        
        if numSelectedItems > 0 then
            local _, userInputEnvelopeIndex = reaper.GetUserInputs("User Input", 1, "Which lane?", "")
            local envelopeIndex = tonumber(userInputEnvelopeIndex)
            
            if envelopeIndex then
                envelope = reaper.GetTrackEnvelope(track, envelopeIndex)
                if envelope then
                
                    -- Store the automation values at the start and end now
                    local _, startPositionAutomationValue = reaper.Envelope_Evaluate(envelope, startPosition, 0, 0)
                    local _, endPositionAutomationValue = reaper.Envelope_Evaluate(envelope, endPosition, 0, 0)
                
                    local pluginIndex = 0  -- Adjust based on the plugin you want to automate
                    local parameterIndex = 0  -- Adjust based on the parameter you want to automate
                    
                    local _, userInputAutomationPoints = reaper.GetUserInputs("User Input", 1, "How many nodes, brodes?", "")
                    numberOfAutomationNodes = tonumber(userInputAutomationPoints)
                    
                    local _, userInputMinValue = reaper.GetUserInputs("User Input", 1, "Minimum Value between 0 and 1?", "")
                    local minimumValue = tonumber(userInputMinValue) or 0
                    
                    local _, userInputMaxValue = reaper.GetUserInputs("User Input", 1, "Maximum Value between 0 and 1?", "")
                    local maximumValue = tonumber(userInputMaxValue) or 1
                    
                    if numberOfAutomationNodes then
                        for i = 1, numberOfAutomationNodes do
                            --local endTime = math.floor(reaper.GetProjectLength())
                            local automationNodePosition = math.random(math.ceil(startPosition), math.floor(endPosition))
                            if automationNodePosition < endPosition then
                                automationNodePosition = automationNodePosition - math.random()
                            elseif automationNodePosition > startPosition then
                                automationNodePosition = automationNodePosition + math.random()
                            end
                            
                            while(automationNodePosition < startPosition) 
                            do
                                automationNodePosition = automationNodePosition + math.random()
                            end
                            
                            while(automationNodePosition > endPosition) 
                            do
                                automationNodePosition = automationNodePosition - math.random()
                            end
                            
                            local automationNodeValue = math.random()
                            
                            while (automationNodeValue < minimumValue) or (automationNodeValue > maximumValue)
                            do
                                automationNodeValue = math.random()
                            end
                            
                            reaper.InsertEnvelopePoint(envelope, automationNodePosition, automationNodeValue, 0, 0, false, false)
            
                            local str = 'node inserted at: '..automationNodePosition..' , startPosition: '..startPosition .. ' , endPosition: '..endPosition
                            reaper.ShowConsoleMsg(str.."\n")
                        end
                        if not laneProcessedAlready[envelopeIndex] then
                          -- Put in a start and end node to preserve values before and after our timeline affected area
                          reaper.InsertEnvelopePoint(envelope, startPosition, startPositionAutomationValue, 0, 0, false, false)
                          reaper.InsertEnvelopePoint(envelope, endPosition, endPositionAutomationValue, 0, 0, false, false)
                          laneProcessedAlready[envelopeIndex] = true
                        end
                    end
                end
            end
        end
    end
    
    -- Type y to repeat the process again
    local _, userInputContinuePrompt = reaper.GetUserInputs("User Input", 1, "Type y to continue", "")
    return userInputContinuePrompt
end

while main() == 'y' do end


