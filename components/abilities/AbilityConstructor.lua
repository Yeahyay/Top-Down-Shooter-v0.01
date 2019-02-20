--function that constructs new abilities that can be used generically
--AbilityConstructor = {}
--AbilityConstructor.__index = AbilityConstructor

--[[function AbilityConstructor.new(name, duration, cooldown, damage, prefunc, activefunc, postfunc)
	local self = setmetatable({}, self)
	self.name = name
	self.prefunc = prefunc or function() end--print("No pre function") end
	self.activefunc = activefunc
	self.postfunc = postfunc or function() end--print("No post function") end
	self.duration = duration or 0.1
	self.cooldown = cooldown or 3
	self.timeActive = 0
	self.timeDown = 0
	self.damage = damage or 1
	self.active = false
	self.onCooldown = false
	self.extraArgs = {}
	self.toActive = nil
	self.toPost = nil
	self.getTimeLeft = function(self)
		if self.onCooldown then
			local timeLeft = self.cooldown-self.timeDown
			return string.format("%.3f seconds", timeLeft)
		else
			return "Ready"
		end
	end
	self.debug = false
	self.print = function(...) if self.debug then print(...) end end
	self.activate = function(...)
		if not self.active then
			if self.onCooldown then
				self.print("Ability "..self.name .." is on cooldown for "..self.cooldown-self.timeDown .." seconds.")
			else
				self.print("Activated ability "..self.name .." .")
				self.active = true
				self.extraArgs = {...}
			end
		else
			self.print("Ability "..self.name .." is already active.")
		end
	end
	self.deactivate = function(self)
		if self.active then
			self.print("Deactivated ability "..self.name ..".")
			self.active = false
			self.onCooldown = true
		else
			self.print("Ability "..self.name .." is already inactive.")
		end
	end
	self.reset = function(self)
		self.timeActive = 0
		self.timeDown = 0
		self.active = false
		self.onCooldown = false
		self.print("Reset ability "..self.name ..".")
	end
	return self
end]]
AbilityConstructor = class("AbilityConstructor")
	function AbilityConstructor:init(name, duration, cooldown, damage, prefunc, activefunc, postfunc)
		self.name = name
		--self.prefunc = prefunc or function() end--print("No pre function") end
		--self.activefunc = activefunc or function() end
		--self.postfunc = postfunc or function() end--print("No post function") end
		self.duration = duration or 0.1
		self.cooldown = cooldown or 3
		self.timeActive = 0
		self.timeDown = 0
		self.damage = damage or 1
		self.active = false
		self.onCooldown = false
		self.extraArgs = {}
		self.toActive = nil
		self.toPost = nil
		self.debug = false
	end
	function AbilityConstructor:prefunc(...)
	end
	function AbilityConstructor:activefunc(...)
	end
	function AbilityConstructor:postfunc(...)
	end
	function AbilityConstructor:getTimeLeft()
		if self.onCooldown then
			local timeLeft = self.cooldown-self.timeDown
			return string.format("%.3f seconds", timeLeft)
		else
			return "Ready"
		end
	end
	function AbilityConstructor:print(...)
		if self.debug then
			print(...)
		end
	end
	function AbilityConstructor:activate(...)
		if not self.active then
			if self.onCooldown then
				self.print("Ability "..self.name .." is on cooldown for "..self.cooldown-self.timeDown .." seconds.")
			else
				self.print("Activated ability "..self.name .." .")
				self.active = true
				self.extraArgs = {...}
			end
		else
			self.print("Ability "..self.name .." is already active.")
		end
	end
	function AbilityConstructor:deactivate()
		if self.active then
			self.print("Deactivated ability "..self.name ..".")
			self.active = false
			self.onCooldown = true
		else
			self.print("Ability "..self.name .." is already inactive.")
		end
	end
	function AbilityConstructor:reset()
		self.timeActive = 0
		self.timeDown = 0
		self.active = false
		self.onCooldown = false
		self.print("Reset ability "..self.name ..".")
	end
--[[function AbilityConstructor.new(name, duration, cooldown, damage, prefunc, activefunc, postfunc)
	local ability = {}
	ability.name = name
	ability.prefunc = prefunc or function() end--print("No pre function") end
	ability.activefunc = activefunc
	ability.postfunc = postfunc or function() end--print("No post function") end
	ability.duration = duration or 0.1
	ability.cooldown = cooldown or 3
	ability.timeActive = 0
	ability.timeDown = 0
	ability.damage = damage or 1
	ability.active = false
	ability.onCooldown = false
	ability.extraArgs = {}
	ability.toActive = nil
	ability.toPost = nil
	ability.getTimeLeft = function(self)
		if self.onCooldown then
			local timeLeft = self.cooldown-self.timeDown
			return string.format("%.3f seconds", timeLeft)
		else
			return "Ready"
		end
	end
	ability.debug = false
	ability.print = function(...) if ability.debug then print(...) end end
	ability.activate = function(self, ...)
		if not self.active then
			if self.onCooldown then
				self.print("Ability "..self.name .." is on cooldown for "..self.cooldown-self.timeDown .." seconds.")
			else
				self.print("Activated ability "..self.name .." .")
				self.active = true
				self.extraArgs = {...}
			end
		else
			self.print("Ability "..self.name .." is already active.")
		end
	end
	ability.deactivate = function(self)
		if self.active then
			self.print("Deactivated ability "..self.name ..".")
			self.active = false
			self.onCooldown = true
		else
			self.print("Ability "..self.name .." is already inactive.")
		end
	end
	ability.reset = function(self)
		self.timeActive = 0
		self.timeDown = 0
		self.active = false
		self.onCooldown = false
		self.print("Reset ability "..ability.name ..".")
	end
	ability.__tostring = function() return "Ability "..name end
	setmetatable(ability, ability)
	return ability
end]]