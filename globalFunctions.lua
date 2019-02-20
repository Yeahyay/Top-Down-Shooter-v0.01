io.stdout:setvbuf("no")
--[[Vector2 = require("lib/brinevector2D/brinevector")
Vector3 = require("lib/brinevector3D/brinevector3D")
--Matrix = require("lib/lua-matrix-master/lua/matrix")
class = require("lib/30log-clean")]]

function math.round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function math.random2(a, b, c)
	local ans
	if b then
		a = a or 1
		b = b or 1
		ans = a+((b-a)*((love.math.random()*1)-0))
	else
		a = a or 1
		ans = a*((love.math.random()*2)-1)
	end
	return ans
end

--[[local r = 2
local lower, upper = 10, 10
local rMin, rMax = math.huge, -math.huge
for i=1, 2000 do
	r = math.random2(lower, upper)
	if r < rMin then rMin = r end
	if r > rMax then rMax = r end
	print(r)
	if r < lower or r > upper then
		print("nop")
		break
	end
end
print(rMin, rMax)]]

function math.sin2(a)
	return (math.sin(a)+1)/2
end

function math.powerOfTwo(a)
	--return (a ~= 0) and ((a & (a-1))==0)
end

function math.clamp(x, min, max)
	if (x < min) then
		x = min
	elseif (x > max) then
		x = max
	end
	return x
end

function string.firstToUpper(str)
	return (str:gsub("^%l", string.upper))
end

function deepCopy(object)
	local lookup_table = {}
	local function _copy(object)
		if type(object) ~= "table" then
			return object
		elseif lookup_table[object] then
			return lookup_table[object]
		end
		local new_table = {}
		lookup_table[object] = new_table
		for index, value in pairs(object) do
			new_table[_copy(index)] = _copy(value)
		end
		return setmetatable(new_table, getmetatable(object))
	end
	return _copy(object)
end

--[[function print(...)
	local printResult = ""
	for i,v in ipairs(arg) do
		printResult = printResult .. tostring(v) .. "\t"
	end
	printResult = printResult .. "\n"
end]]