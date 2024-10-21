-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local assets = require("assets")
local Entity = require("entity")


local Tilemap = Entity:extend()


function Tilemap:new(tileset, order)
    self.super.new(self)

    self.rows = 0
    self.cols = 0
    self.tiles = { }

    self:set_order(order or 0)
    self:set_tileset(tileset)
end


function Tilemap:set_tileset(name)
    self.tileset = assets.get(name)
    assert(self.tileset)
end


function Tilemap:set_tile(x, y, tile)
    -- use the tileset size to calculate the rows and cols
    self.cols = math.max(self.cols, x + 1)
    self.rows = math.max(self.rows, y + 1)

    self.tiles[hash2d(x, y)] = tile
end


function Tilemap:get_tile(x, y)
    return self.tiles[hash2d(x, y)] or 0
end


function Tilemap:draw()
    local size = self.tileset.width

    love.graphics.setColor(1, 1, 1)
    for y = 0, self.rows - 1 do
        for x = 0, self.cols - 1 do
            local id = self:get_tile(x, y)

            if id ~= 0 then
                self.tileset:draw_index(id, x * size, y * size)
            end
        end
    end
end


return Tilemap