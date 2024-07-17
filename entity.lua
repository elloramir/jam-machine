-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local Object = require("libs.classic")


local Entity = Object:extend()


function Entity:new(order)
	self.kill = false -- delete this entity in the next frame
	self.visible = true -- ignore this entity in the draw loop
	self.active = true -- ignore this entity in the update loop

	self:gen_time_seed()
	self:set_order(order or 0)
end


function Entity:gen_time_seed()
	self.time_seed = love.timer.getTime()/1e7
end


function Entity:set_order(order)
	self.order = order+self.time_seed
end


-- since we use flags to mark entities as unactive,
-- we need to wait the next frame until the entity get real destroyed.
function Entity:destroy()
	self.kill = true
end


function Entity:update(dt)
end


function Entity:cull(x, y, w, h)
	return true
end


function Entity:draw()
end


function Entity:ui()
end


return Entity