CameraSystem = System({CameraComponent, "cameraPool"})
	CameraSystem.currentCamera = {}
	--CameraSystem.target = nil
	camera = CameraSystem()
	function CameraSystem:update(dt)
		for k, v in pairs(self.cameraPool.objects) do
			local camera = v:get(CameraComponent)
			self.currentCamera = camera
			local targetPos
			if camera.Target then
				targetPos = camera.Target:get(Body).Position+mousePos*0.5--+camera.Target:get(Body).Velocity*0.1--+Vector2.new(0, 100)
			else
				targetPos = Vector2.new()
			end
			local delta = (targetPos-camera.Position)
			camera.Position = camera.Position+camera.PositionDamp*delta*dt*60
			camera.Zoom = camera.Zoom+camera.ZoomDamp*(camera.ZoomTarget-camera.Zoom)*dt*60
			mousePosWorld = mousePos+camera.Position
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
			love.graphics.scale(camera.Zoom)
			love.graphics.translate((-camera.Position):split())
		end
	end
	function CameraSystem:queueDraw(...)

	end
	function CameraSystem:entityAdded(entity)
		local camera = entity:get(CameraComponent)
		self.target = camera.Target
	end
GameInstance:addSystem(camera, "playerSpawned", "respawned", true)
GameInstance:addSystem(camera, "playerDied", "died", true)
GameInstance:addSystem(camera, "postUpdate", "update", true)
GameInstance:addSystem(camera, "preDraw", "draw", true)
GameInstance:addSystem(camera, "cameraSetZoomTarget", "cameraSetZoomTarget", true)
GameInstance:addSystem(camera, "cameraSetZoomDamp", "cameraSetZoomDamp", true)
GameInstance:addSystem(camera, "cameraSetTarget", "cameraSetTarget", true)
GameInstance:addSystem(camera, "cameraSetPositionDamp", "cameraSetPositionDamp", true)