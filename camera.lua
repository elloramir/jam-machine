-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local view = require("view")
local camera = { }


camera.x = 0
camera.y = 0
camera.zoom = 1

camera.bound_x = -math.huge
camera.bound_y = -math.huge
camera.bound_w = math.huge
camera.bound_h = math.huge


function camera.set_bounds(x, y, w, h)
	camera.bound_x = x
	camera.bound_y = y
	camera.bound_w = w
	camera.bound_h = h
end


function camera.begin()
	love.graphics.push()
	love.graphics.translate(view.width/2, view.height/2)
	love.graphics.scale(camera.zoom)
	love.graphics.translate(
		math.floor(-camera.x+0.5),
		math.floor(-camera.y+0.5))
end


function camera.finish()
	love.graphics.pop()
end


function camera.get_bounds()
	return camera.x - view.width/2/camera.zoom,
		   camera.y - view.height/2/camera.zoom,
		   view.width/camera.zoom,
		   view.height/camera.zoom
end


return camera