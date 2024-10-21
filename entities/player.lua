-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local input = require("input")
local Emitter = require("entities.emitter")
local Actor = require("entities.actor")


local Player = Actor:extend()


function Player:new(x, y)
    Player.super.new(self, x, y)

    self:set_tag("player")
    self:set_order(ORDER_SIMS)
    self:set_image("sprites/player")
    self:set_pivot(0.5, 1)
    self:set_shape(16, 16, 0.5, 1)

    self.max_move_speed = 150
    self.max_fall_speed = 500
    self.gravity = 1000
    self.jump_speed = 300
end


function Player:update(dt)
    Player.super.update(self, dt)

    -- horizontal movement
    do
        local dx = 0

        if input:down("left") then dx = dx - 1 end
        if input:down("right") then dx = dx + 1 end

        self.speed_x = dx * self.max_move_speed
    end

    -- gravity
    self.speed_y = approach(self.speed_y, self.max_fall_speed, self.gravity * dt)

    -- jump control
    if input:pressed("jump") and self:is_grounded() then
        self.speed_y = -self.jump_speed
    end

    self:move(dt)
end


return Player