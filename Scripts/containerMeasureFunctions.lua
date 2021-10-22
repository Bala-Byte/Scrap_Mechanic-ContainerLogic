function isContainerFull( container )
     if sm.container.canCollect( container.shape:getInteractable():getContainer(), container.shape:getInteractable():getContainer():getItem(1).uuid, 1 ) then
          return false
     end
     return true
end