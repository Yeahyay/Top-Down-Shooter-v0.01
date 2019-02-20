Ability = Component(function(self, player, abilities)
	self.abilities = {}
	for k, v in pairs(abilities) do
		self[v.name] = v()
		self.abilities[k] = self[v.name]
	end
	self.player = player or false
	--self.get = function(ability) return self.abilities[ability] end
end)