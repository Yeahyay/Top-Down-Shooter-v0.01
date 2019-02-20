Decay = Component(function(self, lifetime)
	self.Lifetime = lifetime or 1
	self.StartTime = timer
	self.EndTime = self.StartTime+self.Lifetime
end)