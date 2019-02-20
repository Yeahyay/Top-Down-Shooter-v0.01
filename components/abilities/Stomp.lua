--[[Stomp = AbilityConstructor.new("Stomp", 0.1, 5, 0,
	function(self, entity)
		local movement = entity:get(Movement)
		local collider = entity:get(Body).Collider
		local velX, velY = collider:getLinearVelocity()
		local restitution = collider:getRestitution()
		collider:setRestitution(0)
		movement.isDamping = false
		local tZoom, zoomD, positionD = camera.currentCamera.ZoomTarget, camera.currentCamera.ZoomDamp, camera.currentCamera.PositionDamp
		self.toPost = {collider, restitution, velX, velY, tZoom, zoomD, positionD}
		GameInstance:emit("cameraSetZoomTarget", 0.75)
		GameInstance:emit("cameraSetZoomDamp", 0.5)
		GameInstance:emit("cameraSetPositionDamp", 0.5)
	end,
	function(self, entity)
		local collider = entity:get(Body).Collider
		collider:applyLinearImpulse(0, -50000)
		--print("stomp for "..self.timeActive.." seconds")
	end,
	function(self, entity)
		GameInstance:emit("cameraSetZoomTarget", self.toPost[5])
		GameInstance:emit("cameraSetZoomDamp", self.toPost[6])
		GameInstance:emit("cameraSetPositionDamp", self.toPost[7])
		local movement = entity:get(Movement)
		local body = entity:get(Body)
		movement.isDamping = true
		game:tweenSpeedFrom(0.1, 0.25)
		game:tweenEffectAmountFrom(0, 0.25)
		self.toPost[1]:setRestitution(self.toPost[2])
		self.toPost[1]:setLinearVelocity(self.toPost[3], self.toPost[4])
		--print(self.toPost[3])
		if self.toPost[1]:enter("World") then
			for i=1, 50 do
				local entity = Entity("Mouse Test Entity")
					:give(Body, {"Rectangle"}, body.Position+Vector2.new(math.random2(-20, 20), -30), 0, Vector2.new(6, 6), 1, Vector2.new(self.toPost[3]*0.1+math.random2(-50, 50), math.random2(5, 20)))
					:give(Animator, testImage, Vector2.new(0.25, 0.25), Vector2.new(32, 32), {1, 1}, 0)
					:give(Decay, 5)
					:apply()
				entity:get(Body).Collider:setRestitution(0)
				entity:get(Body).Collider:setCollisionClass("Particle")
				GameInstance:addEntity(entity)
			end
		end
	end)
	]]

--print(Stomp.new())

--[[Dash = AbilityConstructor.new("Dash", 0.2, 0.5, 20,
	function(self, entity, direction)
		local body = entity:get(Body)
		local collider = body.Collider
		local velX, velY = collider:getLinearVelocity()
		local mass = collider:getMass()
		local movement = entity:get(Movement)
		movement.isDamping = false
		local positionD = camera.currentCamera.PositionDamp
		self.toActive = body
		self.toPost = {collider, velX, velY, mass, restitution, positionD}
		--print("pre", unpack(self.toPost))
		GameInstance:emit("cameraSetPositionDamp", 0.4)
	end,
	function(self, entity, direction)
		local body = self.toActive
		local collider = body.Collider
		for i=1, 2 do
			local entity = Entity("Mouse Test Entity")
				:give(Body, {"Rectangle"}, body.Position, 0, Vector2.new(6, 6), 0.2, Vector2.new(math.random2(-2, 2), math.random2(-5, 5)))
				:give(Animator, testImage, Vector2.new(0.25, 0.25), Vector2.new(32, 32), {1, 1}, 0)
				:give(Decay, 1)
				:apply()
			GameInstance:addEntity(entity)
			entity:get(Body).Collider:setCollisionClass("Particle")
		end
		collider:setMass(100)
		--print(collider:getLinearVelocity())
		--print(direction)
		if direction == 1 then
			collider:setLinearVelocity(1500, 0)
		--	print("tyrt9er")
		else
		--	print("asposfjjop")
			collider:setLinearVelocity(-1500, 0)
		end
		if collider:enter("Enemy") then
			print(string.format("hit for %.2f damage", self.damage))
		end
		--print("dash for "..self.timeActive.." seconds")
	end,
	function(self, entity, direction)
		GameInstance:emit("cameraSetPositionDamp", self.toPost[6])
		local movement = entity:get(Movement)
		--for k, v in pairs(movement) do print(k, v) end
		movement.isDamping = true
		movement.jumpsAvailable = movement.jumpsAvailable+1
		--print(unpack(self.toPost))
		game:tweenSpeedFrom(0.2, 0.1)
		game:tweenEffectAmountFrom(0, 0.1)
		local x
		if direction == 1 then
			x = math.abs(self.toPost[2])
		else
			x = -math.abs(self.toPost[2])
		end
		self.toPost[1]:setLinearVelocity(x*0.6, self.toPost[3])
		self.toPost[1]:setMass(self.toPost[4])
	end)
	]]
