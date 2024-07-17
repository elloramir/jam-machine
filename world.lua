--[[
MIT License

Copyright (c) 2024 Ellora Lucas (github.com/elloramir)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--

local api = { }
local world = { }
world.__index = world


function api.new_world(cell_size)
	local self = {}
	self.cell_size = cell_size or 64
	self.grid = { }
	self.rects = { }

	return setmetatable(self, world)
end


local function hash2d(x, y)
	return x + y * 1e7
end


local function get_cell(world, i, j)
	local index = hash2d(i, j)
	local cell = world.grid[index]

	-- register the cell if it doesn't exist
	if not cell then
		cell = { }
		world.grid[index] = cell
	end

	return cell
end


local function overlaps(ax0, ay0, ax1, ay1, bx0, by0, bx1, by1)
	return ax0 <= bx1 and ax1 >= bx0 and ay0 <= by1 and ay1 >= by0
end


local function each_cell(world, x0, y0, x1, y1, cb, ...)
	local nx0 = math.floor(x0 / world.cell_size)
	local ny0 = math.floor(y0 / world.cell_size)
	local nx1 = math.floor(x1 / world.cell_size)
	local ny1 = math.floor(y1 / world.cell_size)

	for j = ny0, ny1 do
		for i = nx0, nx1 do
			cb(i, j, world, x0, y0, x1, y1, ...)
		end
	end
end


local function set_rect(i, j, world, _, _, _, _, rect)
	local cell = get_cell(world, i, j)
	local cx0 = i * world.cell_size
	local cy0 = j * world.cell_size
	local cx1 = (i + 1) * world.cell_size
	local cy1 = (j + 1) * world.cell_size

	if overlaps(rect.x0, rect.y0, rect.x1, rect.y1, cx0, cy0, cx1, cy1) then
		cell[rect] = true
	else
		cell[rect] = nil
	end
end


function world:add_rect_ex(ref, x0, y0, x1, y1)
	local rect = { x0 = x0, y0 = y0, x1 = x1, y1 = y1, ref = ref }

	each_cell(self, x0, y0, x1, y1, set_rect, rect)
	self.rects[ref] = rect
end


-- @todo: check if has changed the cell position
function world:update_rect_ex(ref, x0, y0, x1, y1)
	local rect = self.rects[ref]

	if not rect then
		error("could not found rect: " .. ref)
	end

	-- lets create superset rectangle that
	-- interesects the old dimensions.
	local rx0 = math.min(rect.x0, x0 or rect.x0)
	local ry0 = math.min(rect.y0, y0 or rect.y0)
	local rx1 = math.max(rect.x1, x1 or rect.x1)
	local ry1 = math.max(rect.y1, y1 or rect.y1)

	-- update the rect
	rect.x0 = x0 or rect.x0
	rect.y0 = y0 or rect.y0
	rect.x1 = x1 or rect.x1
	rect.y1 = y1 or rect.y1

	each_cell(self, rx0, ry0, rx1, ry1, set_rect, rect)
end


function world:add_rect(ref, x, y, w, h)
	self:add_rect_ex(ref, x, y, x + w, y + h)
end


function world:update_rect(ref, x, y, w, h)
	self:update_rect_ex(ref, x, y, x + w, y + h)
end


local function remove_rect(i, j, world, _, _, _, _, rect)
	local cell = get_cell(world, i, j)
	cell[rect] = nil
end


function world:remove_rect(ref)
	local rect = self.rects[ref]

	if not rect then
		error("could not found rect: " .. ref)
	end

	each_cell(self, rect.x0, rect.y0, rect.x1, rect.y1, remove_rect, rect)
	self.rects[ref] = nil
end


local queries = {}

local function find_overlaps(i, j, world, x0, y0, x1, y1)
	for rect in pairs(get_cell(world, i, j)) do
		if overlaps(x0, y0, x1, y1, rect.x0, rect.y0, rect.x1, rect.y1) then
			if not queries[rect] then
				queries[rect] = true
			end
		end
	end
end


-- @note: does not use it from a different thread
function world:query_rect(x0, y0, w, h)
	local x1 = x0 + (w or 0)
	local y1 = y0 + (h or 0)

	-- clear previous queries
	-- @note: potential bug due to race condition
	for k in pairs(queries) do
		queries[k] = nil
	end

	-- populate the table with overlaps
	each_cell(self, x0, y0, x1, y1, find_overlaps)

	return pairs(queries)
end


function world:query_point(x, y)
	return self:query_rect(x, y)
end


return api