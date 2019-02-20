Ammo = Component(function(self, value, maxValue, valueInMag, maxInMag)
	self.Value = value or 2
	self.MaxValue = maxValue or self.Value
	self.ValueInMag = valueInMag or 7
	self.MaxInMag = MaxInMag or self.ValueInMag
	self.canFire = function(self)
		if self.ValueInMag > 0 then
			return true
		else
			return false
		end
	end
	self.reload = function(self)
		--self.Value = self.Value-self.MaxInMag-self.ValueInMag
		--reloady stuff; maybe a wait or something
		if self.Value >= self.MaxInMag then
			self.ValueInMag = self.MaxInMag
		else
			self.ValueInMag = self.Value
		end
	end
	self.fire = function(self)
		self.ValueInMag = self.ValueInMag-1
		self.Value = self.Value-1
		--print(self.Value, self.ValueInMag, self.MaxValue, self.MaxInMag)
	end
end)