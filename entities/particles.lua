-- Copyright 2024 Banana Suit.
-- All rights over the code are reserved.

local lume = require("libs.lume")
local Sprite = require("entities.sprite")
local Entity = require("engine.entity")


local Particle = Sprite:extend()
local Emitter = Entity:extend()


-- default config
local config = {
	rate = 0.05,
	life_time = 1,
	anim_speed = 0.03,
	speed_x0 = 10,
	speed_x1 = 10,
	speed_y0 = 10,
	speed_y1 = 10,
}


function Particle:new(sheet_name, x, y, cfg)
	self.super.new(self, 0, 0)
	self:set_image(sheet_name, cfg.anim_speed, _, _, true)
	self:set_position(x, y)
	self.life_time = cfg.life_time
	self.speed_x = math.random(cfg.speed_x0, cfg.speed_x1)
	self.speed_y = math.random(cfg.speed_y0, cfg.speed_y1)
end


function Particle:update(dt)
	self.super.update(self, dt)
	-- move into speed
	self.x = self.x + self.speed_x * dt
	self.y = self.y + self.speed_y * dt
	-- fade color
	self.color[4] = self.life_time
	-- auto destruction timer
	self.life_time = self.life_time - dt
	if self.life_time <= 0 then
		self:destroy()
	end
end


-- @todo: config json from parameter
function Emitter:new(sheet_name, cfg, x, y)
	self.super.new(self)

	self:set_order(ORDER_PARTICLES)
	self:set_position(x, y)

	self.config = assets.get(cfg) or config
	self.sheet_name = sheet_name
	self.emission_rate = self.config.rate
	self.emission_timer = 0
	self.rotation = 0
	self.entries = {}
end


function Emitter:set_position(x, y)
	self.x, self.y = x, y
end


function Emitter:stop()
	self.has_ended = true
end


function Emitter:new_entry()
	local particle = Particle(self.sheet_name, self.x, self.y, self.config)
	particle.rotation = self.rotation
	table.insert(self.entries, particle)
end


function Emitter:update(dt)
	self.emission_timer = self.emission_timer + dt
	if self.emission_timer > self.emission_rate and not self.has_ended then
		self.emission_timer = 0
		self:new_entry()
	end

	for i, en in lume.ripairs(self.entries) do
		if not en.is_alive then
			table.remove(self.entries, i)
		else
			en:update(dt)
		end
	end
	if self.has_ended and #self.entries == 0 then
		self:emit("finish")
	end
end


function Emitter:draw()
	for _, en in ipairs(self.entries) do
		en:draw()
	end
end


return Emitter