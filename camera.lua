-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local lume = require("libs.lume")
local view = require("view")


local camera = { }


camera.x = 0
camera.y = 0
camera.zoom = 1

-- initial bounds must be something big (kind infinity)
camera.bound_x = -math.huge
camera.bound_y = -math.huge
camera.bound_w =  math.huge
camera.bound_h =  math.huge

camera.target_x = 0
camera.target_y = 0


function camera.set_bounds(x, y, w, h)
    camera.bound_x = x
    camera.bound_y = y
    camera.bound_w = w
    camera.bound_h = h

    -- update camera position to respect the new bounds
    camera.set_position(camera.x, camera.y, true)
end


function camera.set_position(x, y, not_smooth)
    local view_width, view_height = view.size("game")

    -- calculate the center of the map
    local map_center_x = camera.bound_x + camera.bound_w / 2
    local map_center_y = camera.bound_y + camera.bound_h / 2

    -- calculate the boundaries for camera movement
    local half_view_width = view_width / 2
    local half_view_height = view_height / 2

    local view_min_x = camera.bound_x + half_view_width
    local view_max_x = camera.bound_x + camera.bound_w - half_view_width
    local view_min_y = camera.bound_y + half_view_height
    local view_max_y = camera.bound_y + camera.bound_h - half_view_height

    -- adjust camera position on the x-axis
    if camera.bound_w < view_width then
        -- if the map is smaller than the viewport, center it
        camera.x = map_center_x
    else
        -- restrict to the boundaries
        camera.x = lume.clamp(x, view_min_x, view_max_x)
    end

    -- adjust camera position on the y-axis
    if camera.bound_h < view_height then
        -- if the map is smaller than the viewport, center it
        camera.y = map_center_y
    else
        -- restrict to the boundaries
        camera.y = lume.clamp(y, view_min_y, view_max_y)
    end

    if not not_smooth then
        camera.target_x = camera.x
        camera.target_y = camera.y
    end
end


function camera.update(dt)
    camera.target_x = lerpf(camera.target_x, camera.x, 10*dt)
    camera.target_y = lerpf(camera.target_y, camera.y, 10*dt)
end


function camera.attach()
    local width, height = view.size("game")
    
    love.graphics.push()
    love.graphics.translate(math.floor(width / 2), math.floor(height / 2))
    love.graphics.scale(camera.zoom)
    love.graphics.translate(math.floor(-camera.target_x), math.floor(-camera.target_y))
end


function camera.detach()
    love.graphics.pop()
end


function camera.world_mouse()
    local x, y = view.mouse("game")
    local width, height = view.size("game")

    x = x + camera.target_x - width / 2
    y = y + camera.target_y - height / 2

    return x, y
end


-- area of the screen that the camera is currently viewing
function camera.get_view()
    local width, heigth = view.size("game")
    local x = camera.target_x - width / 2
    local y = camera.target_y - heigth / 2

    return x, y, width, heigth
end


return camera