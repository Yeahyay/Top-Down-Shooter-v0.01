local InputSystem = System({Player, "withPlayer"})
	--local defaultInputs = {"w", "a", "s", "d", "space", "p"}
	InputSystem.keyInputs = {w=false, a=false, s=false, d=false, space=false, p=false, g=false, q=false, e=false, r=false}
	InputSystem.mouseInputs = {false, false}
	--[[for i, key in pairs(defaultInputs) do
		InputSystem.keyInputs[i] = {}
		InputSystem.keyInputs[i].key = key
		InputSystem.keyInputs[i].down = false
	end]]
	InputSystem.gamepadInputs = {}
	InputSystem.keyDebounce = {}
	InputSystem.mouseDebounce = {}
	inputsystem = InputSystem()
	local doubleTapFocus = nil -- make it independent for each key
	local doubleTapTimer = 0
	local doubleTapDebounce = false
	local doubleClickFocus = nil
	local doubleClickTimer = 0
	local doubleClickDebounce = false
	function InputSystem:mousepressed(x, y, mouse)
		if self.mouseInputs[mouse] ~= nil then
			self.mouseInputs[mouse] = true
			self.mouseDebounce[mouse] = false
			--self.doubleClick[mouse] = {}
		end
		if doubleClickFocus == mouse then

		else
			doubleClickDebounce = true
			doubleClickFocus = mouse
		end
		if doubleClickTimer == 0 then
			doubleClickTimer = 15
		end
	end
	function InputSystem:mousereleased(x, y, mouse)
		if self.mouseInputs[mouse] ~= nil then
			self.mouseInputs[mouse] = false
		end
		if mouse == doubleClickFocus then
			doubleClickDebounce = false
		elseif mouse ~= doubleClickFocus then
			doubleClickTimer = 0
		end 
	end
	function InputSystem:keypressed(key)
		if self.keyInputs[key] ~= nil then
			self.keyInputs[key] = true
			self.keyDebounce[key] = false
			--self.doubleTap[key] = {}
		end
		if doubleTapFocus == key then

		else
			doubleTapDebounce = true
			doubleTapFocus = key
		end
		if doubleTapTimer == 0 then
			doubleTapTimer = 15
		end
	end
	function InputSystem:keyreleased(key)
		if self.keyInputs[key] ~= nil then
			self.keyInputs[key] = false
		end
		if key == doubleTapFocus then
			doubleTapDebounce = false
		elseif key ~= doubleTapFocus then
			doubleTapTimer = 0
		end 
	end
	function InputSystem:inputs(inputType, entity)
		if inputType == 1 then
			for key, isPressed in pairs(self.keyInputs) do
				if isPressed then
					if not self.keyDebounce[key] then
						self.keyDebounce[key] = true
						GameInstance:emit("inputDownStart", 1, key, 1, entity)
					else
						GameInstance:emit("inputDown", 1, key, 1, entity)
					end
				elseif self.keyDebounce[key] then
					self.keyDebounce[key] =  false
					GameInstance:emit("inputDownStop", 1, key, 1, entity)
				end
			end
			if doubleTapTimer > 0 and doubleTapFocus then
				if self.keyInputs[doubleTapFocus] and not doubleTapDebounce then
					--print("Double tapped key "..doubleTapFocus)
					doubleTapDebounce = true
					for key, isPressed in pairs(self.keyInputs) do
						if isPressed then
							GameInstance:emit("inputDownStart", 1, key, 2, entity)
						end
					end
					doubleTapFocus = nil
				end
				doubleTapTimer = doubleTapTimer-1
			else
				doubleTapTimer = 0
				doubleTapFocus = nil
			end
		else
			for mouse, isPressed in pairs(self.mouseInputs) do
				if isPressed then
					if not self.keyDebounce[mouse] then
						self.keyDebounce[mouse] = true
						GameInstance:emit("inputDownStart", 2, mouse, 1, entity)
					else
						GameInstance:emit("inputDown", 2, mouse, 1, entity)
					end
				elseif self.keyDebounce[mouse] then
					self.keyDebounce[mouse] =  false
					GameInstance:emit("inputDownStop", 2, mouse, 1, entity)
				end
			end
			if doubleClickTimer > 0 and doubleClickFocus then
				if self.mouseInputs[doubleClickFocus] and not doubleClickDebounce then
					--print("Double clicked mouse "..doubleClickFocus)
					doubleClickDebounce = true
					for mouse, isPressed in pairs(self.mouseInputs) do
						if isPressed then
							GameInstance:emit("inputDownStart", 2, mouse, 2, entity)
						end
					end
					doubleClickFocus = nil
				end
				doubleClickTimer = doubleClickTimer-1
			else
				doubleClickTimer = 0
				doubleClickFocus = nil
			end

		end
	end
	function InputSystem:update(dt)
		if #self.withPlayer.objects > 0 then
			for _, entity in pairs(self.withPlayer.objects) do
				self:inputs(1, entity)
				self:inputs(2, entity)
			end
		else
			self:inputs(1)
			self:inputs(2)
		end
	end
	function InputSystem:draw()
		for k, v in pairs(self.withJump.objects) do
			local jump = v:get(Jump)
		end
	end
	function InputSystem:entityAdded(entity)
		--local jump = entity:get(Jump)
	end
GameInstance:addSystem(inputsystem, "mousepressed", "mousepressed", true)
GameInstance:addSystem(inputsystem, "mousereleased", "mousereleased", true)
GameInstance:addSystem(inputsystem, "keypressed", "keypressed", true)
GameInstance:addSystem(inputsystem, "keyreleased", "keyreleased", true)
GameInstance:addSystem(inputsystem, "update", "update", true)
--GameInstance:addSystem(inputsystem, "draw", "draw", true)