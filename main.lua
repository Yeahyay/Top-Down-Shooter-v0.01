io.stdout:setvbuf("no")
function luaInfo()
	local info = "Lua version: " .. _VERSION .. "\n"
	info = info .. "LuaJIT version: "

	if (jit) then
		info = info .. jit.version
	else
		info = info .. "this is not LuaJIT"
	end

	return info
end

print(luaInfo())
print(love.getVersion())

--[[resources = {}
Game = {}
Game.love = love
Game.print = print
Game.pairs = pairs
Game.require = require
Game.getfenv = getfenv]]
--setfenv(1, Game)

Game = {}
setmetatable(Game, {__index = _G})
setfenv(0, Game)
setfenv(1, Game)

--Utility functions
	function requireDirectory(directory)
		local dir = love.filesystem.getDirectoryItems(directory)
		for k, v in pairs(dir) do
			local string = directory.."/"..v
			if v:find(".lua") then
				string = string:gsub(".lua", "")
				require(string)
			end
		end
	end

--INIT REQUIRES
	global = require("globalFunctions")
	flux = require("lib/flux-master/flux")
	Vector2 = require("lib/brinevector2D/brinevector")
	Vector3 = require("lib/brinevector3D/brinevector3D")
	tick = require("lib/tick-master/tick")
	roomy = require("lib/roomy-master/roomy")
	anim8 = require("lib/anim8-master/anim8")
	uuid = require("lib/uuid-master/src/uuid")
	wf = require("lib/windfield-master/windfield")
	class = require("lib/30log-master/30log-clean")
	bump = require("lib/bump-master/bump")
	--require("lib/autobatch-master/autobatch")
	slam = require("lib/slam-master/slam")
	Luven = require("lib/Luven-master/luven")

	simpleLights = require("lib/simple-love-lights-master/lights")
	--lightworld = require("lib/light_world/lib")
	--[[Shadows = require("shadows")
	LightWorld	=	require("shadows.LightWorld")
	Light			=	require("shadows.Light")
	NormalShadow	=	require("shadows.ShadowShapes.NormalShadow")
	HeightShadow	=	require("shadows.ShadowShapes.HeightShadow")
	Star			=	require("shadows.Star")
	BodyShadow	=	require("shadows.Body")
	PolygonShadow	=	require("shadows.ShadowShapes.PolygonShadow")
	CircleShadow	=	require("shadows.ShadowShapes.CircleShadow")
	ImageShadow	=	require("shadows.ShadowShapes.ImageShadow")]]
	--Shadows = require("lib/shadows").init
	--shadows = require("lib/shadows/init")
	--Light = require("shadows.Light")
	--Body = require("shadows.Body")
	--PolygonShadow = require("shadows.ShadowShapes.PolygonShadow")
	--CircleShadow = require("shadows.ShadowShapes.CircleShadow")
	--print(Shadows)
	--lightworld = require("lib.shadows.LightWorld")

	Concord = require("lib/Concord-master/lib")
		Concord.init({
			useEvents = false
		})
	Component = Concord.component
	Entity = Concord.entity
	Instance = Concord.instance
	System = Concord.system
	Serialize = require("lib/knife-master/knife/serialize")

--INIT EXTERNAL RESOURCES
	fonts = {}
	fonts.default = love.graphics.setNewFont(100)
	local dir = love.filesystem.getDirectoryItems("fonts")
	for k, v in pairs(dir) do
		local string = "fonts/"..v
		if not v:find(".zip") then --ignore zip files
			stringRaw = v:gsub(".ttf", "")
			stringRaw = stringRaw:gsub("-", "")
			fonts[stringRaw] = love.graphics.newFont(string, 100)
		end
	end
	fonts.current = fonts.default

	sounds = {}
	local dir = love.filesystem.getDirectoryItems("sound")
	for k, v in pairs(dir) do
		local string = "sound/"..v
		local stringmodified = string:gsub("sound/", "")
		local stringmodified = stringmodified:gsub(".mp3", "")
		local stringmodified = stringmodified:gsub(".wav", "")
		sounds[stringmodified] = love.audio.newSource(string, "stream")
	end

--[[Game = getfenv(1)
for k, v in pairs(resources) do
	Game[k] = v
end
resources = nil]]
	--require("libs")
	--[[for k, v in pairs(getfenv(1)) do
		print(k, v)
	end]]

