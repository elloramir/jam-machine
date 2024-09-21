-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local input = require("input")
local Actor = require("entities.actor")

local Test = Actor:extend()


function Test:new(x, y)
    Test.super.new(self, x, y)

    self.is_solid = false
    self:set_shape(32, 32)

    self:on("body_enter", function()
        self.is_enter = true
    end)

    self:on("body_exit", function()
        self.is_enter = false
    end)
end


function Test:debug()
    if self.is_enter then
        love.graphics.setColor(0, 255, 0)
    else
        love.graphics.setColor(255, 0, 0)
    end

    love.graphics.rectangle("fill", self:shape())
end


return Test