-- Copyright 2024 Banana Suit.
-- All rights over the code are reserved.


local lume = require("libs.lume")
local Object = require("libs.classic")


local Sheet = Object:extend()


function Sheet:new(filename, fw, fh)
    self.img = love.graphics.newImage(filename)
    self.img:setFilter("nearest", "nearest")

    self.width = fw or self.img:getWidth()
    self.height = fh or self.img:getHeight()
    self.cols = self.img:getWidth() / self.width
    self.rows = self.img:getHeight() / self.height

    -- check if the image is divisible by the frame size.
    -- This is a common mistake that can happens lots of times.
    assert(self.img:getWidth() % self.width == 0)
    assert(self.img:getHeight() % self.height == 0)

    self.quads = {}
    for y = 0, (self.img:getHeight() - self.height), self.height do
        for x = 0, (self.img:getWidth() - self.width), self.width  do
            table.insert(self.quads,
                love.graphics.newQuad(x, y, self.width, self.height, self.img))
        end
    end
end


function Sheet:frames_count()
    return #self.quads
end


function Sheet:get_quad(index)
    return self.quads[index]
end


function Sheet:rand_frame()
    return math.random(1, #self.quads)
end


function Sheet:rand_quad()
    return lume.randomchoice(self.quads)
end


function Sheet:id(x, y)
    return y * self.cols + x + 1
end


function Sheet:draw_index(index, x, y, px, py, r, sx, sy)
    assert(index>0)

    local fixedIndex = ((index-1) % #self.quads) + 1
    local quad = self.quads[fixedIndex]
    local pivotX = math.floor(self.width * (px or 0))
    local pivotY = math.floor(self.height * (py or 0))

    x = math.floor(x or 0)
    y = math.floor(y or 0)

    love.graphics.draw(self.img, quad, x, y, r, sx, sy, pivotX, pivotY)
end


function Sheet:draw(...)
    self:draw_index(1, ...)
end


return Sheet