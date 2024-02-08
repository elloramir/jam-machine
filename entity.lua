-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local Object = require("classic")
local Entity = Object:extend()

function Entity:new(order)
	self.active = true
	self.time_creation = love.timer.getTime()/1e7
	self:set_order(order or 0)
end

function Entity:set_order(order)
	self.order = order+self.time_creation
end

-- since we use flags to mark entities as unactive,
-- we need to wait the frame ends until the entity get real destroyed.
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
