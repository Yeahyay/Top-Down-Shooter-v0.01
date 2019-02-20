Inventory = Component(function(self, weight, volume, slots, columns, rows)
	self.Weight = weight or 50
	self.Volume = volume or 100
	self.Slots = slots or 10
	self.ItemsTotal = 0
	self.Items = {}
	self.ItemsID = {}
	self.Columns = columns or math.ceil(math.sqrt(slots))
	self.Rows = rows or math.ceil(math.sqrt(slots))
	self.EquippedSlot = 1
	self.Equipped = nil
	--print(self.Columns, self.Rows, self.Slots)
end)