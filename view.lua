-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local view = { }


function view.init()
    view.resize(love.graphics.getDimensions())
end


function view.resize(width, height)
    view.canvas = love.graphics.newCanvas(width, height)
    view.width = width
    view.height = height
end


function view.begin()
    love.graphics.setCanvas(view.canvas)
    love.graphics.clear()
end


function view.child(w, h, cb)
    local scale = math.max(1, math.min(view.width / w, view.height / h))
    local save_w = view.width
    local save_h = view.height

    view.width = save_w / scale
    view.height = save_h / scale

    love.graphics.push()
    love.graphics.scale(scale)
    cb() -- lonley boy lmao
    love.graphics.pop()

    view.width = save_w
    view.height = save_h
end


function view.finish()
    love.graphics.setCanvas()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(view.canvas)
end


return view