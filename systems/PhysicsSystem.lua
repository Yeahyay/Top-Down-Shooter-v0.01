local PhysicsSystem = System({Body, "withBody"}, {Body, Movement, Upright, "withUpright"})
	physicsSystem = PhysicsSystem()
	function PhysicsSystem:update(dt)
		for k, v in pairs(self.withBody.objects) do
			local body = v:get(Body)
			local collider = body.Collider
			local velX, velY = collider:getLinearVelocity()
			if body.isGrounded then
				collider:setLinearVelocity(velX*0.9, velY)
			end
			if body.Position.x > 3000 or body.Position.x < -3000 or body.Position.y < -400 then
				GameInstance:removeEntity(v)
			end
			local posX, posY = collider:getPosition()
			body.Position, body.Velocity, body.Angle =
			Vector2.new(posX, posY), Vector2.new(collider:getLinearVelocity()), collider:getAngle()
		end
		for k, v in pairs(self.withUpright.objects) do
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
		end
	end
	function PhysicsSystem:entityAdded(entity)
		local body = entity:get(Body)
		local collider = body.Collider
		collider:setObject(entity)
	end
	function PhysicsSystem:applyForce(entity, force)
		local body = entity:get(Body)
		body.Force = body.Force+force
	end
	function PhysicsSystem:entityRemoved(entity)
		--print("entity "..tostring(entity).." has been removed from physics")
		local body = entity:get(Body)
		if body.Collider then
			body.Collider:destroy()
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