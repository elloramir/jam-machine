-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local Image = require("image")
local level = require("level")

local screen
local screen_scale = 1
local screen_x = 0
local screen_y = 0

function love.load()
	love.graphics.setLineStyle("rough")
	love.graphics.setDefaultFilter("nearest", "nearest")
	screen = love.graphics.newCanvas(WIDTH, HEIGHT)

	level.load()
end

function love.update(dt)
	level.update(dt)
end

function love.draw()
	love.graphics.setCanvas(screen)
	love.graphics.clear()

	-- draw our game here
	level.draw()

	do
		local w, h = love.graphics.getDimensions()
		screen_scale = math.min(w / WIDTH, h / HEIGHT)
		screen_x = (w - WIDTH * screen_scale) / 2
		screen_y = (h - HEIGHT * screen_scale) / 2

		love.graphics.setColor(1, 1, 1)
		love.graphics.setCanvas(nil)
		love.graphics.draw(screen, screen_x, screen_y, 0, screen_scale, screen_scale)
	end

	-- debug info
	love.graphics.setColor(1, 1, 1)
	love.graphics.print("fps: " .. love.timer.getFPS(), 10, 10)
	love.graphics.print("mem: " .. math.floor(collectgarbage("count")) .. "kb", 10, 30)
	love.graphics.print("ent: " .. #level.entities, 10, 50)
end
