-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local assets = require("assets")
local game = require("game")
local entity = require("entity")


local Sprite = entity:extend()


function Sprite:new(x, y)
    Sprite.super.new(self)

    self.x = x
    self.y = y
    self.offset_x = 0
    self.offset_y = 0
    self.flip_x = false
    self.flip_y = false
    self.pivot_x = 0.5
    self.pivot_y = 0.5
    self.scale_x = 1
    self.scale_y = 1
    self.rotation = 0
    self.color = { 1, 1, 1, 1 }
end


function Sprite:set_position(x, y)
    self.x, self.y = x, y
end


-- visual bottom of the sprite
function Sprite:bottom()
    if not self.image then
        return self.y
    end

    local height = self.image.height * self.scale_y
    local pivot = self.image.height * self.pivot_y * self.scale_y

    return self.y + self.offset_y + height - pivot
end


function Sprite:set_pivot(x, y)
    self.pivot_x = x or self.pivot_x
    self.pivot_y = y or self.pivot_y
end


function Sprite:image_points()
    if not self.image then
        return self.x, self.y, self.x, self.y
    end

    local x1 = self.x + self.offset_x - self.image.width * self.pivot_x * self.scale_x
    local y1 = self.y + self.offset_y - self.image.height * self.pivot_y * self.scale_y
    local x2 = x1 + self.image.width * self.scale_x
    local y2 = y1 + self.image.height * self.scale_y

    return x1, y1, x2, y2
end


function Sprite:image_body()
    local x1, y1, x2, y2 = self:image_points()
    
    return x1, y1, (x2 - x1), (y2 - y1)
end


function Sprite:image_overlaps(x3, y3, x4, y4)
    local x1, y1, x2, y2 = self:image_points()

    return x1 < x4 and x2 > x3 and y1 < y4 and y2 > y3
end


function Sprite:set_image(image_name, speed, first, last, once)
    local image = assets.get(image_name)
    assert(image)

    if image ~= self.image then
        self.image = image
        self.frame_timer = 0
        self.frame = first or 1
    end

    self.play_once = once
    self.frame_speed = speed or 0
    self.frame_start = first or 1
    self.frame_end = last or image:frames_count()
end


function Sprite:set_frame(index)
    self.frame = index
end


function Sprite:set_random_frame()
    self.frame = math.random(self.frame_start, self.frame_end)
end


function Sprite:restore_scale(spd, dt)
    self.scale_x = lerpf(self.scale_x, 1, spd * dt)
    self.scale_y = lerpf(self.scale_y, 1, spd * dt)
end


function Sprite:set_scale(x, y)
    self.scale_x = x or self.scale_x
    self.scale_y = y or self.scale_y
end


function Sprite:update(dt)
    -- update frame
    if self.image and self.frame_speed > 0 then
        self.frame_timer = self.frame_timer + dt
        if self.frame_timer > self.frame_speed then
            -- next frame
            self.frame = (self.frame + 1)
            self.frame_timer = 0
            -- last frame reached
            if self.frame > self.frame_end then
                -- if should play once, then stopped it at the end
                if self.play_once then
                    self.frame_speed = 0
                    self.frame = self.frame_end
                else
                    -- back to beginning
                    self.frame = self.frame_start
                end
            end
        end
    end
end


function Sprite:draw()
    -- the color should be propagate anyways, even if it is not visible,
    -- because it should affect things bellow the super call.
    love.graphics.setColor(self.color)

    -- ignore draw calls when it is not visible
    if not self.image or self.color[4] == 0 then
        return
    end

    local x = self.x + self.offset_x
    local y = self.y + self.offset_y
    local scale_x = (self.flip_x and -1 or 1) * self.scale_x
    local scale_y = (self.flip_y and -1 or 1) * self.scale_y

    self.image:draw_index(self.frame, x, y, self.pivot_x, self.pivot_y, self.rotation, scale_x, scale_y)
end


function Sprite:cull(x, y, w, h)
    return self:image_overlaps(x, y, x+w, y+h)
end


return Sprite