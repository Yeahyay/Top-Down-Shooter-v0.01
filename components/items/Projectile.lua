Projectile = Component(function(self, angle, velocity, damage, decayFunction)
	self.Angle = angle or 0
	self.NewAngle = 0
	self.Velocity = velocity or 200
	self.BaseDamage = damage or 20
	self.CreatedAt = timer
	self.Bounces = 1
	self.hit = false
	self.dead = false
	self.destroyed = false
	self.Damage = self.BaseDamage
	self.LastHit = nil
	self.ProcessDamage = function(decayFactor)
		local isVelocity = true
		if not decayFactor then
			decayFactor = timer-self.CreatedAt
			isVelocity = false
		end
		self.Damage = decayFunction(self.Velocity, self.BaseDamage, decayFactor, isVelocity)
		return self.Damage
	end
end)