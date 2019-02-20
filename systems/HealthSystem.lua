local HealthSystem = System({Body, Health, Drawable, "drawable"}, {Body, Health, "generic"}, {Player, Body, Health, "player"}, {Enemy, Body, Health, "enemies"})
	healthsystem = HealthSystem()
	function HealthSystem:update(dt)
		for _, entity in pairs(self.generic.objects) do
			local health = entity:get(Health)
			if health.Value < health.MaxHealth then
				health.Value = health.Value+health.RegenRate*dt
				if health.Value <= 0 then
					GameInstance:removeEntity(entity)
					--local body = entity:get(Body)
					--body.Collider:destroy()
				end
			end
		end
	end
	function HealthSystem:damage(damage, entity1, entity2)
		--local health1 =	entity1:get(Health)
		if entity2:has(Health) then
			local health2 =	entity2:get(Health)
			health2.Value = health2.Value-damage
			sounds.hurt:stop()
			sounds.hurt:play():setPitch(game.speed*math.random2(0.9, 1))
		end
		--print(string.format(entity1.name.." hit "..entity2.name.."; "..entity2:get(Body).uuid.." for %.2f damage", damage))
	end
	function HealthSystem:entityAdded(entity)
	end
	function HealthSystem:entityRemoved(entity)
	end
	function HealthSystem:draw()
		for _, entity in pairs(self.drawable.objects) do
			local health = entity:get(Health)
			local body = entity:get(Body)
			local position = body.Position
			love.graphics.push()

			love.graphics.translate(position:split())
			love.graphics.print(string.format("%.2f", health.Value), 0, 0, 0, 0.2, -0.2)

			love.graphics.pop()
		end
	end
GameInstance:addSystem(healthsystem, "damage", "damage", true)
GameInstance:addSystem(healthsystem, "update", "update", true)
--GameInstance:addSystem(healthsystem, "draw", "draw", true)