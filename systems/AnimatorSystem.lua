local AnimatorSystem = System({Animator, Drawable, "animatorPool"})
	animator = AnimatorSystem()
	function AnimatorSystem:update(dt)
		for k, v in pairs(self.animatorPool.objects) do
			local animator = v:get(Animator)
			if not animator.static then
				animator.animation:update(animator.timeScale*dt)
			end
		end
	end
	function AnimatorSystem:draw()
		for k, v in pairs(self.animatorPool.objects) do
			local animator = v:get(Animator)
			local body = v:get(Body)
			local position = body.Position
			local offX = animator.offset.x--*math.cos(body.Angle)
			local offY = animator.offset.y--*math.sin(body.Angle)
			love.graphics.push()
			love.graphics.translate(position:split())
			love.graphics.rotate(body.Angle)
			love.graphics.translate(animator.cellSize.x/-2, animator.cellSize.y/-2)
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
	function AnimatorSystem:entityAdded(entity)
		local animator = entity:get(Animator)
		if not animator.static then
			animator.animation:flipV()
		end
	end
GameInstance:addSystem(animator, "update", "update", true)
GameInstance:addSystem(animator, "draw", "draw", true)