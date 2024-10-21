-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local view = { }


view.binded = ""
view.layers = { }


function view.init()
    view.width = love.graphics.getWidth()
    view.height = love.graphics.getHeight()

    view.new_layer("game", 300, 300)
    -- view.new_layer("ui", 200, 200)
end


function view.new_layer(name, width, height)
    local layer = { }
    local scale = roundf(math.max(1, math.min(view.width / width, view.height / height)))

    -- input width and height (we need to save it to use later on resize events)
    layer.iwidth = width
    layer.iheight = height

    -- the layer width is result of the input width and height
    layer.width = roundf(view.width / scale)
    layer.height = roundf(view.height / scale)
    layer.scale = scale
    layer.canvas = love.graphics.newCanvas(layer.width, layer.height)

    view.layers[name] = layer
end


function view.resize(width, height)
    view.width = width
    view.height = height

    for name, layer in pairs(view.layers) do
        view.new_layer(name, layer.iwidth, layer.iheight)
    end
end


function view.bind(layer_name, draw_callback)
    local layer = view.layers[layer_name]
    assert(layer)

    view.binded = layer_name
    love.graphics.setCanvas(layer.canvas)
    love.graphics.clear()

    draw_callback()

    -- display the layer on the window backbuffer
    love.graphics.setCanvas()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(layer.canvas, 0, 0, 0, layer.scale)
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

    x = math.floor(x / scale)
    y = math.floor(y / scale)

    return x, y
end


return view