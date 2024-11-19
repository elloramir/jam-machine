-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local view = { }


view.layers = { }


function view.init()
    view.width = love.graphics.getWidth()
    view.height = love.graphics.getHeight()

    view.new_layer("world", 640, 360)
    view.new_layer("ui", 640, 360)
end


function view.new_layer(name, width, height)
    local layer = { }
    local scale = math.min(view.width / width, view.height / height)

    layer.width = width
    layer.height = height
    layer.scale = scale
    layer.x = roundf((view.width - width * scale) / 2)
    layer.y = roundf((view.height - height * scale) / 2)
    
    -- creating framebuffer
    layer.canvas = love.graphics.newCanvas(layer.width, layer.height)

    view.layers[name] = layer
end


function view.resize(width, height)
    view.width = width
    view.height = height

    -- just re-run the layer creation and let the 
    -- garbage collector do its job.
    for name, layer in pairs(view.layers) do
        view.new_layer(name, layer.width, layer.height)
    end
end


function view.bind(layer_name, draw_callback)
    local layer = view.layers[layer_name]
    assert(layer)

    love.graphics.setCanvas(layer.canvas)
    love.graphics.clear()

    draw_callback()

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

    x = math.floor((x - layer.x) / scale)
    y = math.floor((y - layer.y) / scale)

    return x, y
end


return view