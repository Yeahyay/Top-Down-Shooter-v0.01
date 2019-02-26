Ranged = Component(function(self, rangedType, fireMode, fireRate) 
	self.Type = rangedType or "Pistol"
	self.FireMode = fireMode or "semi"
	self.FireRate = fireRate or 0.25
	self.fireTime = 0
	self.canFire = true
	self.triggerDown = false
end)