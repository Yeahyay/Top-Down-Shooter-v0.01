local LightSystem = System({Body, Light, "generic"}, {Parent, Body, Item, Light, "inInventory"})
	lightsystem = LightSystem()
	function LightSystem:update(dt)
		for _, entity in pairs(self.generic.objects) do
			local body = entity:get(Body)
			local light = entity:get(Light)
			local power = Luven.getLightPower(light.id)
			if light.isMuzzleFlash and timer > light.triggerTime and power > 0 then
				Luven.setLightPower(light.id, power/light.DecayRate)
			elseif power < 0.02 then
				power = 0
			else
			end
			Luven.setLightPosition(light.id, body.Position:split())
		end
		for _, entity in pairs(self.inInventory.objects) do
			local parent = entity:get(Parent).Entity
			local body = entity:get(Body)
			local size = body.Size
			local light = entity:get(Light)
			local inventory = parent:get(Inventory)
			local power = Luven.getLightPower(light.id)
			Luven.setLightPosition(light.id, (inventory.EquipVector*(size.y+2*power)+body.Position):split())
		end
	end
	function LightSystem:entityAdded(entity)
	end
	function LightSystem:entityRemoved(entity)
	end
	function LightSystem:draw()
	end
--GameInstance:addSystem(lightsystem, "damage", "damage", true)
GameInstance:addSystem(lightsystem, "update", "update", true)
--GameInstance:addSystem(lightsystem, "draw", "draw", true)