-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local assets = require("assets")
local camera = require("camera")
local input = require("input")
local lume = require("libs.lume")
local view = require("view")
local shash = require("libs.shash")


local game = { }


function game.init()
    game.is_debug = false
    game.entities = { }
    game.world = shash.new(32)
    game.motion = 1

    game.add_entity("terminal")
end


-- because must all entities imports this file, we cannot
-- require them here, so it's necessary to read them dynamically.
local function new_en(name, ...)
    local class = require("entities."..name)
    local instance = class(...)

    return instance
end


function game.add_entity(en, ...)
    en = type(en) == "string" and new_en(en, ...) or en
    return lume.push(game.entities, en)
end


local function sort_entities(a, b)
    if a.should_sort_y and b.should_sort_y then
        return (a:bottom() + a.order) < (b:bottom() + b.order)
    end

    return a.order < b.order
end


function game.update(dt)
    dt = dt * game.motion
    input:update()

    -- toggle debug mode
    if ENV_DEV and input:pressed("debug") then
        game.is_debug = not game.is_debug
    end

    if ENV_DEV and input:pressed("quit") then
        love.event.quit()
    end

    for i, en in lume.ripairs(game.entities) do
        if en then
            if not en.is_alive then
                table.remove(game.entities, i)
                en:destruct()
            elseif en.is_active then
                en:update(dt)
            end
        end
    end

    camera.update(dt)
    table.sort(game.entities, sort_entities)
end


local function draw_info(txt, i)
    local font = love.graphics.getFont()
    local w = font:getWidth(txt) + 5
    local h = font:getHeight() + 5

    love.graphics.setColor(num_to_color(i+0xdead, 1, 0.5))
    love.graphics.rectangle("fill", 5, 5 + i * (h + 2), w, h, 3)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(txt, 7, 7 + i * (h + 2))
end


local function draw_world()
    local x, y, w, h = camera.get_view()

    camera.attach()
    for _, en in ipairs(game.entities) do
        if en then
            -- culling entities in "world-view" bounds
            if en.is_visible and not en.is_ui and en:cull(x, y, w, h) then
                en:draw()

                if game.is_debug then
                    en:debug()
                end
            end
        end
    end
    camera.detach()
end


local function draw_ui()
    for _, en in ipairs(game.entities) do
        if en then
            if en.is_visible and en.is_ui then
                en:draw()
            end
        end
    end
end


function game.draw()
    view.bind("world", draw_world)
    view.bind("ui", draw_ui)

    -- debug info
    if game.is_debug then
        local status = love.graphics.getStats()

        love.graphics.setFont(assets.get("fonts/debug"))

        draw_info(string.format("fps: %d", love.timer.getFPS()), 0)
        draw_info(string.format("entities: %d", #game.entities), 1)
        draw_info(string.format("sys mem: %.2fmb", collectgarbage("count")/1024), 2)
        draw_info(string.format("tex mem: %.2fmb", status.texturememory/1048576), 3)
        draw_info(string.format("drawcalls: %d", status.drawcalls), 4)
        draw_info(string.format("mouse: %d, %d", view.mouse("world")), 5) 
    end
end


function game.exit()
    love.event.quit()
end


function game.clear()
    for i, en in ipairs(game.entities) do
        if not en.is_permanent then
            en:destruct()
            table.remove(game.entities, i)
        end
    end
end


return game