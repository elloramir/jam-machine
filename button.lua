-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local assets = require("assets")
local input = require("input")


local button = { }


local cache = { }


local function get_spr_bounds(name)
	if not cache[name] then
		local map = assets.get("data/btn_map")
		local key = map[name] or map.none
		assert(key)

		local x0 = key.x
		local y0 = key.y
		local x1 = key.x + key.w - 1
		local y1 = key.y + key.h - 1

		cache[name] = {
			x0 = x0, x1 = x1,
			y0 = y0, y1 = y1
		}
	end

	return cache[name]
end


function button.draw(mapped_key, x, y)
	local sheet = assets.get("sprites/ui/buttons")
	local key = input:getButton(mapped_key)
	local bounds = get_spr_bounds(key)
	local cols = 34
	local tile = 16
	local w = (bounds.x1 - bounds.x0) * tile
	local h = (bounds.y1 - bounds.y0) * tile


    for i = bounds.x0, bounds.x1 do
        for j = bounds.y0, bounds.y1 do
            local xx = x + (i - bounds.x0) * tile - w/2
            local yy = y + (j - bounds.y0) * tile - h/2
            local index = i + j * cols + 1

            sheet:draw_index(index, xx, yy, 0.5, 0.5)
        end
    end
end


return button