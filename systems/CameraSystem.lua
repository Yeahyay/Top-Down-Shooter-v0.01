CameraSystem = System({CameraComponent, "cameraPool"})
	CameraSystem.currentCamera = {}
	CameraSystem.currentCamera.Position = Vector2.new()
	CameraSystem.currentTransform = love.math.newTransform()
	CameraSystem.currentTransform:reset()
	--CameraSystem.target = nil
	cameraSystem = CameraSystem()
	function CameraSystem:update(dt)
		for k, v in pairs(self.cameraPool.objects) do
			local camera = v:get(CameraComponent)
			self.currentTransform:reset()
			local targetPos
			if camera.Target then
				targetPos = camera.Target:get(Body).Position+mousePos*0.5
			elseif not targetPos then
				targetPos = Vector2.new()
			end
			local delta = (targetPos-camera.Position)
			camera.Position = camera.Position+camera.PositionDamp*delta*dt*60
			camera.Zoom = camera.Zoom+camera.ZoomDamp*(camera.ZoomTarget-camera.Zoom)*dt*60
			mousePosWorld = mousePos+camera.Position
			self.currentCamera = camera
			
			self.currentTransform:translate((screenSize/2):split())
			self.currentTransform:scale(camera.Zoom, -camera.Zoom)
			self.currentTransform:translate((-camera.Position):split())
		end
	end
	function CameraSystem:cameraSetZoomTarget(zoom)
		camera.currentCamera.ZoomTarget = zoom
	end
	function CameraSystem:cameraSetZoomDamp(damp)
		camera.currentCamera.ZoomDamp = damp
	end
	function CameraSystem:cameraSetTarget(target)
		camera.currentCamera.Target = target
	end
	function CameraSystem:cameraSetPositionDamp(damp)
		camera.currentCamera.PositionDamp = damp
	end
	function CameraSystem:respawned(player)
		self.currentCamera.Target = player
	end
	function CameraSystem:died(player)
		if self.currentCamera.Target == player then
			self.currentCamera.Target = nil
		end
	end
	function CameraSystem:draw()
		for k, v in pairs(self.cameraPool.objects) do
			local camera = v:get(CameraComponent)
			--local body = v:get(Body)
			--love.graphics.translate((-body.Position):split())
			--[[love.graphics.translate(screenSize.x/2, screenSize.y/2)
			love.graphics.scale(camera.Zoom, -camera.Zoom)
			love.graphics.translate((-camera.Position):split())]]
			love.graphics.applyTransform(self.currentTransform)
			return self.currentCamera
		end
	end
	function CameraSystem:queueDraw(...)

	end
	function CameraSystem:entityAdded(entity)
		local camera = entity:get(CameraComponent)
		self.target = camera.Target
	end
GameInstance:addSystem(cameraSystem, "playerSpawned", "respawned", true)
GameInstance:addSystem(cameraSystem, "playerDied", "died", true)
GameInstance:addSystem(cameraSystem, "postUpdate", "update", true)
GameInstance:addSystem(cameraSystem, "cameraTranslate", "draw", true)
GameInstance:addSystem(cameraSystem, "cameraSetZoomTarget", "cameraSetZoomTarget", true)
GameInstance:addSystem(cameraSystem, "cameraSetZoomDamp", "cameraSetZoomDamp", true)
GameInstance:addSystem(cameraSystem, "cameraSetTarget", "cameraSetTarget", true)
GameInstance:addSystem(cameraSystem, "cameraSetPositionDamp", "cameraSetPositionDamp", true)