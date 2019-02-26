local ActionSystem = System()
	ActionSystem.keyActions = {}
	ActionSystem.mouseActions = {}
	ActionSystem.keyToActions = {}
	actionsystem = ActionSystem()
	function ActionSystem:keypressed(key)
	end
	function ActionSystem:keyreleased(key)
	end
	function ActionSystem:invokeAction(action, actionType, entity)
		local actionData
		if actionType == 1 then
			actionData = self.keyActions[action]
		elseif actionType == 2 then
			actionData = self.mouseActions[action]
		end
		if actionData.needEntity then
			if entity then
				GameInstance:emit(action, entity)
			else
				--print("Attempted to emit action "..action.."; no entity provided")
			end
		else
			GameInstance:emit(action)
		end
	end
	function ActionSystem:newAction(name, key, mouseButton, state, tapTimes, needEntity)
		if key then
			if not self.keyActions[name] then self.keyActions[name] = {} end
			self.keyToActions[key] = name
			self.keyActions[name].tapTimes = tapTimes or 1
			--self.keyActions[name].key = key -- one key per action
			if not self.keyActions[name].keys then self.keyActions[name].keys = {} end
			self.keyActions[name].keys[key] = key
			--self.keyActions[name].name = name
			self.keyActions[name].state = state or "constant"
			self.keyActions[name].stopDebounce = stopDebounce
			self.keyActions[name].stop = name.."Stop"
			--print(key, needEntity)
			self.keyActions[name].needEntity = needEntity or false
		elseif mouseButton then
			if not self.mouseActions[name] then self.mouseActions[name] = {} end
			--self.keyToActions[key] = name
			self.mouseActions[name].tapTimes = tapTimes or 1
			--self.mouseActions[name].mouse = mouse
			if not self.mouseActions[name].mouse then self.mouseActions[name].mouse = {} end
			self.mouseActions[name].mouse[mouseButton] = mouseButton
			--self.mouseActions[name].name = name
			self.mouseActions[name].state = state or "constant"
			self.mouseActions[name].stopDebounce = stopDebounce
			self.mouseActions[name].stop = name.."Stop"
			--print(key, needEntity)
			self.mouseActions[name].needEntity = needEntity or false
		end
	end
	function ActionSystem:inputDownStart(inputType, input, tapTimes, entity)
		if inputType == 1 then
			for name, properties in pairs(self.keyActions) do
				--if properties.state == "start" and properties.tapTimes == tapTimes and properties.key == input then
				if properties.state == "start" and properties.tapTimes == tapTimes and properties.keys[input] then
					--print("invoke start "..name)
					self:invokeAction(name, 1, entity)
				end
			end
		else
			for name, properties in pairs(self.mouseActions) do
				--if properties.state == "constant" and properties.tapTimes == tapTimes and properties.mouse == input then
				if properties.state == "start" and properties.tapTimes == tapTimes and properties.mouse[input] then
					self:invokeAction(name, 2, entity)
				end
			end
		end
	end
	function ActionSystem:inputDown(inputType, input, tapTimes, entity)
		if inputType == 1 then
			for name, properties in pairs(self.keyActions) do
				--if properties.state == "constant" and properties.tapTimes == tapTimes and properties.key == input then
				if properties.state == "constant" and properties.tapTimes == tapTimes and properties.keys[input] then
					self:invokeAction(name, 1, entity)
				end
			end
		else
			for name, properties in pairs(self.mouseActions) do
				--if properties.state == "constant" and properties.tapTimes == tapTimes and properties.mouse == input then
				if properties.state == "constant" and properties.tapTimes == tapTimes and properties.mouse[input] then
					self:invokeAction(name, 2, entity)
				end
			end
		end
	end
	function ActionSystem:inputDownStop(inputType, input, tapTimes, entity)
		if inputType == 1 then
			for name, properties in pairs(self.keyActions) do
				--if properties.state == "stop" and properties.tapTimes == tapTimes and properties.key == input then
				if properties.state == "stop" and properties.tapTimes == tapTimes and properties.keys[input] then
					--print("invoke stop "..name)
					self:invokeAction(name, 1, entity)
				end
			end
		else
			for name, properties in pairs(self.mouseActions) do
				--if properties.state == "constant" and properties.tapTimes == tapTimes and properties.mouse == input then
				if properties.state == "stop" and properties.tapTimes == tapTimes and properties.mouse[input] then
					self:invokeAction(name, 2, entity)
				end
			end
		end
	end
	function ActionSystem:update(dt)
	end
	function ActionSystem:draw()
		local i = 0
		local i2 = 0
		for name, v in pairs(self.keyActions) do
			love.graphics.print(name, 0, 400-(i-1)*120*0.7, 0, 0.25*0.7, -0.25*0.7)
			for k, v in pairs(v) do
				love.graphics.print("	"..tostring(k).." "..tostring(v), 0, 400-(i2+i-1)*20*0.7, 0, 0.25*0.7, -0.25*0.7)
				i2=i2+1
			end
			i=i+1
		end
	end
	function ActionSystem:entityAdded(entity)
		local movement = entity:get(Movement)
	end
	actionsystem:newAction("left", "a", nil, "constant", 1, true)
	actionsystem:newAction("right", "d", nil, "constant", 1, true)
	actionsystem:newAction("leftStart", "a", nil, "start", 1, true)
	actionsystem:newAction("rightStart", "d", nil, "start", 1, true)
	actionsystem:newAction("up", "w", nil, "constant", 1, true)
	actionsystem:newAction("down", "s", nil, "constant", 1, true)
	--actionsystem:newAction("jump", "space", nil, "constant", 1, true)
	--actionsystem:newAction("jumpStop", "space", nil, "stop", 1, true)
	actionsystem:newAction("respawn", "p", nil, "start", 1, false)
	--actionsystem:newAction("dashLeft", "a", nil, "start", 2, true)
	--actionsystem:newAction("dashRight", "d", nil, "start", 2, true)
	actionsystem:newAction("dropAll", "g", nil, "start", 1, true)
	actionsystem:newAction("inventoryLeft", "q", nil, "start", 1, true)
	actionsystem:newAction("inventoryRight", "e", nil, "start", 1, true)
	actionsystem:newAction("fire", nil, 1, "constant", 1, true)
	actionsystem:newAction("fireStop", nil, 1, "stop", 1, true)
	actionsystem:newAction("altFire", nil, 2, "constant", 1, true)
	actionsystem:newAction("reload", "r", nil, "start", 1, true)
GameInstance:addSystem(actionsystem, "inputDownStart", "inputDownStart", true)
GameInstance:addSystem(actionsystem, "inputDown", "inputDown", true)
GameInstance:addSystem(actionsystem, "inputDownStop", "inputDownStop", true)
GameInstance:addSystem(actionsystem, "keypressed", "keypressed", true)
GameInstance:addSystem(actionsystem, "keyreleased", "keyreleased", true)
GameInstance:addSystem(actionsystem, "update", "update", true)
--GameInstance:addSystem(actionsystem, "draw", "draw", true)