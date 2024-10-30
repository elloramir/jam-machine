-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local Actor = require("entities.actor")


local Collider = Actor:extend()


function Collider:new(x, y, w, h)
    Collider.super.new(self, x, y)
    self.is_active = false -- disable update event
    self:set_tag("collider")
    self:set_shape(w, h, 0, 0)
    self:set_order(ORDER_DEBUG)
end


return Collider