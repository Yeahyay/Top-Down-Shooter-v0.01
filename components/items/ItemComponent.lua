Item = Component(function(self, name, value, price, weight, volume)
	self.Value = value or 2 --intrinsic
	self.Price = price or 100 --currency
	self.Weight = weight or 1
	self.Volume = volume or 1
	--self.Limbo = false
	self.PickupAble = true
	self.PickupAbleTime = 0
	self.PickupAbleDelay = 1
	self.Name = name
end)