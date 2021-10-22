dofile("$SURVIVAL_DATA/Scripts/game/survival_items.lua")
dofile( "$SURVIVAL_DATA/Scripts/util.lua" )
dofile( "containerMeasureFunctions.lua" )

stickyContainerMeasure = class( nil )
stickyContainerMeasure.maxChildCount = -1
stickyContainerMeasure.maxParentCount = 0
stickyContainerMeasure.connectionInput = sm.interactable.connectionType.none
stickyContainerMeasure.connectionOutput = sm.interactable.connectionType.logic
-- none, logic, power, bearing, seated, piston, any, water, electricity, gasoline, ammo, !seed
stickyContainerMeasure.colorNormal = sm.color.new( 0x054675ff )
stickyContainerMeasure.colorHighlight = sm.color.new( 0x5a758aff )
--stickyContainerMeasure.poseWeightCount = 2

-- [[ client ]] --
function stickyContainerMeasure.client_onCreate( self )
     --self.interactable:setUvFrameIndex( 6 )
end

-- -dev only function
--function stickyContainerMeasure.client_onRefresh( self ) 
     --self:client_onCreate()
--end

--function stickyContainerMeasure.client_onSetupGui( self )
--end

--function stickyContainerMeasure.client_onFixedUpdate( self, deltaTime )
--end

--function stickyContainerMeasure.client_onUpdate( self, deltaTime )
--end

--function stickyContainerMeasure.client_onDestroy( self )
--end

--[[ local activeMesh = 0
function stickyContainerMeasure.client_updateMesh( self )
     self.shape:getInteractable():setPoseWeight( 0, activeMesh )
     if(activeMesh == stickyContainerMeasure.poseWeightCount) then
          activeMesh = 0
     else
          activeMesh = activeMesh + 1
     end
end ]]

--function stickyContainerMeasure.client_onInteract( self )
     --self.interactable:setUvFrameIndex( (sm.interactable.getUvFrameIndex(self.interactable) + 1) % 6 )
     --print("Mode:", 5 - sm.interactable.getUvFrameIndex(self.interactable))
--end

-- Will throw ERROR if initiated
--function stickyContainerMeasure.client_canInteract(self)
--end

function stickyContainerMeasure.client_changeDisplay( self )
     if self.connectedContainer == nil then
          self.interactable:setUvFrameIndex( 5 )
     elseif self.connectedContainer == false then
          self.interactable:setUvFrameIndex( 4 )
     else
          self.interactable:setUvFrameIndex( 0 )
     end
end

function stickyContainerMeasure.client_lightUpPipes( self, pipeShape )
     print( pipeShape:getInteractable():getUvFrameIndex() )
     pipeShape:getInteractable():setUvFrameIndex( 6 )
     pipeShape:getInteractable():setGlowMultiplier( 2 )
end

--function stickyContainerMeasure.client_onProjectile( self, position, time, velocity, type )
--end

-- [[ server ]] --

function stickyContainerMeasure.server_onCreate( self )
     self:shapeAttached()
end

--function stickyContainerMeasure.server_onRefresh( self )
     --self:server_onCreate()
--end

CompatibleContainerUuids = {
     obj_container_gas,
     obj_container_battery,
     obj_container_water,
     obj_container_seed,
     obj_container_fertilizer,
     obj_container_ammo,
     obj_container_chemical,

     obj_container_chest,
}

PipeUuids = {
     obj_pneumatic_pipe_01,
     obj_pneumatic_pipe_02,
     obj_pneumatic_pipe_03,
     obj_pneumatic_pipe_04,
     obj_pneumatic_pipe_05,
     obj_pneumatic_pipe_bend,
}

function stickyContainerMeasure.server_onFixedUpdate( self, deltaTime )
     -- Calls on shape changed (shape = entire contraption this is on)
     if  self.shape:getBody():hasChanged( sm.game.getCurrentTick() - 1 ) then
          self:shapeAttached()
	end

     if self.connectedContainer then
          self.interactable.active = isContainerFull( self.connectedContainer:getInteractable() )
     end

     -- Check attached containers
     --[[ for id, pipedShape in pairs( self.shape:getPipedNeighbours() ) do
          if valueExists( CompatibleContainerUuids, pipedShape:getShapeUuid() ) then
               self.interactable.active = isContainerFull( pipedShape:getInteractable().shape:getInteractable() )
               -- Else: display an X on the container screen
          end
     end ]]
end

function stickyContainerMeasure.shapeAttached( self )
     if self.shape:getPipedNeighbours()[1] then
          if valueExists( CompatibleContainerUuids, self.shape:getPipedNeighbours()[1]:getShapeUuid() ) then
               self.connectedContainer = self.shape:getPipedNeighbours()[1]
          else
               -- Calling search from the only output
               self.connectedContainer = self:recursiveSearch( self.shape, self.shape:getPipedNeighbours()[1] )
          end
     else
          self.connectedContainer = nil
          self.interactable.active = false
          
     end
     
     self.network:sendToClients( 'client_changeDisplay' )
     print( self.connectedContainer )
end

function stickyContainerMeasure.recursiveSearch( self, previousShape, checkedShape )
     if checkedShape == nil then
          return checkedShape
     end

     for id, pipedShape in pairs( checkedShape:getPipedNeighbours() ) do
          if pipedShape ~= previousShape then
               --self.network:sendToClients( 'client_lightUpPipes', pipedShape )
               if valueExists( CompatibleContainerUuids, pipedShape:getShapeUuid() ) then
                    return pipedShape
               else
                    -- Check if pipe to avoid searching trough craft bot (If needed)
                    return self:recursiveSearch( checkedShape, pipedShape )
               end
          end
     end

     return false
end

--function stickyContainerMeasure.server_onDestroy( self )
--end

--function stickyContainerMeasure.server_onProjectile( self, position, time, velocity, type )
--end

--function stickyContainerMeasure.server_onSledgehammer( self, position, player )
     --self.network:sendToClients( "client_updateMesh" )
--end

--function stickyContainerMeasure.server_onExplosion( self, position, destructionLevel )
--end

--function stickyContainerMeasure.server_onCollision( self, other, position, velocity, otherVelocity, normal )
--end