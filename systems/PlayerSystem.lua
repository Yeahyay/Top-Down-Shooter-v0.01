PlayerSystem = System({Player, "playersAlive"}, {Player, Body, "withBody"}, {Body, Drawable, Animator, "drawable"})
	playerSystem = PlayerSystem()
	function PlayerSystem:left(entity)
		if entity:has(Animator) then
			local animator = entity:get(Animator)
			if animator.debounce ~= 1 then
				local body = v:get(Body)
				if body.isGrounded then
					animator.debounce = 1
					animator.animation:flipH()
				end
			end
		end
	end
	function PlayerSystem:right(entity)
		if entity:has(Animator) then
			local animator = entity:get(Animator)
			if animator.debounce ~= 2 then
				local body = v:get(Body)
				if body.isGrounded then
					animator.debounce = 2
					animator.animation:flipH()
				end
			end
		end
	end
	function PlayerSystem:update(dt)
		for k, v in pairs(self.drawable.objects) do
			local body = v:get(Body)
			local animator = v:get(Animator)
			animator.timeScale = math.clamp(math.abs(body.Velocity.x/500), 0, 1)
			if body.isGrounded then
				if love.keyboard.isDown("a") and animator.debounce ~= 1 then
					animator.debounce = 1
					animator.animation:flipH()
				end
				if love.keyboard.isDown("d") and animator.debounce ~= 2 then
					animator.debounce = 2
					animator.animation:flipH()
				end
			end
		end
	end
	function PlayerSystem:draw()
		for k, v in pairs(self.withBody.objects) do
			local ability = v:get(Ability)
			local body = v:get(Body)
			local position = body.Position
			love.graphics.push()

			love.graphics.setColor(1, 1, 1)
			love.graphics.translate(position:split())
			for k, v in pairs(ability.abilities) do
				love.graphics.print(v.name .." "..v:getTimeLeft(), -50, 50+k*20, 0, 0.2, -0.2)
			end
			love.graphics.pop()
		end
	end
	function PlayerSystem:entityAdded(entity)
		if entity:has(Player) then
			GameInstance:emit("playerSpawned", entity)
		end
		--local player = entity:get(Player)
	end
	function PlayerSystem:entityRemoved(entity)
		GameInstance:emit("playerDied", entity)
	end
	function PlayerSystem:respawn(player)
		if #self.playersAlive.objects < 1 then
			local player = Entity("Player"..#self.playersAlive.objects)
				:give(Body, {"BSGRectangle", 20}, Vector2.new(0, 500), 0, Vector2.new(64, 64), 10)
				:give(Animator, playerImage, Vector2.new(2, 2), Vector2.new(32, 32), {"1-3", "1-3", 1, 4}, 1/60)
				:give(Player, player)
				:give(Movement)
				:give(Health, 200, 200, 5, 1)
				:give(Ability, true, {Stomp, Dash})
				:give(Upright, 250000)
				:give(Inventory, 100, 100, 26)
				:give(Drawable)
				:apply()
				--player:get(Body).Collider:setFixedRotation(true)
				player:get(Body).Collider:setCollisionClass("Player")
				--player:get(Body).Collider:setGravityScale(0)
				player:get(Body).Collider:setMass(5)
				player:get(Body).Collider:setFriction(0.7)
				player:get(Body).Collider:setRestitution(0.3)
				player:get(Body).Collider:setAngularDamping(0.5)
				GameInstance:addEntity(player)
		end
	end
GameInstance:addSystem(playerSystem, "update", "update", true)
GameInstance:addSystem(playerSystem, "respawn", "respawn", true)
--GameInstance:addSystem(playerSystem, "keypressed", "keypressed", true)
--GameInstance:addSystem(playerSystem, "keyreleased", "keyreleased", true)
GameInstance:addSystem(movementsystem, "left", "left", true)
GameInstance:addSystem(movementsystem, "right", "right", true)
GameInstance:addSystem(playerSystem, "draw", "draw", true)