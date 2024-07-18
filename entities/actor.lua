-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local game = require("game")
local lume = require("libs.lume")
local Sprite = require("entities.sprite")

local Actor = Sprite:extend()


function Actor:new(x, y)
    Actor.super.new(self, x, y)

    self.speed_x = 0
    self.speed_y = 0
    self.restitution = 0
    self.normal_x = 0
    self.normal_y = 0
end


function Actor:set_shape(w, h, ox, oy)
	self.shape_w = w or self.image.width
	self.shape_h = h or self.image.height
	self.shape_ox = -math.floor((ox or 0.5) * self.shape_w)
	self.shape_oy = -math.floor((oy or 0.5) * self.shape_h)
	self.has_shape = true

    game.world:add(self, self:shape())
end


function Actor:destruct()
    game.world:remove(self)
end


function Actor:contains_point(x, y)
	if not self.has_shape then
		return false
	end

	local x1 = self.x + (self.shape_ox or 0)
	local y1 = self.y + (self.shape_oy or 0)
	local x2 = x1 + (self.shape_w or 0)
	local y2 = y1 + (self.shape_h or 0)

	return x >= x1 and x <= x2 and y >= y1 and y <= y2
end


function Actor:corner()
	return self.x + self.shape_ox, self.y + self.shape_oy
end


function Actor:shape()
    return self.x + self.shape_ox, self.y + self.shape_oy, self.shape_w, self.shape_h
end


function Actor.filter(other, self)
	if other:is(Actor) then
		self:resolve_mtv(other)
	end
end


function Actor:move(dt)
	if self.speed_x == 0 and self.speed_y == 0 then
		return
	end

	self.normal_x = 0
	self.normal_y = 0

	self.x = self.x + self.speed_x * dt
	self.y = self.y + self.speed_y * dt

	game.world:update(self, self:shape())
	game.world:each(self, self.filter, self)
end


-- smallest vector that can be applied to
-- separate two overlapping rectangles
function Actor:resolve_mtv(other)
	local x1, y1, w1, h1 = self:shape()
	local x2, y2, w2, h2 = other:shape()

	local dx = x1 + w1/2 - x2 - w2/2
	local dy = y1 + h1/2 - y2 - h2/2

	local ox = w1/2 + w2/2 - math.abs(dx)
	local oy = h1/2 + h2/2 - math.abs(dy)

	if ox < oy then
		if dx > 0 then
			self.x = self.x + ox
		else
			self.x = self.x - ox
		end

		self.speed_x = self.speed_x * self.restitution
		self.normal_x = dx > 0 and 1 or -1
	else
		if dy > 0 then
			self.y = self.y + oy
		else
			self.y = self.y - oy
		end

		self.speed_y = self.speed_y * self.restitution
		self.normal_y = dy > 0 and 1 or -1
	end
end


function Actor:cull(x, y, w, h)
	local visible = Actor.super.cull(self, x, y, w, h)

	if not visible and self.has_shape then
		local x1, y1, w1, h1 = self:shape()
		visible = x1 < x + w and x1 + w1 > x and y1 < y + h and y1 + h1 > y
	end

	return visible
end


function Actor:draw()
	Actor.super.draw(self)

	if game.is_debug and self.has_shape then
		love.graphics.setColor(1, 0, 0)
		love.graphics.rectangle("line", self:shape())
	end
end


return Actor