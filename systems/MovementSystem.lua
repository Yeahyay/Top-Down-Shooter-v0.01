local MovementSystem = System({Body, Movement, "withMovement"})
	movementsystem = MovementSystem()
	function MovementSystem:left(entity)
		local movement = entity:get(Movement)
		local body = entity:get(Body)
		local collider = body.Collider
		local velX, velY = collider:getLinearVelocity()
		if body.isGrounded then
			if velX > -movement.maxVelocity.x then
				collider:applyLinearImpulse(-movement.speed.x, 0)
			elseif movement.isDamping then
				collider:setLinearVelocity(-movement.maxVelocity.x, velY)
			end
		end
	end
	function MovementSystem:right(entity)
		local movement = entity:get(Movement)
		local body = entity:get(Body)
		local collider = body.Collider
		local velX, velY = collider:getLinearVelocity()
		if body.isGrounded then
			if velX < movement.maxVelocity.x then
				collider:applyLinearImpulse(movement.speed.x, 0)
			elseif movement.isDamping then
				collider:setLinearVelocity(movement.maxVelocity.x, velY)
			end
		end
	end
	function MovementSystem:jump(entity)
		local movement = entity:get(Movement)
		local body = entity:get(Body)
		local collider = body.Collider
		local velX, velY = collider:getLinearVelocity()
		if body.isGrounded then
			movement.isJumping = true
			body.isGrounded = false
			movement.jumpDebounce = true
			movement.jumpTimeCurrent = movement.jumpTimeDefault
			movement.jumpsAvailable = movement.maxJumpsDefault-1
			movement.jumps = 1
			collider:setLinearVelocity(velX, movement.jumpInitSpeed)
		elseif movement.isJumping then
			if movement.jumpTimeCurrent > 0 then
				collider:applyLinearImpulse(0, movement.jumpConstantSpeed)
				movement.jumpTimeCurrent = movement.jumpTimeCurrent-1
			else
				movement.movementTimeCurrent = 0
			end
			if not movement.jumpDebounce and movement.jumpsAvailable > 0 and movement.jumps < movement.maxJumps then
				movement.isJumping = true
				body.isGrounded = false
				movement.jumpDebounce = true
				movement.jumpTimeCurrent = movement.jumpTimeDefault
				movement.jumpsAvailable = movement.jumpsAvailable-1
				movement.jumps = movement.jumps+1
				collider:setLinearVelocity(velX, movement.jumpInitSpeed)
			end
		end
	end
	function MovementSystem:jumpStop(entity)
		local movement = entity:get(Movement)
		local body = entity:get(Body)
		local collider = body.Collider
		local velX, velY = collider:getLinearVelocity()
		movement.jumpDebounce = false
		movement.jumpTimeCurrent = 0
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
	function MovementSystem:up(entity)
	end
	function MovementSystem:stomp(entity)
		entity:get(Ability).Stomp:activate()
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
	GameInstance:addSystem(movementsystem, "left", "left", true)
	GameInstance:addSystem(movementsystem, "leftStop", "leftStop", true)
	GameInstance:addSystem(movementsystem, "right", "right", true)
	GameInstance:addSystem(movementsystem, "rightStop", "rightStop", true)
	GameInstance:addSystem(movementsystem, "dashRight", "dashRight", true)
	GameInstance:addSystem(movementsystem, "dashLeft", "dashLeft", true)
	GameInstance:addSystem(movementsystem, "up", "up", true)
	GameInstance:addSystem(movementsystem, "stomp", "stomp", true)
	GameInstance:addSystem(movementsystem, "jump", "jump", true)
	GameInstance:addSystem(movementsystem, "jumpStop", "jumpStop", true)

-- utility
	GameInstance:addSystem(movementsystem, "update", "update", true)
	--GameInstance:addSystem(movementsystem, "draw", "draw", true)