--INIT VARIABLES
	tick.framerate = -1
	tick.rate = 1/60

	FPS = 0
	AVGFPS = 0
	screenHeight = 720
	screenWidth = screenHeight*(16/9)
	screenSize = Vector2.new(screenWidth, screenHeight)
	timer = 0
	mousePos = Vector2.new()
	mousePosRaw = Vector2.new(s)
	mousePosRawOld = Vector2.new()
	mousePosRawDelta = Vector2.new()
	mousePosUnit = Vector2.new()
	mousePosRawWorld = Vector2.new()

--INIT LOVE2D SETINGS
	--love.mouse.setVisible(false)
	--love.mouse.setCursor()
	--love.audio.setDistanceModel("linear")
	love.graphics.setLineStyle("rough")
	love.graphics.setDefaultFilter("linear", "nearest", 0)
	love.window.setMode(screenWidth, screenHeight, {fullscreen=false,vsync=false,resizable=false, minwidth=32, minheight=18})
	love.audio.setVolume(1)
	love.graphics.setFont(fonts.SourceSansProRegular)
	love.math.setRandomSeed(1)--love.timer.getTime())
	love.audio.setVolume(0.8)
	love.audio.setEffect("reverb", {type="reverb",
		gain = 0.6,
		highgain = 1,
		density = 0.6,
		decayhighratio = 1.1,
		diffusion = 0.6,
		decaytime = 1.5,
	})

--INIT GAMEPAD

GameInstance = Instance()
--[[LightWorld = lightworld{
	ambient = {0.1, 0.1, 0.1, 1}
}]]
GameWorld = wf.newWorld(0, 0, true)
	love.physics.setMeter(64)
--GameWorld = bump.newWorld(50)

light = addLight(screenSize.x/2, screenSize.y/2, 2000, 1, 1, 1)
light = addLight(screenSize.x, screenSize.y, 2000, 1, 1, 1)

testImage = love.graphics.newImage("sprites/Test Texture 1.png")

requireDirectory("components")
requireDirectory("components/abilities")
requireDirectory("components/enemies")
requireDirectory("components/items")
requireDirectory("systems")

--GameWorld:setGravity(0, -980.665)
GameWorld:addCollisionClass("Player", {enter = {"World", "Player"}})
GameWorld:addCollisionClass("Enemy", {enter = {"World", "Player"}})
GameWorld:addCollisionClass("Item", {ignores = {"Player", "Enemy"}})
GameWorld:addCollisionClass("Bullet", {ignores = {"Bullet"}})
GameWorld:addCollisionClass("Particle", {ignores = {"Particle", "Player", "Enemy"}})
GameWorld:addCollisionClass("NPC", {ignores = {"Player"}})
GameWorld:addCollisionClass("World")
GameWorld:addCollisionClass("Null", {ignores = {"Player", "NPC", "World"}})

--ground = {name = "ground", uuid = uuid()}
ground = Entity("ground")
	:give(Body, {"Rectangle"}, Vector2.new(0, -300), 0, Vector2.new(2000, 200), 1)
	:give(Material, "metal")
	:apply()
GameInstance:addEntity(ground)
--ground.Collider = GameWorld:newRectangleCollider(-1000, -400, 2000, 200)
ground:get(Body).Collider:setType("static")
ground:get(Body).Collider:setCollisionClass("World")
--ground.Collider:setObject(ground)

--setfenv(1, _G)

stateManager = roomy.new()
function love.update(dt)
	FPS = 1/tick.dt
end

function love.keypressed(key, scancode, isrepeat)
	stateManager:emit("keyPressed", key, scancode, isrepeat)
	if key == "o" then game:save() end
end

graphics = {}
graphics.print = function(...)
	love.graphics.print(...)
end

requireDirectory("states")

stateManager:hook{callbacks = {"load", "update", "draw", "quit", "keypressed", "keyreleased", "mousepressed", "mousereleased", "mousemoved"}, applyBefore = {"draw"}}

--game.preLoad()

stateManager:switch(game)
stateManager:apply()

game.loaded = true

--print(getfenv(0), getfenv(1), _G)
setfenv(0, _G)
setfenv(1, _G)
--print(getfenv(0), getfenv(1), _G)s