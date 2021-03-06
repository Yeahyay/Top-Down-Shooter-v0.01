game = {}
game.name = "game"
game.savedgame = nil
game.loaded = false
game.speed = 1
game.effectAmount = 1--{h=1,v=1}
game.physicsSpeed = 1
game.canvases = {}
game.canvases["final"] = love.graphics.newCanvas(width, height)
game.canvases["pre"] = love.graphics.newCanvas(width, height)
game.canvases["red"] = love.graphics.newCanvas(width, height)
game.canvases["green"] = love.graphics.newCanvas(width, height)
game.canvases["blue"] = love.graphics.newCanvas(width, height)
game.bg = {}
game.fg = {}
game.debugLevel = 1
foo = "bar"

Luven.init(screenSize.x, screenSize.y, false)
Luven.setAmbientLightColor{0.1, 0.1, 0.1}
--Luven.setAmbientLightColor{0.05, 0.05, 0.05}
--light1 = Luven.addNormalLight(0, 0, {1,1,1}, 0)

joysticks = {}
function game:joystickadded(joystick)
	joysticks[#joysticks+1] = joystick
	print(joystick)
	print(joystick:getName())
	print("Ass")
end
print("dick")
function game:crash()
	Game = {}
end
for i=1, 1000 do
	local z = math.random2(0, 10)
	if z >= 1 then
		game.bg[i] = Vector3.new(math.random2(-screenSize.x*5, screenSize.x*5), math.random2(-screenSize.y*5, screenSize.y*5), z)
	else
	--	game.fg[i] = Vector3.new(math.random2(-4000, 4000), math.random2(-1000, 4000), z)
	end
end
function game:tweenSpeedFrom(speed, time)
	if speed < self.speed then
		self.speed = speed
	end
	flux.to(self, time, {speed=1}):ease("linear")
	--]]
end
function game:tweenEffectAmountFrom(amount, time)
	self.effectAmount = amount
	flux.to(self, time, {effectAmount=1}):ease("linear")
	--]]
end
function game:keyPressed(key)
	GameInstance:emit("keypressed", key)
end
function game:keyreleased(key)
	GameInstance:emit("keyreleased", key)
end
function game:mousepressed(mouseX, mouseY, button)
	GameInstance:emit("mousepressed", mouseX, mouseY, button)
	--print(mouseX, mouseY, button)
end
function game:mousereleased(mouseX, mouseY, button)
	GameInstance:emit("mousereleased", mouseX, mouseY, button)
	--print(mouseX, mouseY, button)
end
function game:mousemoved(mouseX, mouseY, mouseDX, mouseDY)
		mousePosRaw.x, mousePosRaw.y = mouseX, screenSize.y-mouseY
		mousePosDelta = mouseDX, screenSize.y-mouseDY
		--mousePosRawOld = mousePosRaw
		--mousePosRawUnit = mousePosRaw/screenSize
		mousePos = mousePosRaw-screenSize/2
end
function game:update(dt)
	if self.loaded then
		local dt = dt*self.speed
		timer = timer+dt
		--[[mousePosRaw = Vector2.new(love.mouse.getX(), screenSize.y-love.mouse.getY())
		mousePosDelta = mousePosRaw-mousePosRawOld
		mousePosRawOld = mousePosRaw
		--mousePosRawUnit = mousePosRaw/screenSize
		mousePos = mousePosRaw-screenSize/2
		--mousePosUnit = mousePos/screenSize*2]]
		--GameInstance:emit("preUpdate", dt)
		--print(tick.tick%2)
		local rate = 60+math.clamp(420-tick.tick/60, 0)
		if tick.tick%math.ceil(rate) == 0 then
			local enemy = Entity("Enemy")
				:give(Body, {"BSGRectangle", 20}, Vector2.new(math.random2(-1000, 1000), math.random2(-1000, 1000)), 0, Vector2.new(64, 64), 20)
				:give(Animator, enemyImage, Vector2.new(2, 2), Vector2.new(32, 32), {"1-3", "1-3", 1, 4}, 1/60)
				:give(Enemy)
				:give(Health, 100, 100, 10, 1)
				--:give(Stomp, 0.05, 5, 20)
				:give(Ability, false, {Stomp, Dash})
				--:give(Mobile)
				:give(Movement, Vector2.new(100, 100), Vector2.new(50, 50))
				:give(Drawable)
				:give(Upright, 250000)
				:apply()
				enemy:get(Body).Collider:setFixedRotation(true)
				enemy:get(Body).Collider:setCollisionClass("Enemy")
				enemy:get(Body).Collider:setMass(5)
				enemy:get(Body).Collider:setFriction(0.7)
				enemy:get(Body).Collider:setRestitution(0.3)
				enemy:get(Body).Collider:setAngularDamping(0.5)
			GameInstance:addEntity(enemy)
		end
		flux.update(dt)
		local iter = 1
		for i=1, iter do
			GameWorld:update(1/iter*dt*self.physicsSpeed)
		end
		--Luven.update(dt)
		
		--print(timer, self.speed)
		--end
		--mouseLight:SetPosition(mousePos:split())
		GameInstance:emit("physicsupdate", dt*self.physicsSpeed)
		GameInstance:emit("update", dt)
		GameInstance:emit("postUpdate", dt)
		--Luven.sendCustomViewMatrix{cameraSystem.currentTransform:getMatrix()}
		--LightWorld:Update(dt)
	end
