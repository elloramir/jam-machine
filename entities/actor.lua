-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local level = require("level")
local Entity = require("entity")
local Actor = Entity:extend()

-- NOTE(ellora): check by metatable are slow, this is
-- the only viable way to check if an object is an actor.
Actor.is_actor = true


function Actor:new(x, y, w, h, ox, oy)
	Entity.new(self)

	self.x = x
	self.y = y
	self.body_w = w
	self.body_h = h
	self.body_x = ox or 0
	self.body_y = oy or 0
	self.has_body = w and h
	self.solid = true
	self.speed_x = 0
	self.speed_y = 0
	self.accum_x = 0
	self.accum_y = 0
	self.restitution = 0

	self.flip_x = false
	self.flip_y = false
	self.pivot_x = 0
	self.pivot_y = 0
	self.scale_x = 1
	self.scale_y = 1
	self.rotation = 0
	self.alpha = 1
end

function Actor:set_image(image, speed)
	if image ~= self.image then
		self.image = image
		self.frame_speed = speed or DEFAULT_IMAGE_SPEED
		self.frame_timer = 0
		self.frame = 1
	end
end

function Actor:is_mouse_over()
	return self:contains_point(get_mouse())
end

function Actor:contains_point(x, y)
	return
		x >= self.x+self.body_x and
		x <= self.x+self.body_x+self.body_w and
		y >= self.y+self.body_y and
		y <= self.y+self.body_y+self.body_h
end

function Actor:overlaps(other, ox, oy)
	if not other.has_body then return false end

	ox = ox or 0
	oy = oy or 0

	return
		self.x+self.body_x+ox < other.x+other.body_x + other.body_w and
		self.x+self.body_x+ox + self.body_w > other.x+other.body_x and
		self.y+self.body_y+oy < other.y+other.body_y + other.body_h and
		self.y+self.body_y+oy + self.body_h > other.y+other.body_y
end

function Actor:place_meeting(ox, oy)
	ox = ox or 0
	oy = oy or 0

	-- static tiles test
	local xx = self.x+self.body_x+ox
	local yy = self.y+self.body_y+oy
	local x1 = math.floor(xx/TILE_SIZE)
	local y1 = math.floor(yy/TILE_SIZE)
	local x2 = math.floor((xx+self.body_w-1)/TILE_SIZE)
	local y2 = math.floor((yy+self.body_h-1)/TILE_SIZE)

	for y = y1, y2 do
		for x = x1, x2 do
			if level.get_tile(x, y) == 1 then
				return true
			end
		end
	end

	return false
end

function Actor:move_x(dt)
	local total = (self.speed_x*dt)+self.accum_x
	local pixels = math.floor(total)
	local dir = sign(pixels)
	self.accum_x = total-pixels

	if self.solid then
		while pixels ~= 0 do
			if not self:place_meeting(dir, 0) then
				self.x = self.x+dir
				pixels = pixels-dir
			else
				self.speed_x = -self.restitution*self.speed_x
				break
			end
		end
	else
		self.x = self.x+pixels
	end
end

function Actor:move_y(dt)
	local total = (self.speed_y*dt)+self.accum_y
	local pixels = math.floor(total)
	local dir = sign(pixels)
	self.accum_y = total-pixels

	if self.solid then
		while pixels ~= 0 do
			if not self:place_meeting(0, dir) then
				self.y = self.y+dir
				pixels = pixels-dir
			else
				self.speed_y = -self.restitution*self.speed_y
				break
			end
		end
	else
		self.y = self.y+pixels
	end
end

function Actor:update(dt)
	-- update position
	if self.has_body then
		if self.speed_x ~= 0 then self:move_x(dt) end
		if self.speed_y ~= 0 then self:move_y(dt) end
	end

	-- update frame
	if self.image and self.frame_speed > 0 then
		self.frame_timer = self.frame_timer+dt
		if self.frame_timer > self.frame_speed then
			-- next frame
			self.frame = self.frame+1
			self.frame_timer = 0
		end
	end
end

function Actor:draw()
	if not self.image then
		return
	end

	local scale_x = (self.flip_x and -1 or 1) * self.scale_x
	local scale_y = (self.flip_y and -1 or 1) * self.scale_y
	local pivot_x = math.floor(self.image.width * self.pivot_x)
	local pivot_y = math.floor(self.image.height * self.pivot_y)

	love.graphics.setColor(1, 1, 1, self.alpha)
	self.image:draw_index(self.frame, self.x, self.y, self.rotation,
		scale_x, scale_y, pivot_x, pivot_y)
end

function Actor:debug()
	if self.has_body then
		love.graphics.setColor(1, 0, 0)
		love.graphics.rectangle("line", self.x+self.body_x,
			self.y+self.body_y, self.body_w, self.body_h)
	end
end

return Actor
