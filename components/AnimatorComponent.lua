--init = require("init")
Animator = Component(function(self, image, size, gridDimensions, animationFrames, animationRate)
	self.size = size
	self.image = image
	self.BirghtnessColor = {1, 1, 1}
	self.Brightness = 0
	self.width, self.height = self.image:getWidth(), self.image:getHeight()
	self.offset = Vector2.new(gridDimensions.x*-0.5*self.size.x, gridDimensions.y*-0.5*self.size.y)
	self.grid = anim8.newGrid(gridDimensions.x, gridDimensions.y, self.width, self.height)
	self.static = true
	self.debounce = 2
	self.timeScale = 1
	self.cellSize = gridDimensions%self.size
	if animationRate > 0 then
		self.static = false
		self.animation = anim8.newAnimation(self.grid(unpack(animationFrames)), animationRate)
	end
end)