end

function game:save()
	self.savedgame = Serialize(Game)
	print(self.savedgame)
end

local maxStretchH = 1.015
local maxStretchV = 1.015
local padding = 0
local size = 5
local function drawStar(camera, position)
	love.graphics.push()

	local speed = math.sin2(timer*2)*0+0*timer

	local x, y, z = position:split()
	local cx, cy = camera.Position:split()
	local z = (z-camera.Zoom-speed)%(10)
	--local poop = screenSize.x/2
	--local poop2 = poop
	local mx, my = mousePos:split()
	--local ox, oy = 100, 100
	--local x = ((-cx+x+mx)/z)
	--local y = ((cy-y)/z-my/z-my)%oy-oy/2
	local ox, oy = (screenSize*5):split()
	local x, y = ((-cx-x)%ox-ox/2)/z, ((cy-y)%oy-oy/2)/z
	--if x < screenSize.x/2-padding and x > -screenSize.x/2+padding 
	--	and y < screenSize.y/2-padding and y > -screenSize.y/2+padding then
		love.graphics.translate(x, y)
		--if z then
			love.graphics.rectangle("fill", -size/2/z, -size/2/z, size/z, size/z)
		--end
	--end
	
	love.graphics.pop()
end
function game:chromaticAbberation()
	local stretchH = 1+((maxStretchH-1)*(1-game.effectAmount)^0.75*1)
	local stretchV = 1+((maxStretchH-1)*(1-game.effectAmount)^0.25*1)
	--local stretchV = 1+((1-maxStretchV)*(1-game.effectAmount)^0.25*10)

		love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setCanvas(game.canvases["red"])
		love.graphics.clear()
		love.graphics.draw(game.canvases["pre"], 0, 0, 0, 1, 1)

	love.graphics.setCanvas(game.canvases["green"])
		love.graphics.clear()
		love.graphics.draw(game.canvases["pre"], 0, 0, 0, 1, 1)

	love.graphics.setCanvas(game.canvases["blue"])
		love.graphics.clear()
		love.graphics.draw(game.canvases["pre"], 0, 0, 0, 1, 1)

	love.graphics.setCanvas(game.canvases["final"])
		--love.graphics.setBlendMode("screen", "alphamultiply")
		love.graphics.setBlendMode("add", "premultiplied")
		love.graphics.clear()
		--love.graphics.setBackgroundColor(0.5, 0.5, 0.5, 1)
		
		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.draw(game.canvases["red"], screenSize.x/2-stretchH*screenSize.x/2, screenSize.y/2-stretchV*screenSize.y/2, 0, stretchH, stretchV)
		--love.graphics.draw(game.canvases["red"], 0, screenSize.y/2-stretchV*screenSize.y/2, 0, 1, stretchV)
		
		love.graphics.setColor(0, 1, 0, 1)
		love.graphics.draw(game.canvases["green"], 0, 0, 0, 1, 1)
		
		love.graphics.setColor(0, 0, 1, 1)
		love.graphics.draw(game.canvases["blue"], 0, 0, 0, 1, 1)

		love.graphics.setCanvas()
		--love.graphics.setBlendMode("alpha", "alphamultiply")
		love.graphics.clear()
