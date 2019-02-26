Body = Component(function(self, shape, position, angle, size, mass, force, velocity, acceleration)
	self.shape = shape
	if Vector2.isVector(position) then
		self.Position = position
		self.Z = 1
	elseif Vector3.isVector3D(position) then
		self.Position = Vector2.new(position.x, position.y)
		self.Z = position.z
	end
	if self.shape[1] == "Rectangle" then
		self.Collider = GameWorld:newRectangleCollider(position.x-size.x/2, position.y-size.y/2, size.x, size.y)
	elseif self.shape[1] == "BSGRectangle" then
		self.Collider = GameWorld:newBSGRectangleCollider(position.x-size.x/2, position.y-size.y/2, size.x, size.y, self.shape[2])
	elseif self.shape[1] == "Circle" then
		assert(type(size) == "number", "size given is not a number")
		self.Collider = GameWorld:newCircleCollider(position.x-size/2, position.y-size/2, size)
	end
	self.isGrounded = false
	self.isDamping = true
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
	self.Collider:setLinearDamping(4)
	self.Collider:setAngularDamping(4)
	--print("-----")
	--for k, v in pairs(self.Collider) do print(k, v) end
end)
Body.name = "Body"