-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local input = require("input")
local Actor = require("entities.actor")

local Player = Actor:extend()


function Player:new(x, y)
    Player.super.new(self, x, y)

    self.is_solid = false
    self:set_shape(32, 32)
    self:set_order(100)

    self:on("body_enter", function()
        print("entered")
    end)

    self:on("body_exit", function()
        print("exited")
    end)
end


function Player:update(dt)
    local dx, dy = 0, 0

    if input:down("left") then dx = dx - 1 end
    if input:down("right") then dx = dx + 1 end
    if input:down("up") then dy = dy - 1 end
    if input:down("down") then dy = dy + 1 end

    self.speed_x = dx * 100
    self.speed_y = dy * 100

    self:move(dt)
end


return Player