-- Copyright 2024 Banana Suit.
-- All rights over the code are reserved.


require("engine.utils")


local assets = require("engine.assets")
local game = require("engine.game")
local view = require("engine.view")


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


function love.keypressed(key)
    game.events:emit("keypressed", key)
end


function love.textinput(char)
    game.events:emit("textinput", char)
end

