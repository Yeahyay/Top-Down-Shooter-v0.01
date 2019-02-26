CameraComponent = Component(function(self, target, zoom, ZoomTarget)
	self.Position = Vector2.new()
	self.Zoom = zoom or 1
	self.Target = target
	self.PositionDamp = 0.1
	self.ZoomDamp = 0.025
	self.ZoomTarget = ZoomTarget or 1
end)