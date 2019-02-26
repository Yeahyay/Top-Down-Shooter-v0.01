Movement = Component(function(self, initSpeed, maxSpeed, speed, time, maxJumps)
	self.maxVelocity = maxSpeed or Vector2.new(400, 400)
	self.speed = speed or Vector2.new(2500, 2500)
	
	self.isDamping = true
	--[[self.isJumping = true
	self.jumpDebounce = false
	self.jumpInitSpeed = initSpeed or 400
	self.jumpMaxSpeed = maxSpeed or 600
	self.jumpConstantSpeed = speed or 100
	self.jumpTimeDefault = time or 20
	self.jumpTimeCurrent = self.jumpTimeDefault
	self.maxJumpsDefault = maxJumps or 1
	self.maxJumps = 5
	self.jumpsAvailable = 0
	self.jumps = 0]]
end)