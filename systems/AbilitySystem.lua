local AbilitySystem = System({Ability, "abilityPool"})
	abilitysystem = AbilitySystem()
	function AbilitySystem:update(dt)
		for k, v in pairs(self.abilityPool.objects) do
			local ability = v:get(Ability)
			for _, currentAbility in pairs(ability.abilities) do
				if currentAbility.onCooldown then -- on cooldown
					currentAbility.timeDown = currentAbility.timeDown+dt
					if currentAbility.timeDown > currentAbility.cooldown then
						currentAbility:reset()
					end
				elseif currentAbility.active then -- not on cooldown
					if currentAbility.duration <= 0 then -- one shot
						currentAbility:prefunc(v, unpack(currentAbility.extraArgs))
						currentAbility:activefunc(v, unpack(currentAbility.extraArgs))
						currentAbility:postfunc(v, unpack(currentAbility.extraArgs))
						currentAbility:deactivate()
					elseif currentAbility.timeActive == 0 then -- not one shot, at the beginning, activate pre-function
						currentAbility:prefunc(v, unpack(currentAbility.extraArgs))
						currentAbility.timeActive = currentAbility.timeActive+dt
					elseif currentAbility.timeActive >= currentAbility.duration then -- not at the end, activate post-function
						currentAbility:postfunc(v, unpack(currentAbility.extraArgs))
						currentAbility:deactivate()
					else -- not at the beginning or the end, activate active-function
						currentAbility:activefunc(v, unpack(currentAbility.extraArgs))
						currentAbility.timeActive = currentAbility.timeActive+dt
					end
				end
			end
		end
	end
	--[[function AbilitySystem:draw()
		for k, v in pairs(self.abilityPool.objects) do
			local ability = entity:get(Ability)
		end
	end
	function AbilitySystem:entityAdded(entity)
		local ability = entity:get(Ability)
	end]]
GameInstance:addSystem(abilitysystem, "update", "update", true)
--GameInstance:addSystem(abilitysystem, "draw", "draw", false)