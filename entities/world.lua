-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local Entity = require("entity")
local World = Entity:extend()

local SMOOTHNESS = 0.1

function World:new()
    Entity.new(self)

    self.cols = 40
    self.rows = 23
end

function World:draw()
    local off_x = math.sin(love.timer.getTime() * 0.1)
    local off_y = math.cos(love.timer.getTime() * 0.2)

    for i = 0, (self.cols-1) do
        for j = 0, (self.rows-1) do
            local v = love.math.noise(i * SMOOTHNESS, j * SMOOTHNESS)

            -- tint like grass or water
            if v < 0.5 then
                if (i+j) % 2 == 0 then
                    love.graphics.setColor(0.1, 0.8, 0.1)
                else
                    love.graphics.setColor(0.1, 0.6, 0.1)
                end
            else
                -- make water lighter blue when close of the coast
                local v2 = love.math.noise(off_x + i * SMOOTHNESS, off_y + j * SMOOTHNESS)
                local dist = math.abs(v - v2)
                if dist < 0 then dist = -dist end
                local specular = math.pow(love.math.noise(off_x + i * SMOOTHNESS, j * SMOOTHNESS), 3) * 0.2
                local r = 0.1 + specular
                local g = 0.1 + specular
                local b = 0.6 - dist + 0.4 + specular
                love.graphics.setColor(r, g, b)
            end

            love.graphics.rectangle("fill", i * TILE_SIZE, j * TILE_SIZE, TILE_SIZE, TILE_SIZE)
        end
    end
end

return World