Stomp = AbilityConstructor:extend("Stomp")
	function Stomp:init()
		Stomp.super.init(self, "Stomp", 0.1, 5, 70)
	end
	function Stomp:prefunc(entity)
		-- to post function
		local collider = entity:get(Body).Collider
		local velX, velY = collider:getLinearVelocity()
		local restitution = collider:getRestitution()
		local tZoom, zoomD, positionD = camera.currentCamera.ZoomTarget, camera.currentCamera.ZoomDamp, camera.currentCamera.PositionDamp
		self.toPost = {restitution, velX, velY, tZoom, zoomD, positionD}

		-- to active function
		self.toActive = {velX, velY}
		self.toActive.hit = {}
		
		local movement = entity:get(Movement)
		movement.isDamping = false
		collider:setRestitution(0)
		collider:setPostSolve(function(_, entityHit)
			local entityHit = entityHit:getObject()
			if entityHit.get then
				if entityHit:get(Health) then
					local uuid = entityHit:get(Body).uuid
					if not self.toActive.hit[uuid] then
						self.toActive.hit[uuid] = true
						GameInstance:emit("damage", self.damage, entity, entityHit)
						if self.player then
							GameInstance:emit("cameraSetZoomTarget", 0.75)
							GameInstance:emit("cameraSetZoomDamp", 0.5)
							GameInstance:emit("cameraSetPositionDamp", 0.5)
						end
					end
				end
			end
		end)
	end
	function Stomp:activefunc(entity)
		local collider = entity:get(Body).Collider

		collider:setLinearVelocity(self.toActive[1], -5000)
		--[[if collider:enter("Enemy") then
			local entityHit = collider:getEnterCollisionData("Enemy").collider:getObject()
			local uuid = entityHit:get(Body).uuid
			if not self.toActive.hit[uuid] then
				self.toActive.hit[uuid] = true
				GameInstance:emit("damage", self.damage, entity, entityHit)
			end
		end]]
	end
	function Stomp:postfunc(entity)
		game:tweenSpeedFrom(0.1, 0.25)
		game:tweenEffectAmountFrom(0, 0.25)
		sounds.menuback:stop()
		sounds.menuback:play():setPitch(math.random2(0.9, 1))

		local body = entity:get(Body)
		local collider = body.Collider
		local movement = entity:get(Movement)
		movement.isDamping = true
		collider:setRestitution(self.toPost[1])
		collider:setLinearVelocity(self.toPost[2], self.toPost[3]/2)
		if collider:enter("World") then
			for i=1, 20 do
				local entity = Entity("Mouse Test Entity")
					:give(Body, {"Rectangle"}, body.Position+Vector2.new(math.random2(-20, 20), -30), 0, Vector2.new(6, 6), 1,
						Vector2.new(self.toPost[2]*0.1+math.random2(-50, 50), math.random2(5, 20)))
					:give(Animator, testImage, Vector2.new(0.25, 0.25), Vector2.new(32, 32), {1, 1}, 0)
					:give(Decay, 2)
					:give(Drawable)
					:apply()
				entity:get(Body).Collider:setRestitution(0)
				entity:get(Body).Collider:setCollisionClass("Particle")
				GameInstance:addEntity(entity)
			end
		end
		collider:setPostSolve(function() end)
		if self.player then
			GameInstance:emit("cameraSetZoomTarget", self.toPost[4])
			GameInstance:emit("cameraSetZoomDamp", self.toPost[5])
			GameInstance:emit("cameraSetPositionDamp", self.toPost[6])
		end
		sounds.boom:stop()
		sounds.boom:play():setPitch(math.random2(0.9, 1)*game.speed)
	end

