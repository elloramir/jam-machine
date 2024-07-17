-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local assets = require("assets")
local Entity = require("entity")


local Sprite = Entity:extend()


function Sprite:new(x, y)
	Entity.new(self)

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


function Sprite:set_image(image, speed)
	if image ~= self.image then
		self.image = image
		self.frame_speed = speed or 0
		self.frame_timer = 0
		self.frame = 1
	elseif speed and speed ~= self.frame_speed then
		self.frame_speed = speed
	end
end


function Sprite:set_shape(w, h, ox, oy)
	self.shape_w = w or self.image.width
	self.shape_h = h or self.image.height
	self.shape_ox = -math.floor((ox or 0.5) * self.shape_w)
	self.shape_oy = -math.floor((oy or 0.5) * self.shape_h)
	self.has_shape = true
end


function Sprite:corner()
	return self.x + self.shape_ox, self.y + self.shape_oy
end


function Sprite:contains_point(x, y)
    if not self.has_shape then
        return false
    end

	local x1 = self.x + (self.shape_ox or 0)
	local y1 = self.y + (self.shape_oy or 0)
	local x2 = x1 + (self.shape_w or 0)
	local y2 = y1 + (self.shape_h or 0)

	return x >= x1 and x <= x2 and y >= y1 and y <= y2
end


function Sprite:update(dt)
	-- update frame
	if self.image and self.frame_speed > 0 then
		self.frame_timer = self.frame_timer+dt
		if self.frame_timer > self.frame_speed then
			-- next frame
			self.frame = (self.frame + 1)
			self.frame_timer = 0
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


return Sprite