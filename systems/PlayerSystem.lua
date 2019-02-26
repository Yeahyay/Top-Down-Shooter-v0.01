PlayerSystem = System({Player, "playersAlive"}, {Player, Body, "withBody"}, {Body, Drawable, Animator, "drawable"})
	playerSystem = PlayerSystem()
	playerSystem.Players = {}
	function PlayerSystem:leftStart(entity)
		if entity:has(Animator) then
			local animator = entity:get(Animator)
			if animator.debounce ~= 1 then
				local body = entity:get(Body)
				animator.debounce = 1
				animator.animation:flipH()
			end
		end
	end
	function PlayerSystem:rightStart(entity)
		if entity:has(Animator) then
			local animator = entity:get(Animator)
			if animator.debounce ~= 2 then
				local body = entity:get(Body)
				animator.debounce = 2
				animator.animation:flipH()
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
	function PlayerSystem:drawUI()
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
			local player = Entity("Player"..#self.playersAlive.objects+1)
				:give(Body, {"BSGRectangle", 20}, Vector2.new(math.random2(-1000, 1000), math.random2(-1000, 1000)), 0, Vector2.new(64, 64), 5)
				:give(Animator, playerImage, Vector2.new(2, 2), Vector2.new(32, 32), {"1-3", "1-3", 1, 4}, 1/60)
				:give(Movement)
				:give(Health, 200, 200, 5, 1)
				:give(Ability, true, {Dash})
				:give(Upright, 250000)
				:give(Inventory, 100, 100, 26)
				:give(Drawable)
				:give(Light, {0.8, 0.8, 0.8}, 10)
				:apply()
				player:get(Body).Collider:setFixedRotation(true)
				player:get(Body).Collider:setCollisionClass("Player")
				player:get(Body).Collider:setFriction(0.7)
				player:get(Body).Collider:setRestitution(0.3)
				--player:get(Body).Collider:setAngularDamping(0.5)
				player:give(Player, #self.playersAlive.objects+1, player):apply()
				GameInstance:addEntity(player)
				self.Players[#self.playersAlive.objects] = player
		end
	end
GameInstance:addSystem(playerSystem, "update", "update", true)
GameInstance:addSystem(playerSystem, "respawn", "respawn", true)
--GameInstance:addSystem(playerSystem, "keypressed", "keypressed", true)
--GameInstance:addSystem(playerSystem, "keyreleased", "keyreleased", true)
GameInstance:addSystem(playerSystem, "leftStart", "leftStart", true)
GameInstance:addSystem(playerSystem, "rightStart", "rightStart", true)
GameInstance:addSystem(playerSystem, "drawUI", "drawUI", true)