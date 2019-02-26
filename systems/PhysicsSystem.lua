local PhysicsSystem = System({Body, "withBody"}, {Body, Player, "player"}, {Body, Drawable, "drawable"})--, {Body, Movement, Upright, "withUpright"})
	physicsSystem = PhysicsSystem()
	function PhysicsSystem:update(dt)
		local dt = 1/60
		for k, v in pairs(self.withBody.objects) do
			local body = v:get(Body)
			local collider = body.Collider
			--collider:applyForce(10000, 0)
			--local damp = 4
			--collider:setLinearDamping(damp)
			local velX, velY = collider:getLinearVelocity()
			--517.7994
			--if body.isGrounded then
				--print(damp-dt*100)
			--print((dt^dt)/damp)
			--wlocal m = (damp/(1+damp))
			--collider:applyForce(-velX*m, -velY*m)
			--collider:setLinearVelocity(velX-velX*m, velY-velY*m)
			--collider:setLinearVelocity(velX-velX*damp*dt/(1+dt*damp), velY-velY*damp*dt/(1+damp*dt))
				---velY*dt*damp)
			--end
			--if body.Position.x > 3000 or body.Position.x < -3000 or body.Position.y < -400 then
			--	GameInstance:removeEntity(v)
			--end
			local posX, posY = collider:getPosition()
			body.Position, body.Velocity, body.Angle =
			Vector2.new(posX, posY), Vector2.new(collider:getLinearVelocity()), collider:getAngle()
		end
		--[[for k, v in pairs(self.player.objects) do
			local body = v:get(Body)
			print(body.Velocity)
		end]]
		--[[for k, v in pairs(self.withUpright.objects) do
			local body = v:get(Body)
			local collider = body.Collider
			local movement = v:get(Movement)
			local velX, velY = collider:getLinearVelocity()
			if body.isGrounded and math.pow(velX, 2)+math.pow(velY, 2) < 2500 and not love.keyboard.isDown("a") and not love.keyboard.isDown("d") then
				local upright = v:get(Upright)
				local goalDir = math.pi
				local torque = (goalDir-collider:getAngle())%(2*math.pi)-math.pi
				collider:applyTorque(upright.torque*(torque))
				local maxAngleVel = 0.5
				if collider:getAngularVelocity() > maxAngleVel then
					collider:setAngularVelocity(maxAngleVel)
				elseif collider:getAngularVelocity() < -maxAngleVel then
					collider:setAngularVelocity(-maxAngleVel)
				end
			end
		end]]
	end
	function PhysicsSystem:entityAdded(entity)
		local body = entity:get(Body)
		local collider = body.Collider
		collider:setObject(entity)
	end
	--[[function PhysicsSystem:applyForce(entity, force)
		local body = entity:get(Body)
		body.Force = body.Force+force
	end]]
	function PhysicsSystem:entityAddedTo(entity, pool)
		if pool == self.drawable then
			local body = entity:get(Body)
			local collider = body.Collider
			collider:setObject(entity)
		end
	end
	function PhysicsSystem:entityRemovedFrom(entity, pool)
		--print("entity "..tostring(entity).." has been removed from pool "..tostring(pool))
		if pool == self.drawable then
		end
	end
	function PhysicsSystem:entityRemoved(entity)
		--print("entity "..tostring(entity).." has been removed from physics")
		local body = entity:get(Body)
		if body.Collider then
			body.Collider:destroy()
		end
		local light = entity:get(Light)
		if light then
			light.Remove()
		end
		if body.Shadow then
			body.Shadow:Remove()
		end
	end
	function PhysicsSystem:draw()
		for k, v in pairs(self.pool.objects) do
			local body = v:get(Body)
			local position = body.Position
			local size = body.Size
			local collider = body.collider
			--for k, v in pairs(collider) do print(k, v) end
			love.graphics.rectangle("line", position.x-size.x/2, position.y-size.y/2, size.x, size.y)
		end
	end
GameInstance:addSystem(physicsSystem, "physicsupdate", "update", true)
GameInstance:addSystem(physicsSystem, "draw", "draw", false)