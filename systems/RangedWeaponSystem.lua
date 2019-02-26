RangedWeaponSystem = System({Item, Activatable, Ranged, Ammo, "ammo"}, {Item, Activatable, Ranged, "generic"}, {Item, Activatable, Ranged, Drawable, "drawable"},
	{Item, Activatable, Ranged, Parent, Ammo, "drawableWithParentandAmmo"})
	rangedweaponsystem = RangedWeaponSystem()
	RangedWeaponSystem.ProjectileTypes = {}
	function RangedWeaponSystem:update(dt)
		for _, entity in pairs(self.generic.objects) do
			local item = entity:get(Item)
			local ranged = entity:get(Ranged)
			--print(ranged.canFire)
			if ranged.FireMode == "semi" then
			elseif ranged.fireTime > 0 then
				ranged.fireTime = ranged.fireTime-dt
			elseif ranged.fireTime <=0 then
				-- forces player to stop firing before being able to fire again
				--[[if ranged.FireMode == "delayed" then
					if not ranged.triggerDown then
						ranged.canFire = true
					end
				else]]
					ranged.canFire = true
				--end
			end
		end
	end
	function RangedWeaponSystem:drawUI(dt)
		for _, entity in pairs(self.drawableWithParentandAmmo.objects) do
			local item = entity:get(Item)
			if item.isEquipped then
				local ranged = entity:get(Ranged)
				local parent = entity:get(Parent).Entity
				local parentPosition = parent:get(Body).Position
				local ammo = entity:get(Ammo)

				love.graphics.push()

				love.graphics.translate(parentPosition:split())
				love.graphics.setColor(1, 1, 1, 1)
				love.graphics.print(ammo.ValueInMag, -50, 0, 0, 0.25, -0.25)
				love.graphics.setColor(0.9, 0.9, 0.9, 1)
				love.graphics.print(ammo.Value-ammo.ValueInMag, -50, -20, 0, 0.2, -0.2)

				love.graphics.pop()
			end
		end
	end
	function RangedWeaponSystem:reload(entity)
		local weapon = entity:get(Inventory).Equipped
		local ammo = weapon:get(Ammo)
		if weapon and ammo then
			ammo:reload()
		end
	end
	function RangedWeaponSystem:fireRangedStop(weapon, parent)
		local item = weapon:get(Item)
		local ranged = weapon:get(Ranged)
		local ammo = weapon:get(Ammo)
		--print(ranged.FireRate)
		if ranged.FireMode == "semi" then
			ranged.canFire = true
		elseif ranged.FireMode == "delayed" then
		end
		ranged.triggerDown = false
	end
	function RangedWeaponSystem:newProjectileType(options)
		self.ProjectileTypes[options.name] = {}
		local newType = self.ProjectileTypes[options.name]
		newType.Name = options.name
		newType.Sound = options.sound or sounds.Pistol1
		newType.Position = options.position or Vector2.new()
		newType.Damage = options.damage or 1
		newType.Decay = options.decay or 10
		newType.Angle = options.angle or 0
		newType.Bloom = options.bloom or 0
		newType.Velocity = options.velocity or 1000
		newType.Bounces = options.bounces or 1
		newType.Parent = options.parent or nil
		newType.Mass = options.mass or 1
		newType.Shots = options.shots or 1
		newType.DecayFunction = options.decayfunction or function(velocity, baseDamage, decayFactor, isVelocity)
			local scale = math.pow(decayFactor/velocity, 1)
			local damage = baseDamage*scale
			return damage
		end
	end
	function RangedWeaponSystem:createProjectile(projectileType, parent)
		local pType = self.ProjectileTypes[projectileType]
		local parentPosition = parent:get(Parent).Entity:get(Body).Position
		local angle = math.atan2(mousePosWorld.y-parentPosition.y, mousePosWorld.x-parentPosition.x)
		local parentBody = parent:get(Parent).Entity:get(Body)
		local parentCollider = parentBody.Collider

		pType.Sound:stop()
		local sound = pType.Sound:play()
		sound:setPitch(game.speed*math.random2(1, 1.1))
		sound:setEffect("reverb")
		--cxxsound:setPosition(parentBody.Position:split())
		for i=1, pType.Shots do
			local projectile = Entity(projectileType .." Bullet")
				:give(Body, {"Circle"}, parentPosition, angle, 5, 0.012)
				:give(Projectile, angle+math.random2(-pType.Bloom/2, pType.Bloom/2), pType.Velocity, pType.Damage, pType.DecayFunction)
				:give(Decay, pType.Decay)
				:give(Parent, parent)
				:give(Light, {1, 0.8, 0.5}, 10, true, 4)
				:apply()
			projectile:get(Projectile).Bounces = pType.Bounces
			projectile:get(Body).Collider:setRestitution(0.4)
			projectile:get(Body).Collider:setCollisionClass("Bullet")
			GameInstance:addEntity(projectile)
		end
	end
	function RangedWeaponSystem:fireRanged(weapon, parent)
		local item = weapon:get(Item)
		local ranged = weapon:get(Ranged)
		local ammo = weapon:get(Ammo)
		local light = weapon:get(Light)

		local canFire = false
		if ammo then
			if ranged.canFire and ammo:canFire() then
				canFire = true
				ammo:fire()
			end
		else
			if ranged.canFire then
				canFire = true
			end
		end
		if canFire then
			ranged.canFire = false
			ranged.triggerDown = true
			if ranged.FireMode == "semi" then
				--ranged.debounce = true
			else
				ranged.fireTime = ranged.FireRate
			end
			if light then
				light.Trigger(math.random(50, 100))
				--Luven.setLightPower(light.id,20)
			end

			self:createProjectile(ranged.Type, weapon)

			local parentPosition = weapon:get(Parent).Entity:get(Body).Position
			local parentCollider = weapon:get(Parent).Entity:get(Body).Collider
			local angle = math.atan2(mousePosWorld.y-parentPosition.y, mousePosWorld.x-parentPosition.x)
			local impulse = Vector2.new(1, 0)
			if ranged.Type == "Pistol" then
				impulse = impulse*75
				game:tweenEffectAmountFrom(0.5, 0.25)
			elseif ranged.Type == "SMG" then
				impulse = impulse*75
				game:tweenEffectAmountFrom(0.5, 0.25)
			elseif ranged.Type == "Shotgun" then
				impulse = impulse*500
				game:tweenEffectAmountFrom(0, 0.5)
			elseif ranged.Type == "Sniper" then
				impulse = impulse*1000
				game:tweenEffectAmountFrom(0, 0.5)
			end
			impulse.angle = math.pi+angle
			parentCollider:applyLinearImpulse(impulse:split())
		end
	end
	function RangedWeaponSystem:postDraw(dt)
		if game.debugLevel > 1 then
			local offsetX, offsetY, width, height = 0, 100, 150, 100
			for name, cType in pairs(self.ProjectileTypes) do
			--print("-------")
			--local cType = self.ProjectileTypes["SMG"]
				love.graphics.rectangle("line", offsetX, offsetY, width, height)
				love.graphics.print(name, offsetX, height+offsetY-height/2-25/2, 0, 0.25, 0.25)
				local resolution = 200
				local line = {}
				for i=1, resolution, 2 do
					line[#line+1] = offsetX+(i-1)*width/resolution
					line[#line+1] = offsetY+height/cType.Damage*cType.DecayFunction(cType.Velocity, cType.Damage, cType.Velocity*(i/resolution))
					--print(i/resolution)
				end
				line[#line+1] = offsetX+width
				line[#line+1] = offsetY+height
				love.graphics.line(line)
				offsetY = offsetY+height
			end
		end
	end
RangedWeaponSystem:newProjectileType{
	name = "SMG",
	sound = sounds.Uzi1_2,
	damage = 36,
	decay = 10,
	bloom = 0.25,
	bounces = 3,
	velocity = 5500,
	mass = 0.012,
	shots = 1,
	decayfunction = function(velocity, baseDamage, decayFactor, isVelocity)
		local scale = math.pow(decayFactor/velocity, 1.2)
		local damage = baseDamage*scale
		return damage
	end
}
RangedWeaponSystem:newProjectileType{
	name = "Pistol",
	sound = sounds.Pistol1,
	--position = 
	damage = 25,
	decay = 10,
	--angle = 0,
	bloom = 0.1,
	bounces = 2,
	velocity = 4500,
	--parent = nil,
	mass = 0.01,
	shots = 1,
	decayfunction = function(velocity, baseDamage, decayFactor, isVelocity)
		local scale = math.pow(decayFactor/velocity, 0.8)
		local damage = baseDamage*scale
		return damage
	end
}
RangedWeaponSystem:newProjectileType{
	name = "Shotgun",
	sound = sounds.Shotgun,
	--position = 
	damage = 27,
	decay = 10,
	--angle = 0,
	bloom = 0.6,
	velocity = 3000,
	--parent = nil,
	mass = 0.008,
	shots = 12,
	decayfunction = function(velocity, baseDamage, decayFactor, isVelocity)
		local scale = math.pow(decayFactor/velocity, 3)
		local damage = baseDamage*scale
		return damage
	end
}
RangedWeaponSystem:newProjectileType{
	name = "Sniper",
	sound = sounds.Sniper1,
	--position = 
	damage = 170,
	decay = 5,
	bounces = 5,
	--angle = 0,
	bloom = 0.05,
	velocity = 10000,
	--parent = nil,
	mass = 0.05,
	shots = 1,
	decayfunction = function(velocity, baseDamage, decayFactor, isVelocity)
		--print(velocity, decayFactor)
		local scale = math.pow(decayFactor/velocity, 1.6)
		local damage = baseDamage*scale
		return damage
	end
}

GameInstance:addSystem(rangedweaponsystem, "reload", "reload", true)
GameInstance:addSystem(rangedweaponsystem, "fireRanged", "fireRanged", true)
GameInstance:addSystem(rangedweaponsystem, "fireRangedStop", "fireRangedStop", true)
GameInstance:addSystem(rangedweaponsystem, "update", "update", true)
GameInstance:addSystem(rangedweaponsystem, "drawUI", "drawUI", true)
GameInstance:addSystem(rangedweaponsystem, "postDraw", "postDraw", true)