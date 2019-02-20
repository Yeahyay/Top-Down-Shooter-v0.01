--setfenv(1, Game)
--[[require("globalFunctions")
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
Concord = require("lib/Concord-master/lib")
	Concord.init({
		useEvents = false
	})
Component = Concord.component
Entity = Concord.entity
Instance = Concord.instance
System = Concord.system
Serialize = require("lib/knife-master/knife/serialize")]]