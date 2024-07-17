-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local camera = require("camera")
local lume = require("libs.lume")
local view = require("view")
local world = require("world")


local game = { }


function game.init()
    game.is_debug = false
    game.entities = { }
    game.world = world.new_world(64)
end


-- because must all entities imports this file, we cannot
-- require them here, so it's more practical to read them
-- dynamically inside that function.
function new_en(name, ...)
    local class = require("entities."..name)
    local instn = class(...)

    return instn
end


function game.add_entity(en, ...)
    en = type(en) == "string" and new_en(en, ...) or en
    return lume.push(game.entities, en)
end


local function sort_entities(a, b)
    return a.order < b.order
end


function game.update(dt)
    for i, en in lume.ripairs(game.entities) do
        if en.kill then
            table.remove(game.entities, i)
        elseif en.active then
            en:update(dt)
        end
    end

    if math.random() > 0.5 then
        table.sort(game.entities, sort_entities)
    end
end


local function draw_info(txt, i)
    local font = love.graphics.getFont()
    local w = font:getWidth(txt) + 5
    local h = font:getHeight() + 5

    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.rectangle("fill", 5, 5 + i * (h + 2), w, h, 3)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(txt, 7, 7 + i * (h + 2))
end


local function draw_world()
    camera.begin()
        local x, y, w, h = camera.get_bounds()

        for _, en in ipairs(game.entities) do
            if en.visible and en:cull(x, y, w, h) then
                en:draw()
            end
        end
    camera.finish()
end


local function draw_ui()
    for _, en in ipairs(game.entities) do
        if en.visible then
            en:draw_ui()
        end
    end
end


function game.draw()
    view.begin()
        view.child(200, 200, draw_world)
        view.child(700, 400, draw_ui)
    view.finish()

    -- debug info
    if game.is_debug then
        local status = love.graphics.getStats()

        draw_info("fps: " .. love.timer.getFPS(), 0)
        draw_info("entities: " .. #game.entities, 1)
        draw_info(string.format("sys_mem: %.2fmb", collectgarbage("count")/1024), 2)
        draw_info(string.format("tex_mem: %.2fmb", status.texturememory/1048576), 3)
        draw_info("dwr: " .. status.drawcalls, 4)
    end
end


return game