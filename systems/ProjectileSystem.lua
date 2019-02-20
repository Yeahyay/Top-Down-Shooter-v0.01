ProjectileSystem = System({Body, Projectile, "generic"}, {Body, Projectile, Drawable, "drawable"})
	projectlesystem = ProjectileSystem()
	function ProjectileSystem:update(dt)
		if tick.tick%2 == 0 then
			for _, entity in pairs(self.generic.objects) do
				local body = entity:get(Body)
				local collider = body.Collider
				local projectile = entity:get(Projectile)
				if projectile.hit then
					local body = entity:get(Body)
					local collider = body.Collider
					local decay = entity:get(Decay)
					projectile.hit = false
					collider:setActive(false)
					decay.EndTime = 0
					entity:remove(Drawable):apply()
				end	
				--local velX, velY = math.cos(projectile.Angle)*projectile.Velocity, math.sin(projectile.Angle)*projectile.Velocity
				--collider:applyLinearImpulse(velX, velY)
				collider:setAngle(body.Velocity.angle)
				--print(entity:get(Body).Velocity)
			end
		end
	end
	function ProjectileSystem:draw(dt)
		for _, entity in pairs(self.drawable.objects) do
			local body = entity:get(Body)
			local collider = body.Collider
			local projectile = entity:get(Projectile)
			local size = body.Size
			local angle = body.Angle
			local position = body.Position
			local velocity = body.Velocity

			love.graphics.push()
			--print(dt)

			--love.graphics.setColor(0.8, 0.8, 0.8)
			--love.graphics.translate(position:split())
			--local newPosX, newPosY = position.x+body.Size.x/2, position.y-size.y/2
			local newPosX, newPosY = position:split()
			--love.graphics.rotate(angle)
			local newSizeX = velocity.length/64
			love.graphics.setColor(0.95, 0.9, 0.6)
			love.graphics.setLineWidth(4)
			love.graphics.line(newPosX, newPosY, newPosX+velocity.x/64*game.speed, newPosY+velocity.y/64*game.speed)
			--love.graphics.rectangle("fill", newPosX, newPosY, -newSizeX, size.y)
			--love.graphics.rectangle("fill", body.Size.x/2, -size.y/2, -newSizeX, size.y)

			love.graphics.pop()
		end
	end
	function ProjectileSystem:entityAddedTo(entity, pool)
		if pool == self.generic then
			local body = entity:get(Body)
			local collider = body.Collider
			local projectile = entity:get(Projectile)
			local parent = entity:get(Parent).Entity
			local velX, velY = math.cos(projectile.Angle)*projectile.Velocity, math.sin(projectile.Angle)*projectile.Velocity
			local positionX, positionY = collider:getPosition()
			positionX, positionY = positionX+velX/64, positionY+velY/64
			collider:setBullet(true)
			collider:applyLinearImpulse(velX, velY)
			collider:setGravityScale(2)
			--print(collider:getLinearVelocity())
			body.Velocity.x, body.Velocity.y = velX, velY
			collider:setPosition(positionX, positionY)
			collider:setPreSolve(function(_, hit, contact)
				if hit then
					local hit = hit:getObject()
					if hit.has then
						if hit == parent or hit:has(Projectile) then
							contact:setEnabled(false)
						end
					end
				end
			end)
			collider:setPostSolve(function(_, hit, contact)
				if hit then
					local hit = hit:getObject()
					if hit.get then
						if hit == parent or hit:has(Projectile) then
							contact:setEnabled(false)
						else
							GameInstance:emit("damage", projectile.Damage, entity, hit)
						end
					end
					contact:setEnabled(false)
					projectile.hit = true
				end
			end)
			entity:give(Drawable)
			entity:apply()
		end
	end

--GameInstance:addSystem(projectlesystem, "fireRanged", "fireRanged", true)
GameInstance:addSystem(projectlesystem, "update", "update", true)
GameInstance:addSystem(projectlesystem, "draw", "draw", true)