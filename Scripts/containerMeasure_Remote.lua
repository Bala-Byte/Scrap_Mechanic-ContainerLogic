dofile( "containerMeasureFunctions.lua" )

-- Seed can only be added if it gets released
InputTypes = bit.bor( sm.interactable.connectionType.water, sm.interactable.connectionType.electricity, sm.interactable.connectionType.gasoline, sm.interactable.connectionType.ammo )
RemoteContainerMeasure = class( nil )
RemoteContainerMeasure.maxChildCount = -1
RemoteContainerMeasure.maxParentCount = 1
RemoteContainerMeasure.connectionInput = InputTypes
RemoteContainerMeasure.connectionOutput = sm.interactable.connectionType.logic
-- none, logic, power, bearing, seated, piston, any, water, electricity, gasoline, ammo, !seed
RemoteContainerMeasure.colorNormal = sm.color.new( 0x054675ff )
RemoteContainerMeasure.colorHighlight = sm.color.new( 0x5a758aff )
RemoteContainerMeasure.poseWeightCount = 1

-- [[ client ]] --
--function RemoteContainerMeasure.client_onCreate( self )
--end

--function RemoteContainerMeasure.client_onRefresh( self ) 
     --self:client_onCreate()
--end

--function RemoteContainerMeasure.client_onSetupGui( self )
--end

--function RemoteContainerMeasure.client_onFixedUpdate( self, deltaTime )
--end

function RemoteContainerMeasure.client_onUpdate( self, deltaTime )
     if self.interactable.active then
          self.interactable:setUvFrameIndex(6)
     else
          self.interactable:setUvFrameIndex(0)
     end
end

--function RemoteContainerMeasure.client_onDestroy( self )
--end

-- Can disable to display "Press E to Use" by removing this function
--function RemoteContainerMeasure.client_onInteract( self )
--end

-- Will throw ERROR if initiated
--function RemoteContainerMeasure.client_canInteract(self)
--end

--function RemoteContainerMeasure.client_onProjectile( self, position, time, velocity, type )
--end

-- [[ server ]] --

--function RemoteContainerMeasure.server_onCreate( self )
     --self.shapeAttached()
--end

--function RemoteContainerMeasure.server_onRefresh( self )
     --self:server_onCreate()
--end

function RemoteContainerMeasure.server_onFixedUpdate( self, deltaTime )
     local parents = self.interactable:getParents()
     
     if #parents > 0 and parents[1]:hasOutputType( InputTypes ) then
          local containerInteractable = parents[1]
          
          --print(parents[1].shape:getInteractable():getContainer())
          if not containerInteractable:getContainer():isEmpty() then
               self.interactable.active = isContainerFull(containerInteractable)
               
               --for i=1, containerInteractable:getContainer():getSize() do
                    --print(containerInteractable:getContainer():getItem(i-1).uuid)
                    --print(containerisFull(containerInteractable, containerInteractable:getContainer():getItem(i-1)))
               --end
          end
     else
          self.interactable.active = false
     end
end

--function RemoteContainerMeasure.server_onDestroy( self )
--end

--function RemoteContainerMeasure.server_onProjectile( self, position, time, velocity, type )
--end

--function RemoteContainerMeasure.server_onSledgehammer( self, position, player )
     --self.network:sendToClients("client_updateMesh")
--end

--function RemoteContainerMeasure.server_onExplosion( self, position, destructionLevel )
--end

--function RemoteContainerMeasure.server_onCollision( self, other, position, velocity, otherVelocity, normal )
--end