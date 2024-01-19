function setCursorToStart()  
  local project = 0
  local startPos = 0
  local moveView = true
  local seekPlay = false
  
  reaper.SetEditCurPos2(project, startPos, moveView, seekPlay)
end

setCursorToStart() 

