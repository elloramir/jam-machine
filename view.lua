-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local view = { }


view.layers = { }


function view.init()
    view.width = love.graphics.getWidth()
    view.height = love.graphics.getHeight()
end


function view.newLayer(name, width, height)
    local layer = { }
    local scale = math.max(1, math.min(view.width / width, view.height / height))
    local x = math.floor((view.width - width * scale) / 2)
    local y = math.floor((view.height - height * scale) / 2)

    layer.width = width
    layer.height = height
    layer.scale = scale
    layer.x = x
    layer.y = y
    layer.canvas = love.graphics.newCanvas(width, height)

    view.layers[name] = layer
end


function view.resize(width, height)
    view.width = width
    view.height = height

    for name, layer in pairs(view.layers) do
        view.newLayer(name, layer.width, layer.height)
    end
end


function view.bind(layer_name, draw_ctx_callback)
    local layer = view.layers[layer_name]
    assert(layer)

    love.graphics.setCanvas(layer.canvas)
    love.graphics.clear()

    draw_ctx_callback()

    -- display the layer on the window backbuffer
    love.graphics.setCanvas()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(layer.canvas, layer.x, layer.y, 0, layer.scale)
end


function view.size(name)
    local layer = view.layers[name]
    assert(layer)

    return layer.width, layer.height
end


function view.mouse(name)
    local layer = view.layers[name]
    assert(layer)

    local x, y = love.mouse.getPosition()
    local scale = layer.scale

    x = (x - layer.x) / scale
    y = (y - layer.y) / scale

    return x, y
end


return view