ItemSystem = System({Item, Body, "generic"}, {Item, Drawable, Body, "drawable"}, {Item, Parent, "inInventory"})
	itemsystem = ItemSystem()
	function ItemSystem:update(dt)
		for _, entity in pairs(self.generic.objects) do
			local body = entity:get(Body)
			local collider = body.Collider
			local itemComponent = entity:get(Item)
			if collider:enter("Player") and timer > itemComponent.PickupAbleTime then
				local colliderData = collider:getEnterCollisionData("Player")
				local player = colliderData.collider:getObject()
				GameInstance:emit("addItem", player, entity)
			end
		end
		for _, entity in pairs(self.inInventory.objects) do
			local body = entity:get(Body)
			local collider = body.Collider
			local parent = entity:get(Parent).Entity
			local item = entity:get(Item)
			local inventory = parent:get(Inventory)
			collider:setPosition((parent:get(Body).Position+inventory.EquipVector*64):split())
			collider:setAngle(inventory.EquipVector.angle+math.pi/2)
			if item.isEquipped then
				if not entity:has(Drawable) then
					entity:give(Drawable):apply()
				end
			else
				if entity:has(Drawable) then
					entity:remove(Drawable):apply()
				end
			end
			--print("entity "..entity.name .."; "..body.uuid .." is parented to entity "..parent.Name)
		end
	end
	function ItemSystem:entityAddedTo(entity, pool)
		if pool == self.inInventory then
			local parent = entity:get(Parent)
			local body = entity:get(Body)
			local collider = body.Collider
			local itemComponent = entity:get(Item)
			itemComponent.Limbo = true
			collider:setActive(false)
			entity:give(Drawable):apply()
			--print("item "..entity.name .." has been added to "..tostring(parent.Name))
		end
		if pool == self.drawable then
			--print(entity, timer)
			--print("item "..entity.name .." has been added to "..tostring(.Name))
		end
	end
	function ItemSystem:entityRemovedFrom(entity, pool)
		if pool == self.inInventory then
			local parent = entity:get(Parent).Entity
			local body = entity:get(Body)
			local collider = body.Collider
			local itemComponent = entity:get(Item)
			local pX, pY = parent:get(Body).Position:split()
			collider:setPosition(pX+0*math.random2(-50, 50), pY+0*math.random2(-50, 50))
			collider:setLinearVelocity(math.random2(-100, 100), math.random2(50, 200))
			--collider:setAngularVelocity(math.random2(-10, 10))
			itemComponent.PickupAbleTime = timer+itemComponent.PickupAbleDelay
			collider:setActive(true)
			--entity:remove(Drawable):apply()
			--print("item "..entity.name .." has been added to "..tostring(parent.Name))
		end
	end
	function ItemSystem:activateItem(item, entity)
		if item:has(Activatable) then
			if item:has(Melee) then
				
			elseif item:has(Ranged) then
				GameInstance:emit("fireRanged", item, entity)
			end
		end
	end
	function ItemSystem:activateItemStop(item, entity)
		if item:has(Activatable) then
			if item:has(Melee) then
				
			elseif item:has(Ranged) then
				GameInstance:emit("fireRangedStop", item, entity)
			end
		end
	end
	function ItemSystem:drawItem(entity, position, angle, scale, sizeBounds, color)
		scale = scale or 1
		angle = angle or math.pi/-4
		if entity and position then
			local body = entity:get(Body)
			local size = body.Size
			local boundScale
			local sizeScaled = size
			if sizeBounds then
				bX, bY = (sizeBounds/size):split()
				if bX < bY then
					sizeScaled = size*bX
				else
					sizeScaled = size*bY
				end
			end
			sizeScaled = sizeScaled*scale
			love.graphics.push()

			love.graphics.setColor(0.6, 0.6, 0.6, color and color[4] or 1)
			love.graphics.translate(position:split())
			love.graphics.rotate(angle)
			love.graphics.rectangle("fill", -sizeScaled.x/2, -sizeScaled.y/2, sizeScaled.x, sizeScaled.y)

			love.graphics.pop()
		end
	end
	function ItemSystem:draw(entity)
		for _, entity in pairs(self.drawable.objects) do
			local item = entity:get(Item)
			--if not item.Limbo then
				local body = entity:get(Body)
				--local size = body.Size
				self:drawItem(entity, body.Position, body.Angle, 1)
			--end
		end
	end
GameInstance:addSystem(itemsystem, "activateItem", "activateItem", true)
GameInstance:addSystem(itemsystem, "activateItemStop", "activateItemStop", true)
GameInstance:addSystem(itemsystem, "drawItem", "drawItem", true)
GameInstance:addSystem(itemsystem, "update", "update", true)
GameInstance:addSystem(itemsystem, "draw", "draw", true)