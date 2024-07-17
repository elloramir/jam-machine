-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local game = require("game")
local view = require("view")


function love.load()
	view.init()
	game.init()
end


function love.resize(width, height)
	view.resize(width, height)
end


function love.update(dt)
	game.update(dt)
end


function love.draw()
	game.draw()
end