-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local Object = require("classic")
local Entity = Object:extend()

function Entity:new(order)
	self.active = true
	self:gen_order_seed()
	self:set_order(order or 0)
end

function Entity:gen_order_seed()
	self.time_seed = love.timer.getTime()/1e7
end

function Entity:set_order(order)
	self.order = order+self.time_seed
end

-- since we use flags to mark entities as unactive,
-- we need to wait the next frame until the entity get real destroyed.
function Entity:destroy()
	self.active = false
end

function Entity:update(dt)
end

function Entity:draw()
end

function Entity:debug()
end

return Entity
