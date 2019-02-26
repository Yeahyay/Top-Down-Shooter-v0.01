InventorySystem = System({Inventory, "generic"}, {Inventory, Drawable, "drawable"})
	inventorysystem = InventorySystem()
	function InventorySystem:update(dt)
		for _, entity in pairs(self.generic.objects) do
			local inventory = entity:get(Inventory)
			inventory.Equipped = inventory.Items[inventory.EquippedSlot]
			--if inventory.Equipped then
				if inventory.Equipped and inventory.Equipped ~= inventory.LastEquipped then
					inventory.Equipped:get(Item).isEquipped = true
					--inventory.Equipped:give(Drawable):apply()
				end
				if inventory.LastEquipped then
					if inventory.LastEquipped ~= inventory.Equipped then
						inventory.LastEquipped:get(Item).isEquipped = false
						--inventory.LastEquipped:remove(Drawable):apply()
					end
				end
				inventory.LastEquipped = inventory.Items[inventory.EquippedSlot]
			--end

			local inventory = entity:get(Inventory)
			local body = entity:get(Body)
			local angle = math.atan2(mousePosWorld.y-body.Position.y, mousePosWorld.x-body.Position.x)
			inventory.EquipVector.angle = angle
		end
	end
	function InventorySystem:draw()
		--[[for _, entity in pairs(self.generic.objects) do
			local inventory = entity:get(Inventory)
			local body = entity:get(Body)
			local angle = math.atan2(mousePosWorld.y-body.Position.y, mousePosWorld.x-body.Position.x)
			inventory.EquipVector.angle = angle
			GameInstance:emit("drawItem", inventory.Equipped, body.Position+inventory.EquipVector*32, angle+math.pi/2, 1)
		end]]
	end
	function InventorySystem:drawUI()
		for _, entity in pairs(self.drawable.objects) do
			local inventory = entity:get(Inventory)
			local body = entity:get(Body)
			local cellSize = Vector2.new(20, 20)
			local offset = Vector2.new(40, -40)

			love.graphics.push()

			local lastChanged = math.clamp(0.5+0.5*(1.5-timer+inventory.LastChanged), 0, 1)
			local alpha = lastChanged
			do
				local offset = offset-cellSize/2
				love.graphics.translate(body.Position:split())
				love.graphics.setColor(0.3, 0.3, 0.3, 0.7*alpha)
				love.graphics.rectangle("fill", offset.x, offset.y+cellSize.y, cellSize.x*inventory.Columns, -cellSize.y*inventory.Rows)
				love.graphics.setColor(0.8, 0.8, 0.8, alpha)
				love.graphics.setLineWidth(2)
				local index = 1
				for x=1, inventory.Columns do
					for y=1, inventory.Rows do
						index = x+(y-1)*inventory.Rows
						if index > inventory.Slots then
							break
						elseif index == inventory.EquippedSlot then
							love.graphics.setColor(1, 1, 1, alpha)
						else
							love.graphics.setColor(0.8, 0.8, 0.8, alpha)
						end
						local position = Vector2.new(offset.x+(x-1)*cellSize.x, offset.y-(y-1)*cellSize.y)
						love.graphics.rectangle("line", position.x, position.y, cellSize.x-1, cellSize.y-1)
					end
				end
			end
			local x, y = 0, 0
			if inventory.ItemsTotal > 0 then
				for id, index in pairs(inventory.ItemsID) do
					local position = Vector2.new(offset.x+x*cellSize.x, offset.y-y*cellSize.y)
					GameInstance:emit("drawItem", self:getItemByID(inventory, id), position, nil, 0.8, cellSize, {1, 1, 1, alpha})
					x = x+1
					if x > inventory.Columns-1 then x = 0 y = y+1 end
				end
			end
			local equipped = nil
			if inventory.Equipped then
				equipped = inventory.Equipped:get(Item).Name
			end

			love.graphics.setColor(1, 1, 1, alpha)
			love.graphics.print(tostring(equipped), offset.x, offset.y, 0, 0.25, -0.25)
			love.graphics.pop()
		end
	end
	function InventorySystem:getItemByID(inventory, id)
		return inventory.Items[inventory.ItemsID[id]]
	end
	function InventorySystem:fire(entity)
		local item = entity:get(Inventory).Equipped
		if item then
			GameInstance:emit("activateItem", item, entity)
		end
	end
	function InventorySystem:fireStop(entity)
		local item = entity:get(Inventory).Equipped
		if item then
			GameInstance:emit("activateItemStop", item, entity)
		end
	end
	function InventorySystem:inventoryLeft(entity)
		local inventory = entity:get(Inventory)
		inventory.EquippedSlot = inventory.EquippedSlot-1
		inventory.LastChanged = timer
		if inventory.EquippedSlot < 1 then
			inventory.EquippedSlot = inventory.Slots
		end
	end
	function InventorySystem:inventoryRight(entity)
		local inventory = entity:get(Inventory)
		inventory.EquippedSlot = inventory.EquippedSlot+1
		inventory.LastChanged = timer
		if inventory.EquippedSlot > inventory.Slots then
			inventory.EquippedSlot = 1
		end
	end
	function InventorySystem:entityRemoved(entity)
		self:dropAll(entity)
	end
	function InventorySystem:removeItem(entity, item)
		local inventory = entity:get(Inventory)
		local itemComponent = item:get(Item)
		item.isEquipped = false
		--if item:has(Drawable) then
		--	item:remove(Drawable):apply()
		--end
		if not item:has(Drawable) then
			item:give(Drawable)
		end
		item:remove(Parent):apply()
		--end
		inventory.LastChanged = timer
		inventory.Items[inventory.ItemsID[item:get(Body).uuid]] = nil
		inventory.ItemsID[item:get(Body).uuid] = nil
		inventory.ItemsTotal = inventory.ItemsTotal-1
	end
	function InventorySystem:dropAll(entity)
		local inventory = entity:get(Inventory)
		local items = inventory.Items
		inventory.Equipped = nil
		for k, item in pairs(items) do
			self:removeItem(entity, item)
		end
	end
	function InventorySystem:addItem(entity, item)
		--print(entity, item)
		if entity:has(Inventory) then
			local inventory = entity:get(Inventory)
			local itemComponent = item:get(Item)
			inventory.LastChanged = timer
			item:give(Parent, entity):remove(Drawable):apply()
			inventory.Items[#inventory.Items+1] = item
			inventory.ItemsID[item:get(Body).uuid] = #inventory.Items
			inventory.ItemsTotal = inventory.ItemsTotal+1
			--itemComponent.ParentEntity = entity
			--GameInstance:emit("limbo", item)
			--print("entity "..entity.name.."; "..entity:get(Body).uuid.." has recieved item "..item.name.."; "..item:get(Body).uuid)
		else
			print("cannot give item to inventoryless entity")
		end
	end

GameInstance:addSystem(inventorysystem, "fire", "fire", true)
GameInstance:addSystem(inventorysystem, "fireStop", "fireStop", true)
GameInstance:addSystem(inventorysystem, "inventoryLeft", "inventoryLeft", true)
GameInstance:addSystem(inventorysystem, "inventoryRight", "inventoryRight", true)
GameInstance:addSystem(inventorysystem, "dropAll", "dropAll", true)
GameInstance:addSystem(inventorysystem, "addItem", "addItem", true)
GameInstance:addSystem(inventorysystem, "update", "update", true)
--GameInstance:addSystem(inventorysystem, "draw", "draw", true)
GameInstance:addSystem(inventorysystem, "drawUI", "drawUI", true)