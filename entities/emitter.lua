-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local ffi = require("ffi")
local Entity = require("entity")


local Emitter = Entity:extend()


-- define it using ffi because it's faster
-- to create and access the particles.
ffi.cdef[[
    typedef struct
    {
        float x, y;
        float speed_x, speed_y;
        float life;
    }
    Particle;
]]


function Emitter:new(x, y, buffer_size)
    Emitter.super.new(self, ORDER_EMITTERS)

    self.x = x
    self.y = y
    self.buffer_size = buffer_size
    self.gravity = 0
    self.particles = { }

    for i = 1, buffer_size do
        self:init_particle(i)
    end
end


function Emitter:mark_single_shot()
    self.is_single_shot = true
end


function Emitter:init_particle(index)
    local p = self.particles[index] or ffi.new("Particle")

    p.x = self.x
    p.y = self.y
    p.speed_x = math.random(-100, 100)
    p.speed_y = math.random(-100, 100)
    p.life = math.random()

    self.particles[index] = p
end


function Emitter:update(dt)
    self.max_x, self.max_y = -math.huge, -math.huge
    self.min_x, self.min_y = math.huge, math.huge

    for i = 1, self.buffer_size do
        local p = self.particles[i]

        -- gravity
        p.speed_y = p.speed_y + self.gravity * dt

        p.x = p.x + p.speed_x * dt
        p.y = p.y + p.speed_y * dt

        -- this is used to calculate the bounding box of the emitter
        self.max_x = math.max(self.max_x, p.x)
        self.max_y = math.max(self.max_y, p.y)
        self.min_x = math.min(self.min_x, p.x)
        self.min_y = math.min(self.min_y, p.y)

        -- life-time
        p.life = p.life - dt

        if p.life <= 0 and not self.is_single_shot then
            self:init_particle(i)
        end
    end
end


function Emitter:draw()
    love.graphics.setColor(1, 1, 1)

    for i = 1, self.buffer_size do
        local p = self.particles[i]

        love.graphics.points(p.x, p.y)
    end
end


function Emitter:debug()
    love.graphics.setColor(1, 0, 0, 0.5)
    love.graphics.rectangle("line", self.min_x, self.min_y, self.max_x - self.min_x, self.max_y - self.min_y)
end


function Emitter:cull(x, y, w, h)
    return x < self.max_x and y < self.max_y and w > self.min_x and h > self.min_y
end


return Emitter