Dash = AbilityConstructor:extend("Dash")
	function Dash:init(...)
		Dash.super.init(self, "Dash", 0.15, 0.5, 20)
	end
	function Dash:prefunc(entity, direction)
		-- to post function
		local body = entity:get(Body)
		local collider = body.Collider
		local velX, velY = collider:getLinearVelocity()
		local mass = collider:getMass()
		local positionD = camera.currentCamera.PositionDamp
		self.toPost = {collider, velX, velY, mass, restitution, positionD}
		sounds.menuselect:stop()
		sounds.menuselect:play():setPitch(math.random2(0.9, 1)*game.speed)

		-- to active function
		self.toActive = body
		self.toActive.hit = {}

		local movement = entity:get(Movement)
		movement.isDamping = false
		if self.player then
			GameInstance:emit("cameraSetPositionDamp", 0.4)
		end
		collider:setPostSolve(function(_, entityHit)
			local entityHit = entityHit:getObject()
			if entityHit.get then
				if entityHit:get(Health) then
					local uuid = entityHit:get(Body).uuid
					if not self.toActive.hit[uuid] then
						self.toActive.hit[uuid] = true
						GameInstance:emit("damage", self.damage, entity, entityHit)
					end
				end
			end
		end)
	end
	function Dash:activefunc(entity, direction)
		local body = self.toActive
		local collider = body.Collider
		local hit = {}

		collider:setMass(10)
		if direction == 1 then
			collider:setLinearVelocity(2250, 0)
			--collider:applyForce(225000, 0)
		else
			collider:setLinearVelocity(-2250, 0)
			--collider:applyForce(-225000, 0)
		end
		--[[if collider:enter("Enemy") then
			local entityHit = collider:getEnterCollisionData("Enemy").collider:getObject()
			local uuid = entityHit:get(Body).uuid
			if not self.toActive.hit[uuid] then
				self.toActive.hit[uuid] = true
				GameInstance:emit("damage", self.damage, entity, entityHit)
			end
		end]]
		for i=1, 2 do
			local entity = Entity("Mouse Test Entity")
				:give(Body, {"Rectangle"}, body.Position, 0, Vector2.new(6, 6), 0.2, Vector2.new(math.random2(-2, 2), math.random2(-5, 5)))
				:give(Animator, testImage, Vector2.new(0.25, 0.25), Vector2.new(32, 32), {1, 1}, 0)
				:give(Decay, math.random2(0.22, 0.28))
				:give(Drawable)
				:apply()
			GameInstance:addEntity(entity)
			entity:get(Body).Collider:setCollisionClass("Particle")
		end
	end
	function Dash:postfunc(entity, direction)
		game:tweenSpeedFrom(0.3, 0.1)
		game:tweenEffectAmountFrom(0, 0.1)

		local movement = entity:get(Movement)
		movement.isDamping = true
		movement.jumpsAvailable = movement.jumpsAvailable+1
		local x
		if direction == 1 then
			x = math.abs(self.toPost[2])
		else
			x = -math.abs(self.toPost[2])
		end
		self.toPost[1]:setLinearVelocity(x*0.6, self.toPost[3])
		self.toPost[1]:setMass(self.toPost[4])
		entity:get(Body).Collider:setPostSolve(function() end)
		if self.player then
			GameInstance:emit("cameraSetPositionDamp", self.toPost[6])
		end
	end