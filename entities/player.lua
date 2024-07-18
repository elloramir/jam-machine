-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local input = require("input")
local Actor = require("entities.actor")

local Player = Actor:extend()


function Player:new(x, y)
    Player.super.new(self, x, y)

    self:set_shape(100, 1)
end


function Player:update(dt)
    Player.super.update(self, dt)

    local dx, dy = 0, 0

    if input:down("left") then dx = dx - 1 end
    if input:down("right") then dx = dx + 1 end
    if input:down("up") then dy = dy - 1 end
    if input:down("down") then dy = dy + 1 end

    self.speed_x = dx * 100
    self.speed_y = dy * 100

    self:move(dt)
end


function Player:draw()
    love.graphics.setColor(1, 0, 1)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line",
        self.x + self.shape_ox,
        self.y + self.shape_oy,
        self.shape_w,
        self.shape_h)
end


function Player:ui()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(string.format("Player: %d, %d", self.x, self.y), 10, 10)
end


return Player