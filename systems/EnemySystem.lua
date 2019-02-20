EnemySystem = System({Player, Movement, Body, "player"}, {Enemy, Movement, Body, "generic"})
	enemysystem = EnemySystem()
	function EnemySystem:update(dt)
		for _, entity in pairs(self.generic.objects) do
			local body = entity:get(Body)
			local enemy = entity:get(Enemy)
			--print(string.format("%.3f %.3f", timer, enemy.AbilityTimer))
			if timer > enemy.AbilityTimer then
				enemy.canUseAbility = true
			else
			end
			if enemy.Target then
				local bodyTarget = enemy.Target:get(Body)
				local movement = entity:get(Movement)
				local ability = entity:get(Ability)
				-- shitty fsm implementation; use a behavior tree
					-- ai also kills itself
				if math.abs(bodyTarget.Position.x-body.Position.x) > 80 then
					if body.Position.x > bodyTarget.Position.x then
						GameInstance:emit("left", entity)
						if body.Position.y > bodyTarget.Position.y-60 then
							self:emit("dashLeft", entity)
						end
					elseif body.Position.x < bodyTarget.Position.x then
						GameInstance:emit("right", entity)
						if body.Position.y > bodyTarget.Position.y-60 then
							self:emit("dashRight", entity)
						end
					end
				elseif math.abs(bodyTarget.Position.x-body.Position.x) < 50 then
					if body.Position.y-20 > bodyTarget.Position.y then
						self:emit("stomp", entity)
					else
						if body.Position.x < bodyTarget.Position.x then
							GameInstance:emit("left", entity)
						elseif body.Position.x > bodyTarget.Position.x then
							GameInstance:emit("right", entity)
						end
					end
					if body.Position.y-20 < bodyTarget.Position.y then
						GameInstance:emit("jump", entity)
					end
				end
			end
		end
	end
	function EnemySystem:emit(ability, entity, ...)
		local enemy = entity:get(Enemy)
		if enemy.canUseAbility then
			GameInstance:emit(ability, entity, ...)
			enemy.canUseAbility = false
			enemy.AbilityTimer = enemy.AbilityTimer+enemy.AbilityDelay
		end
	end
	function EnemySystem:entityAddedTo(entity, pool)
		if pool == self.player then
			for _, enemyEntity in pairs(self.generic.objects) do
				local enemy = enemyEntity:get(Enemy)
				enemy.Target = entity
			end
		end
	end
-- utility
	GameInstance:addSystem(enemysystem, "update", "update", true)
	--GameInstance:addSystem(enemysystem, "draw", "draw", true)