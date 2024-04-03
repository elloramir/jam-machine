-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local level = require("level")

local dbug = false
local screen
local screen_scale = 1
local screen_x = 0
local screen_y = 0

-- @global
function to_screen_space(x, y)
	return
		math.floor((x - screen_x) / screen_scale / camera.zoom + camera.x),
		math.floor((y - screen_y) / screen_scale / camera.zoom + camera.y)
end

-- @global
function get_mouse()
	return to_screen_space(love.mouse.getPosition())
end

function love.load()
	love.graphics.setLineStyle("rough")
	love.graphics.setDefaultFilter("nearest", "nearest")
	screen = love.graphics.newCanvas(WIDTH, HEIGHT)

	level.load()
end

function love.keypressed(key)
	-- <TAB> toggle debug mode
	if key == "tab" then dbug = not dbug end
	if key == "escape" then love.event.quit() end
end

function love.update(dt)
	level.update(dt)
end

function love.draw()
	love.graphics.setCanvas(screen)
	love.graphics.clear()

	-- draw our game here
	level.draw()

	if dbug then
		level.debug()
	end

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
	if dbug then
		love.graphics.setColor(1, 1, 1)
		love.graphics.print("fps: " .. love.timer.getFPS(), 10, 10)
		love.graphics.print("mem: " .. math.floor(collectgarbage("count")) .. "kb", 10, 30)
		love.graphics.print("ent: " .. #level.entities, 10, 50)
	end
end
