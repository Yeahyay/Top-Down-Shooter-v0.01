ProjectileSystem = System({Body, Projectile, Decay, "generic"}, {Body, Projectile, Drawable, "drawable"})
	projectlesystem = ProjectileSystem()
	function ProjectileSystem:update(dt)
		if tick.tick%1 == 0 then
			for _, entity in pairs(self.generic.objects) do
				local body = entity:get(Body)
				local collider = body.Collider
				local projectile = entity:get(Projectile)
				if projectile.dead then
					local body = entity:get(Body)
					local collider = body.Collider
					local decay = entity:get(Decay)
					projectile.dead = false
					collider:setActive(false)
					decay.EndTime = 0
					entity:remove(Drawable):apply()
				elseif body.Velocity.length2 < 1000*1000 then
					projectile.dead = true
				end
				if projectile.destroyed then
					collider:setAngle(body.Angle+math.random2(-0.1, 0.1))
					projectile.destroyed = false
				end
				--print(body.Velocity.length2)
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
			if projectile.CreatedAt < timer then
				--print(dt)

				--love.graphics.setColor(0.8, 0.8, 0.8)
				--love.graphics.translate(position:split())
				--local newPosX, newPosY = position.x+body.Size.x/2, position.y-size.y/2
				local newPosX, newPosY = position:split()
				--love.graphics.rotate(angle)
				--local deltaPos = projectile.deltaPos
				local meter = love.physics.getMeter()*2
				local newSizeX = velocity.length/32
				love.graphics.setColor(0.95, 0.9, 0.6)
				love.graphics.setLineWidth(4)
				love.graphics.line(newPosX, newPosY, newPosX-velocity.x/meter*game.speed, newPosY-velocity.y/meter*game.speed)
				--print(projectile.deltaPos)
				--love.graphics.rectangle("fill", newPosX, newPosY, -newSizeX, size.y)
				--love.graphics.rectangle("fill", body.Size.x/2, -size.y/2, -newSizeX, size.y)
			end
			love.graphics.pop()
		end
	end
	function ProjectileSystem:entityAddedTo(entity, pool)
		if pool == self.generic then
			local body = entity:get(Body)
			local collider = body.Collider
			local shadow = body.Shadow
			local projectile = entity:get(Projectile)
			local parent = entity:get(Parent).Entity
			local vel = Vector2.new(projectile.Velocity)
			vel.angle = projectile.Angle
			--local velX, velY = math.cos(projectile.Angle)*projectile.Velocity, math.sin(projectile.Angle)*projectile.Velocity
			--local positionX, positionY = collider:getPosition()
			--positionX, positionY = positionX+velX/128, positionY+velY/128
			--collider:setPosition(positionX, positionY)
			body.Z = 10
			--collider:setLinearVelocity(velX, velY)
			--body.Velocity.x, body.Velocity.y = velX, velY
			collider:setLinearVelocity(vel.x, vel.y)
			body.Velocity.x, body.Velocity.y = vel.x, vel.y
			collider:setBullet(true)
			--collider:applyLinearImpulse(velX, velY)
			collider:setGravityScale(2)
			collider:setLinearDamping(1)
			collider:setPreSolve(function(entity, hit, contact)
				if hit then
					local hit = hit:getObject()
					local entity = entity:getObject()
					--print(projectile.CreatedAt+2/60, timer)
					if projectile.CreatedAt+2/60 > timer and ((hit.has and hit == parent) or hit == (parent:get(Parent) and parent:get(Parent).Entity)) or hit:has(Projectile) or hit:has(Item) then
						contact:setEnabled(false)
						--print(hit == (parent and parent:get(Parent).Entity))
					elseif projectile.LastHit ~= hit then
						projectile.LastHit = hit
						local damage = GameInstance:emit("damage", projectile.ProcessDamage(entity:get(Body).Velocity.length), entity, hit)
						if damage then
							if damage <= 0 then
								contact:setEnabled(false)
								projectile.destroyed = true
								--collider:setAngle(entity:get(Body).Angle)
							end
						end
						projectile.Bounces = projectile.Bounces-1
						if projectile.Bounces <= -1 then
							contact:setEnabled(false)
							projectile.dead = true
						end
					end
				end
			end)
			collider:setPostSolve(function(entity, hit, contact)
				if hit then
					local hit = hit:getObject()
					local entity = entity:getObject()
					if hit.get then
						if hit == parent or hit:has(Projectile) then
							contact:setEnabled(false)
						else
							local light = entity:get(Light)
							if light then
								light.Trigger(50)
							end
							--print(projectile.Damage)
						end
					end
					--projectile.hit = true
					projectile.Bounces = projectile.Bounces-1
					if projectile.Bounces < 1 then
						contact:setEnabled(false)
						projectile.dead = true
					end
				end
			end)
			entity:give(Drawable)
			entity:apply()
		end
	end

--GameInstance:addSystem(projectlesystem, "fireRanged", "fireRanged", true)
GameInstance:addSystem(projectlesystem, "update", "update", true)
GameInstance:addSystem(projectlesystem, "draw", "draw", true)