-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local level = {}

function level.load()
	level.entities = {}

	level.add_entity("world")
end

function level.add_entity(name, ...)
	local en = require("entities."..name)(...)
	assert(en.active)
	table.insert(level.entities, en)
end

local function sort_entities(a, b)
	return a.order < b.order
end

function level.update(dt)
	if math.random() > 0.7 then
		table.sort(level.entities, sort_entities)
	end

	-- loop entities in reverse order so we can remove them
	-- without indexing issues
	for i = #level.entities, 1, -1 do
		local en = level.entities[i]
		if en.active then
			en:update(dt)
		else
			table.remove(level.entities, i)
		end
	end
end

function level.draw()
	for _, en in ipairs(level.entities) do
		if en.active then en:draw() end
	end
end

function level.debug()
end

return level
