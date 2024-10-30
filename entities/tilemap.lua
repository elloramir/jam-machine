-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local assets = require("assets")
local camera = require("camera")
local game = require("game")
local lume = require("libs.lume")
local Entity = require("entity")


local Tilemap = Entity:extend()


function Tilemap:new(tileset, order)
    self.super.new(self)

    self.rows = 0
    self.cols = 0
    self.tiles = { }

    self:set_order(order or 0)
    self:set_tileset(tileset)
    self:set_position(0, 0)
end


function Tilemap:set_position(x, y)
    self.x, self.y = x, y
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


function Tilemap:gen_colliders()
    self.colliders = {}
    local size = self.tileset.width
    local visited = {}

    -- Helper function to mark tiles as visited
    local function mark_visited(x, y, w, h)
        for j = y, y + h - 1 do
            for i = x, x + w - 1 do
                visited[hash2d(i, j)] = true
            end
        end
    end

    -- Greedy algorithm to create larger colliders
    for y = 0, self.rows - 1 do
        for x = 0, self.cols - 1 do
            local id = self:get_tile(x, y)
            if id ~= 0 and not visited[hash2d(x, y)] then
                -- Determine the width (w) of the collider
                local w = 1
                while x + w < self.cols and self:get_tile(x + w, y) == id and not visited[hash2d(x + w, y)] do
                    w = w + 1
                end

                -- Determine the height (h) of the collider
                local h = 1
                local is_rectangular = true
                while is_rectangular and y + h < self.rows do
                    for i = 0, w - 1 do
                        if self:get_tile(x + i, y + h) ~= id or visited[hash2d(x + i, y + h)] then
                            is_rectangular = false
                            break
                        end
                    end
                    if is_rectangular then
                        h = h + 1
                    end
                end

                -- Create a collider for the found rectangular area
                local x0 = self.x + x * size
                local y0 = self.y + y * size
                table.insert(self.colliders, game.add_entity("collider", x0, y0, w * size, h * size))

                -- Mark tiles as visited
                mark_visited(x, y, w, h)
            end
        end
    end
end



function Tilemap:destruct()
    for _, collider in ipairs(self.colliders) do
        collider:destroy()
    end
end


function Tilemap:draw()
    local size = self.tileset.width
    local x, y, w, h = camera.get_view()
    local x0 = math.floor((x - self.x) / size)
    local y0 = math.floor((y - self.y) / size)
    local x1 = math.floor((x + w - self.x) / size)
    local y1 = math.floor((y + h - self.y) / size)

    -- check if is totally out of the screen
    if x1 < 0 or y1 < 0 or x0 >= self.cols or y0 >= self.rows then
        return
    end

    love.graphics.setColor(1, 1, 1)
    for y = y0, y1 do
        for x = x0, x1 do
            local id = self:get_tile(x, y)

            if id ~= 0 then
                self.tileset:draw_index(id,
                    self.x + x * size,
                    self.y + y * size)
            end
        end
    end
end


return Tilemap