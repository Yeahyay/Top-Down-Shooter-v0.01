Enemy = Component(function(self)
	self.Target = nil
	self.AbilityTimer = 0
	self.AbilityTimerStart = 0
	self.AbilityDelay = 0.5
	self.canUseAbility = false
end)