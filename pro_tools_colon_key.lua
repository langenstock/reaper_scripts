-- Bind to ; to emulate Pro Tools behaviour
-- The script will highlight tracks that the playback head 'passes through'
-- this doesnt necessarily emulate Pro Tools behaviour, but it does facilitate some of the intended usages of this hotkey

function main()
    local activeProj = 0
    local trackCurrentlySelected = reaper.GetSelectedTrack(activeProj, 0)
    
    if trackCurrentlySelected then
        local numTracks = reaper.CountTracks(activeProj)
       
        for i = 0, numTracks - 1 do
            local track = reaper.GetTrack(activeProj, i)
            
            if track == trackCurrentlySelected then
                local nextTrackId = i + 1
                if nextTrackId == numTracks then
                    nextTrackId = numTracks - 1
                end
                
                local trackToHighlight = reaper.GetTrack(activeProj, nextTrackId)
                reaper.SetTrackSelected(trackCurrentlySelected, false)
                reaper.SetTrackSelected(trackToHighlight, true)
                
                local playPos = reaper.GetCursorPosition()
                
                local numOfItems = reaper.CountMediaItems(activeProj)
                for i = 0, numOfItems - 1 do
                    local item = reaper.GetMediaItem(activeProj, i)
                    
                    local startPos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
                    local length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
                    local endPos = startPos + length
                    
                    if playPos > startPos and playPos < endPos then
                    
                        local trackInRange = reaper.GetMediaItem_Track(item)
                        if trackInRange == trackToHighlight then
                            reaper.SetMediaItemSelected(item, true)
                        else
                            reaper.SetMediaItemSelected(item, false)
                        end
                    else
                        reaper.SetMediaItemSelected(item, false)
                    end
                end
            end
        end
    end
    reaper.UpdateTimeline()
end


main()


