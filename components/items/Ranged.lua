Ranged = Component(function(self, rangedType, fireRate) 
	self.Type = rangedType or "Pistol"
	self.FireRate = fireRate or 0.25
	self.fireTime = 0
	self.canFire = true
end)