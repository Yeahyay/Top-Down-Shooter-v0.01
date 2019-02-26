Health = Component(function(self, health, maxHealth, regenRate, regenRateDelay)
	self.Value = health or 100;
	self.DisplayValue = self.value;
	self.MaxHealth = maxHealth or health or 100;
	self.RegenRate = regenRate or 5;
	self.RegenRateDelay = regenRateDelay or 0;
	self.RegenRateDelayStart = 0;
	self.LastChanged = timer;
end)