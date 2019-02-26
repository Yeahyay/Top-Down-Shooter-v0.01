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
			body.Collider:setPreSolve(function(entity, hit, contact)
				local hit = hit.get or hit:getObject()
				--print(hit)
				if hit and hit:has(Player) then
					GameInstance:emit("damage", 10, entity:getObject(), hit)
				end
			end)
			if enemy.Target and enemy.Target.get then
				local bodyTarget = enemy.Target:get(Body)
				local movement = entity:get(Movement)
				local ability = entity:get(Ability)
				-- shitty fsm implementation; use a behavior tree
					-- ai also kills itself
				--if math.abs(bodyTarget.Position.x-body.Position.x) > 150 then
					if body.Position.x > bodyTarget.Position.x then
						GameInstance:emit("left", entity)
					elseif body.Position.x < bodyTarget.Position.x then
						GameInstance:emit("right", entity)
					end
				--end
				--if math.abs(bodyTarget.Position.y-body.Position.y) > 150 then
					if body.Position.y > bodyTarget.Position.y then
						GameInstance:emit("down", entity)
					elseif body.Position.y < bodyTarget.Position.y then
						GameInstance:emit("up", entity)
					end
				--end
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
	--[[function EnemySystem:entityRemovedFrom(entity, pool)
		if pool == self.player then
			--self
		end
	end]]
	function EnemySystem:entityAddedTo(entity, pool)
		if pool == self.player then
			for _, enemyEntity in pairs(self.generic.objects) do
				local enemy = enemyEntity:get(Enemy)
				enemy.Target = entity
			end
		elseif pool == self.generic then
			local body = entity:get(Body)
			local enemy = entity:get(Enemy)
			for _, target in pairs(self.player.objects) do
				--local enemy = enemyEntity:get(Enemy)
				enemy.Target = target
			end
			body.Collider:setPreSolve(function(entity, hit, contact)
				local hit = hit.get or hit:getObject()
				print(hit)
				if hit:has(Player) then
					GameInstance:emit("damage", 10, entity, hit)
				end
			end)
		end
	end
-- utility
	GameInstance:addSystem(enemysystem, "update", "update", true)
	--GameInstance:addSystem(enemysystem, "draw", "draw", true)