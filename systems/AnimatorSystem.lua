local AnimatorSystem = System({Animator, Drawable, "animatorPool"}, {Animator, Drawable, "onScreen"})
	animator = AnimatorSystem()
	animator.onScreen = {}
	local sqrt = math.sqrt
	local cullX, cullY = (screenSize/2):split()
	local radius, falloffRadius = 100, 200
	--radius, falloffRadius = radius*radius, falloffRadius*falloffRadius
	function AnimatorSystem:update(dt)
		--self.onScreen = {}
		local playerPos = playerSystem.Players[1] and playerSystem.Players[1]:get(Body).Position or Vector2.new()
		local playerPosX, playerPosY = playerPos:split()

		local camX, camY = cameraSystem.currentCamera.Position:split()
		for k, entity in pairs(self.animatorPool.objects) do
			local body = entity:get(Body)
			local position = body.Position
			local drawable = entity:get(Drawable)

			local posX, posY = body.Position:split()
			local relativePosX, relativePosY = camX-posX, camY-posY
			if relativePosX > -cullX and relativePosX < cullX and relativePosY > -cullY and relativePosY < cullY then
				local animator = entity:get(Animator)

				if not animator.static then
					animator.animation:update(animator.timeScale*dt)
				end

				--[[local distance = math.pow(playerPosX-posX, 2)+math.pow(playerPosY-posY, 2)--(body.Position-playerPos).length2

				--if distance < falloffRadius+radius then
					--print(playerSystem.Players[1])
					radius, falloffRadius = radius, falloffRadius
					local brightness = ((radius+falloffRadius)/falloffRadius)-sqrt(distance)/falloffRadius
					animator.Brightness = brightness
				--else
				--	animator.Brightness = 0
				--end
				--self.onS]]
				if not drawable.OnScreen then
					drawable.OnScreen = true
				end
				--print(#self.onScreen)
			else
				if drawable.OnScreen then
					drawable.OnScreen = false
				end
			end
		end
	end
	function AnimatorSystem:draw()
		--dRadius, dFalloffRadius = sqrt(radius), sqrt(falloffRadius)
		--local playerPos = playerSystem.Players[1] and playerSystem.Players[1]:get(Body).Position or Vector2.new()
		--local playerPosX, playerPosY = playerPos:split()
		--print(#self.onScreen)
		for k, entity in pairs(self.animatorPool.objects) do
			local onScreen = entity:get(Drawable).OnScreen
			if onScreen then
				local body = entity:get(Body)
				local position = body.Position
				local posX, posY = body.Position:split()
				local animator = entity:get(Animator)
				local offX = animator.offset.x--*math.cos(body.Angle)
				local offY = animator.offset.y--*math.sin(body.Angle)
				love.graphics.push()
				love.graphics.translate(position:split())
				love.graphics.rotate(body.Angle)
				love.graphics.translate(animator.cellSize.x/-2, animator.cellSize.y/-2)

				--[[local distance = math.pow(playerPosX-posX, 2)+math.pow(playerPosY-posY, 2)--(body.Position-playerPos).length2

				if distance < falloffRadius*falloffRadius+radius*radius then
					--print(playerSystem.Players[1])
					if game.debugLevel > 1 then
						love.graphics.setColor(1, 1, 1)
						love.graphics.circle("line", -offX, -offY, radius)
						love.graphics.circle("line", -offX, -offY, radius+falloffRadius)
					end
					radius, falloffRadius = radius*radius, falloffRadius*falloffRadius
					local brightness = ((radius+falloffRadius)/falloffRadius)-distance/falloffRadius
					love.graphics.setColor(1*brightness, 1*brightness, 1*brightness)
				else
					love.graphics.setColor(0, 0, 0)
				end]]
				--love.graphics.rectangle("fill", 0, 0, 200, 200)
				if game.debugLevel > 1 then
					love.graphics.setColor(1, 1, 1)
					love.graphics.circle("line", -offX, -offY, radius)
					love.graphics.circle("line", -offX, -offY, radius+falloffRadius)
				end
				
				love.graphics.setColor(1, 1, 1)

				--love.graphics.setColor(animator.Brightness, animator.Brightness, animator.Brightness)

				if animator.static then
					love.graphics.draw(animator.image, animator.grid(1,1)[1], 0, 0, 0, animator.size.x, animator.size.y)
				else
					--animator.animation:draw(animator.image, position.x+offX, position.y+offY, body.Angle, animator.size.x, animator.size.y)
					--love.graphics.rectangle("line", 0, 0, animator.cellSize.x, animator.cellSize.y)
					animator.animation:draw(animator.image, 0, 0, 0, animator.size.x, animator.size.y)
				end
				love.graphics.pop()
			end
		end
	end
	function AnimatorSystem:entityAdded(entity)
		local animator = entity:get(Animator)
		if not animator.static then
			animator.animation:flipV()
		end
	end
GameInstance:addSystem(animator, "update", "update", true)
GameInstance:addSystem(animator, "draw", "draw", true)