end
function game:draw()
	local delta = love.timer.getAverageDelta()
	local frameTime = love.timer.getDelta()
	local stats = love.graphics.getStats()
	
	--local draw_ = function()
	love.graphics.setCanvas(game.canvases["pre"])
		love.graphics.setBlendMode("alpha")

		--Luven.drawBegin()
		
		love.graphics.clear()
		love.graphics.setColor(0.1, 0.3, 0.05)
		love.graphics.rectangle("fill", 0, 0, screenSize.x, screenSize.y)

		--love.graphics.setColor(0, 0, 0)
		--love.graphics.rectangle("fill", 0, 0, screenSize.x, screenSize.y)

		love.graphics.push()
			love.graphics.setColor(1, 1, 1, 1)

			--love.graphics.rectangle("fill", -5, -5, 10, 10)
			--game.effectAmount.h, game.effectAmount.v = stretchH, stretchV
			--love.graphics.scale(stretchH, -stretchV)

			--love.graphics.scale(1, -1)
			local camera = GameInstance:emit("cameraTranslate", frameTime)
			--[[love.graphics.push()
			love.graphics.origin()
			love.graphics.translate(screenSize.x/2, screenSize.y/2)
			for k, v in pairs(game.bg) do
				drawStar(camera, v)
			end
			love.graphics.pop()[[]]
			
			--[[love.graphics.push()
			love.graphics.origin()
			local draw = function()
				GameInstance:emit("cameraTranslate", frameTime)
				love.graphics.rectangle("fill", -1000, -400, 2000, 200)
				GameInstance:emit("draw", frameTime)
			end
			drawLights(draw, 0, 0)
			--draw()
			updateRelativeToCamera(camera.Position)
			love.graphics.pop()]]

			GameInstance:emit("preDraw", frameTime)
			love.graphics.rectangle("fill", -1000, -400, 2000, 200)
			GameInstance:emit("draw", frameTime)
			
			-- In Game UI
			love.graphics.push()
				love.graphics.origin()
				--LightWorld:Draw()
				
				GameInstance:emit("cameraTranslate", frameTime)
				GameInstance:emit("drawUI", frameTime)
			love.graphics.pop()

			--Luven.drawEnd()
			
			-- Post Debugs
			love.graphics.setLineWidth(1)
			love.graphics.setColor(1, 1, 1, 1)
			if game.debugLevel > 2 then
				GameWorld:draw()
			end

		love.graphics.pop()


		GameInstance:emit("postDraw", frameTime)
		--ShadowWorld:Draw()

		self:chromaticAbberation()

	--love.graphics.setColor(0.5, 0, 0, 1)
	--love.graphics.rectangle("fill", 0, 0, screenSize.x, screenSize.y)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(game.canvases["final"], 0, 0, 0, 1, 1)
	love.graphics.setBlendMode("alpha", "alphamultiply")
	--end

	--draw_()

	--light.x, light.y = -camera.currentCamera.Position.x, camera.currentCamera.Position.y

	--	love.graphics.draw(game.canvases["final"], 0, 0, 0, 1, 1)
		--love.graphics.rectangle("fill", 50, 50, 50, 50)
	--end
	--draw()

	if game.debugLevel > 0 then
		love.graphics.print(stats.drawcalls, 0, 0, 0, 0.25)
		love.graphics.print(FPS, 0, 25, 0, 0.25)
		love.graphics.print(string.format("Frame time: %.3f ms", 1000 * frameTime), 0, 75, 0, 0.25, 0.25)
		love.graphics.print("Memory usage: "..collectgarbage("count")/1024, 0, 100, 0, 0.25)
		love.graphics.print(string.format("Average frame time: %.3f ms", 1000 * delta), 0, 50, 0, 0.25, 0.25)
	end
end
function game:load(arg)
	--if arg[#arg] == "-debug" then require("mobdebug").start() end
end
function game:preLoad()
end
function game:enter()
	local entities = {}
	playerImage = love.graphics.newImage("sprites/walking1.png")
	enemyImage = love.graphics.newImage("sprites/enemy 1 walking 1.png")
	for i=1, 400 do
		entities[i] = Entity("Test entity "..i)
		:give(Body, {"Rectangle"}, Vector2.new(math.random2(-1000, 1000), math.random2(-1000, 1000)), 0, Vector2.new(32, 32), 10)
		:give(Animator, testImage, Vector2.new(1, 1), Vector2.new(32, 32), {1, 1}, 0)
		:give(Health, 50, 50, 0)
		:give(Drawable)
		--:give(Light, {1, 0.6, 0.3}, 10)
		:apply()
		GameInstance:addEntity(entities[i])
		entities[i]:get(Body).Collider:setCollisionClass("World")
		entities[i]:get(Body).Collider:setMass(1)
	end
	for i=1, 10 do
		local item = Entity("Pistol"..i)
			:give(Body, {"Rectangle"}, Vector2.new(math.random2(-1000, 1000), math.random2(-1000, 1000)), math.random(0, 2*math.pi), Vector2.new(5, 15), 1)
			:give(Drawable)
			:give(Item, "Pistol "..i)
			:give(Activatable)
			:give(Ranged, "Pistol", "semi", 0)
			:give(Ammo, 7*5, nil, 7, nil)
			:give(Light, {1, 0.6, 0.3}, 0, true, 5)
			:apply()
			--item:get(Body).Collider:setFixedRotation(true)
			item:get(Body).Collider:setCollisionClass("Item")
		GameInstance:addEntity(item)
	end
	for i=1, 20 do
		local item = Entity("SMG"..i)
			:give(Body, {"Rectangle"}, Vector2.new(math.random2(-1000, 1000), math.random2(-1000, 1000)), math.random(0, 2*math.pi), Vector2.new(5, 25), 1)
			:give(Drawable)
			:give(Item, "SMG "..i)
			:give(Activatable)
			:give(Ranged, "SMG", "auto", 0.025)
			:give(Ammo, 30*5, nil, 30, nil)
			:give(Light, {1, 0.6, 0.3}, 0, true, 5)
			:apply()
			--item:get(Body).Collider:setFixedRotation(true)
			item:get(Body).Collider:setCollisionClass("Item")
		GameInstance:addEntity(item)
	end
	for i=1, 10 do
		local item = Entity("Shotgun"..i)
			:give(Body, {"Rectangle"}, Vector2.new(math.random2(-1000, 1000), math.random2(-1000, 1000)), math.random(0, 2*math.pi), Vector2.new(8, 35), 1)
			:give(Drawable)
			:give(Item, "Shotgun "..i)
			:give(Activatable)
			:give(Ranged, "Shotgun", "delayed", 0.5)
			:give(Ammo, 7*5, nil, 7, nil)
			:give(Light, {1, 0.6, 0.3}, 0, true, 5)
			:apply()
			--item:get(Body).Collider:setFixedRotation(true)
			item:get(Body).Collider:setCollisionClass("Item")
		GameInstance:addEntity(item)
	end
	for i=1, 10 do
		local item = Entity("Sniper"..i)
			:give(Body, {"Rectangle"}, Vector2.new(math.random2(-1000, 1000), math.random2(-1000, 1000)), math.random(0, 2*math.pi), Vector2.new(8, 65), 1)
			:give(Drawable)
			:give(Item, "Sniper "..i)
			:give(Activatable)
			:give(Ranged, "Sniper", "delayed", 1)
			:give(Ammo, 8*5, nil, 8, nil)
			:give(Light, {0.8, 0.6, 0.2}, 0, true, 5)
			:apply()
			--item:get(Body).Collider:setFixedRotation(true)
			item:get(Body).Collider:setCollisionClass("Item")
		GameInstance:addEntity(item)
	end
	--playersystem:respawn(1)
	local camera = Entity("Camera")
		:give(CameraComponent, player, 1)
		:apply()
		GameInstance:addEntity(camera)
end
function game:leave()

end
function game:resume(next)
	--print("game", "resumed from screen "..tostring(next.name))
end
function game:pause(next)
	--print("game", "paused to screen "..tostring(next.name))
end
function game:keypressed(key)
	if key == "escape" then
		stateManager:push(pause)
		stateManager:apply()
	end
end

local font = fonts.current
pause = {}
pause.name = "pause"
function pause:keypressed(key)
	if key == "escape" then
		stateManager:pop("game")
		stateManager:apply()
	end
end
function pause:draw(previous, dt)
	self.previous:draw()
	local size = 1--(math.sin2(timer*5)/2+0.5)
	local text = "PAUSED"
	local width, height = font:getWidth(text)*size, font:getHeight()*size
	love.graphics.printf(text, screenSize.x/2*(1-size), screenSize.y/2-height/2, screenSize.x, "center", 0, size, size)
	--love.graphics.rectangle("line", screenSize.x/2-width/2, screenSize.y/2-height/2, width, height)
	--love.graphics.rectangle("line", screenSize.x/2-10, screenSize.y/2-10, 20, 20)
end
function pause:enter(previous)
	pause.previous = previous
	--print("pause", "paused from screen "..tostring(previous.name))
end
function pause:leave(next)
	--print("pause", "resumed to screen "..tostring(next.name))
end