Projectile = Component(function(self, angle, velocity, damage)
	self.Angle = angle or 0
	self.Velocity = velocity or 200
	self.Damage = damage or 20
end)