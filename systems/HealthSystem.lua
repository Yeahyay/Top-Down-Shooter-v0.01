local HealthSystem = System({Body, Health, Drawable, "drawable"}, {Body, Health, "generic"}, {Player, Body, Health, "player"}, {Enemy, Body, Health, "enemies"})
	healthsystem = HealthSystem()
	function HealthSystem:update(dt)
		for _, entity in pairs(self.generic.objects) do
			local health = entity:get(Health)
			if health.RegenRate > 0 and health.Value < health.MaxHealth then
				health.Value = health.Value+health.RegenRate*dt
				health.LastChanged = timer
				--if health.Value <= 0 then
					--local body = entity:get(Body)
					--body.Collider:destroy()
				--end
			end
		end
	end
	function HealthSystem:damage(damage, entity1, entity2)
		--local health1 =	entity1:get(Health)
		--print(entity1, entity2)
		if entity2:has(Health) then
			local health2 =	entity2:get(Health)
			health2.Value = health2.Value-damage
			health2.LastChanged = timer
			if health2.Value <= 0 then
				--[[local velX, velY = entity1:get(Body).Collider:getLinearVelocity()
				entity1:get(Body).Collider:setLinearVelocity(velX/1.5, velY/1.5)
				entity2:get(Body).Collider:destroy()
				entity2:get(Body).Collider = nil
				entity2:remove(Body):apply()]]
				GameInstance:removeEntity(entity2)
			end
			return health2.Value
			--sounds.hurt:stop()
			--sounds.hurt:play():setPitch(game.speed*math.random2(0.9, 1))
		end
		--print(string.format(entity1.name.." hit "..entity2.name.."; "..entity2:get(Body).uuid.." for %.2f damage", damage))
		return false
	end
	function HealthSystem:entityAdded(entity)
	end
	function HealthSystem:entityRemoved(entity)
	end
	function HealthSystem:drawUI()
		for _, entity in pairs(self.drawable.objects) do
			local health = entity:get(Health)
			local body = entity:get(Body)
			local position = body.Position
			love.graphics.push()

			love.graphics.translate(position:split())
			local lastChanged = math.clamp(1-timer+health.LastChanged, 0, 1)
			love.graphics.setColor(0.45, 1, 0.75, lastChanged)
			local size = 0.2*(1+0.5*lastChanged)
			love.graphics.printf(string.format("%.2f", health.Value), -size*body.Size.x*5, 0, body.Size.x*10, "center", 0, size, -size)
			--love.graphics.printf(text, x, y, limit, align, r, sx, sy, ox, oy, kx, ky)

			love.graphics.pop()
		end
	end
GameInstance:addSystem(healthsystem, "damage", "damage", true)
GameInstance:addSystem(healthsystem, "update", "update", true)
GameInstance:addSystem(healthsystem, "drawUI", "drawUI", true)