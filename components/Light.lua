Light = Component(function(self, color, power, isMuzzleFlash, decayRate)
	self.Color = color or {1, 1, 1, 1}
	self.Power = power or 0
	self.id = Luven.addNormalLight(0, 0, self.Color, self.Power)
	self.isMuzzleFlash = isMuzzleFlash or false
	self.DecayRate = decayRate or 1
	self.triggerTime = 0
	self.Trigger = function(amount)	self.triggerTime = timer self.Power = amount Luven.setLightPower(self.id, amount) end
	self.Remove = function() Luven.removeLight(self.id) end
end)