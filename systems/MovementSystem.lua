local MovementSystem = System({Body, Movement, "withMovement"})
	movementsystem = MovementSystem()
	function MovementSystem:up(entity)
		local movement = entity:get(Movement)
		local body = entity:get(Body)
		local collider = body.Collider
		local velX, velY = collider:getLinearVelocity()
			collider:applyForce(0, movement.speed.y)
			if velY > movement.maxVelocity.y and movement.isDamping then
				collider:setLinearVelocity(velX, movement.maxVelocity.y)
			--elseif then
			end
	end
	function MovementSystem:down(entity)
		local movement = entity:get(Movement)
		local body = entity:get(Body)
		local collider = body.Collider
		local velX, velY = collider:getLinearVelocity()
			if velY > -movement.maxVelocity.y then
				collider:applyForce(0, -movement.speed.y)
			elseif movement.isDamping then
				collider:setLinearVelocity(velX, -movement.maxVelocity.y)
			end
	end
	function MovementSystem:left(entity)
		local movement = entity:get(Movement)
		local body = entity:get(Body)
		local collider = body.Collider
		local velX, velY = collider:getLinearVelocity()
			if velX > -movement.maxVelocity.x then
				collider:applyForce(-movement.speed.x, 0)
			elseif movement.isDamping then
				collider:setLinearVelocity(-movement.maxVelocity.x, velY)
			end
	end
	function MovementSystem:right(entity)
		local movement = entity:get(Movement)
		local body = entity:get(Body)
		local collider = body.Collider
		local velX, velY = collider:getLinearVelocity()
			if velX < movement.maxVelocity.x then
				collider:applyForce(movement.speed.x, 0)
			elseif movement.isDamping then
				collider:setLinearVelocity(movement.maxVelocity.x, velY)
			end
	end
	function MovementSystem:dashRight(entity)
		entity:get(Ability).Dash:activate(1)
	end
	function MovementSystem:dashLeft(entity)
		entity:get(Ability).Dash:activate(-1)
	end
	function MovementSystem:rightStop(entity)
	end
	function MovementSystem:leftStop(entity)
	end
	function MovementSystem:update(dt)
		for k, v in pairs(self.withMovement.objects) do
			local movement = v:get(Movement)
			local body = v:get(Body)
			local collider = body.Collider
			--[[collider:setPreSolve(function()--collider1, collider2, contact)
				body.isGrounded = true
			end)]]
			if collider:exit("World") then
				body.isGrounded = false
			end
		end
	end
	function MovementSystem:movement()
	end
	function MovementSystem:draw()
		for k, v in pairs(self.withMovement.objects) do
			local movement = v:get(Movement)
		end
	end
	function MovementSystem:entityAdded(entity)
		local movement = entity:get(Movement)
		local body = entity:get(Body)
		local collider = body.Collider
		collider:setPreSolve(function(_, hit)--collider1, collider2, contact)
			if hit:getObject().has then
				if not hit:getObject():has(Projectile) then
					body.isGrounded = true
				end
			else
				body.isGrounded = true
			end
		end)
	end
-- controls
	GameInstance:addSystem(movementsystem, "movement", "movement", true)
	--GameInstance:addSystem(movementsystem, "leftStart", "leftStart", true)
	GameInstance:addSystem(movementsystem, "left", "left", true)
	--GameInstance:addSystem(movementsystem, "leftStop", "leftStop", true)
	--GameInstance:addSystem(movementsystem, "rightStart", "rightStart", true)
	GameInstance:addSystem(movementsystem, "right", "right", true)
	--GameInstance:addSystem(movementsystem, "rightStop", "rightStop", true)
	GameInstance:addSystem(movementsystem, "dashRight", "dashRight", true)
	GameInstance:addSystem(movementsystem, "dashLeft", "dashLeft", true)
	GameInstance:addSystem(movementsystem, "up", "up", true)
	GameInstance:addSystem(movementsystem, "down", "down", true)
	GameInstance:addSystem(movementsystem, "jump", "jump", true)
	GameInstance:addSystem(movementsystem, "jumpStop", "jumpStop", true)

-- utility
	GameInstance:addSystem(movementsystem, "update", "update", true)
	--GameInstance:addSystem(movementsystem, "draw", "draw", true)