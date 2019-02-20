RangedWeaponSystem = System({Item, Activatable, Ranged, Ammo, "ammo"}, {Item, Activatable, Ranged, "generic"}, {Item, Activatable, Ranged, Drawable, "drawable"})
	rangedweaponsystem = RangedWeaponSystem()
	function RangedWeaponSystem:update(dt)
		for _, entity in pairs(self.generic.objects) do
			local item = entity:get(Item)
			local ranged = entity:get(Ranged)
			--print(ranged.canFire)
			if ranged.FireRate == -1 then
			elseif ranged.fireTime > 0 then
				ranged.fireTime = ranged.fireTime-dt
			elseif ranged.fireTime <=0 then
				ranged.canFire = true
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
		if ranged.FireRate == -1 then
			ranged.canFire = true
		end
	end
	function RangedWeaponSystem:fireRanged(weapon, parent)
		local item = weapon:get(Item)
		local ranged = weapon:get(Ranged)
		local ammo = weapon:get(Ammo)

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
			local parentPosition = parent:get(Body).Position
			local angle = math.atan2(mousePosWorld.y-parentPosition.y, mousePosWorld.x-parentPosition.x)
			--print(angle, Vector2.new(math.cos(angle)*20, math.sin(angle)*20))
			if ranged.FireRate == -1 then
				--ranged.debounce = true
			else
				ranged.fireTime = ranged.FireRate
			end
			if ranged.Type == "Pistol" then
				sounds.pew:stop()
				sound = sounds.pew:play():setPitch(game.speed*math.random2(0.6, 1))
				--for i=1, 1 do
					local bullet = Entity("Pistol Bullet")
						:give(Body, {"Rectangle"}, parentPosition, angle, Vector2.new(20, 5), 0.1)
						:give(Projectile, angle+math.random2(-0.06, 0.06), 250, 10)
						:give(Decay, 0.5)
						:give(Parent, parent)
						:apply()
					bullet:get(Body).Collider:setRestitution(0)
					bullet:get(Body).Collider:setCollisionClass("Bullet")
					bullet:get(Body).Collider:setFriction(0)
					GameInstance:addEntity(bullet)
				--end
			elseif ranged.Type == "SMG" then
				sounds.pew:stop()
				sound = sounds.pew:play():setPitch(game.speed*math.random2(0.6, 1))
				--for i=1, 1 do
					local bullet = Entity("Pistol Bullet")
						:give(Body, {"Rectangle"}, parentPosition, angle, Vector2.new(20, 4), 0.12)
						:give(Projectile, angle+math.random2(-0.1, 0.1), 350, 10)
						:give(Decay, 0.5)
						:give(Parent, parent)
						:apply()
					bullet:get(Body).Collider:setRestitution(0)
					bullet:get(Body).Collider:setCollisionClass("Bullet")
					bullet:get(Body).Collider:setFriction(0)
					GameInstance:addEntity(bullet)
				--end
			elseif ranged.Type == "Shotgun" then
				sounds.pew:stop()
				sound = sounds.pew:play():setPitch(game.speed*math.random2(0.6, 1))
				for i=1, 9 do
					local bullet = Entity("Pistol Bullet")
						:give(Body, {"Rectangle"}, parentPosition, angle, Vector2.new(6, 4), 0.05)
						:give(Projectile, angle+math.random2(-0.15, 0.15), 200, 10)
						:give(Decay, 0.1)
						:give(Parent, parent)
						:apply()
					bullet:get(Body).Collider:setRestitution(0)
					bullet:get(Body).Collider:setCollisionClass("Bullet")
					bullet:get(Body).Collider:setFriction(0)
					GameInstance:addEntity(bullet)
				end
			end
		end
	end

GameInstance:addSystem(rangedweaponsystem, "reload", "reload", true)
GameInstance:addSystem(rangedweaponsystem, "fireRanged", "fireRanged", true)
GameInstance:addSystem(rangedweaponsystem, "fireRangedStop", "fireRangedStop", true)
GameInstance:addSystem(rangedweaponsystem, "update", "update", true)
--GameInstance:addSystem(rangedweaponsystem, "draw", "draw", true)