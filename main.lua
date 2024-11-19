-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

require("utils")


local assets = require("assets")
local game = require("game")
local view = require("view")


function love.load()
    math.randomseed(os.time())

    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineStyle("rough")

    assets.init()
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

function love.quit()
    game.exit()
end