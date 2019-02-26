Player = Component(function(self, number, playerEntity)
	self.Number = number or 1
	self.Entity = playerEntity or error("Player component number ".. self.Number .." not given a player entity.")
end)