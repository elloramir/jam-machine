-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local lume = require("libs.lume")
local Entity = require("entity")


local Sprite = Entity:extend()


function Sprite:new(x, y)
	Entity.new(self)

	self.x = x
	self.y = y
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

	local x = self.x
	local y = self.y
	local scale_x = (self.flip_x and -1 or 1) * self.scale_x
	local scale_y = (self.flip_y and -1 or 1) * self.scale_y

	self.image:draw_index(self.frame, x, y, self.pivot_x, self.pivot_y, self.rotation, scale_x, scale_y)
end


function Sprite:cull(x, y, w, h)
	if not self.image then
		return false
	end

	local x1 = self.x
	local y1 = self.y
	local x2 = x1 + self.image.width
	local y2 = y1 + self.image.height

	return x2 >= x and x1 <= x + w and y2 >= y and y1 <= y + h
end


return Sprite