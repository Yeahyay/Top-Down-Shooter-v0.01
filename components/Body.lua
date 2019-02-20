--[[Body = Component(function(self, position, size, mass, force, velocity, acceleration)
	self.Position = position or Vector2.new()
	self.Size = size or Vector2.new()
	self.Mass = mass or 1
	self.Force = force or Vector2.new()
	self.Velocity = velocity or Vector2.new()
	self.Acceleration = acceleration or Vector2.new()
	self.grounded = false
	self.uuid = uuid()
end)
--Body.name = "Body"]]
Body = Component(function(self, shape, position, angle, size, mass, force, velocity, acceleration)
	if shape[1] == "Rectangle" then
		self.Collider = GameWorld:newRectangleCollider(position.x-size.x/2, position.y-size.y/2, size.x, size.y)
	elseif shape[1] == "BSGRectangle" then
		self.Collider = GameWorld:newBSGRectangleCollider(position.x-size.x/2, position.y-size.y/2, size.x, size.y, shape[2])
	end
	self.isGrounded = false
	self.isDamping = true
	self.Position = position or Vector2.new()
	self.Angle = angle
	self.Size = size or Vector2.new()
	self.Mass = mass or 1
	self.Force = force or Vector2.new()
	self.Velocity = velocity or Vector2.new()
	self.Acceleration = acceleration or Vector2.new()
	self.uuid = uuid()
	self.Collider:setAngle(self.Angle)
	--self.Collider:applyLinearImpulse(self.Force:split())
	self.Collider:setMass(self.Mass)
	self.Collider:setLinearDamping(0)
	--print("-----")
	--for k, v in pairs(self.Collider) do print(k, v) end
end)
Body.name = "Body"