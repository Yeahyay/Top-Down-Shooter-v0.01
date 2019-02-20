local DecaySystem = System({Decay, "withDecay"})
	decay = DecaySystem()
	function DecaySystem:update(dt)
		for k, v in pairs(self.withDecay.objects) do
			local decay = v:get(Decay)
			if timer >= decay.EndTime then
				--print("removing entity "..v.name)
				GameInstance:removeEntity(v)
			end
		end
	end
	function DecaySystem:draw()
		for k, v in pairs(self.withDecay.objects) do
			local decay = v:get(Decay)
		end
	end
	function DecaySystem:entityAdded(entity)
		local decay = entity:get(Decay)
		--print(decay.lifetime)
	end
	function DecaySystem:entityRemoved(entity)
	end
GameInstance:addSystem(decay, "update", "update", true)
--GameInstance:addSystem(decay, "draw", "draw", true)