-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local Object = require("libs.classic")


local Entity = Object:extend()


function Entity:new(order)
	self.created_at = love.timer.getTime() / 1e9
	self.is_alive = true -- delete this entity in the next frame
	self.is_visible = true -- ignore this entity in the draw loop
	self.is_active = true -- ignore this entity in the update loop

    -- linked list used to search entities
    if not self.__index.first then
        self.__index.first = self
        self.__index.last = self
    else
        self.__index.last.right = self
        self.left = self.__index.last
        self.__index.last = self
    end

	self:set_order(order or 0)
end


function Entity:enable_sort_y()
	self.should_sort_y = true
end


-- this function is used on the y-sort
function Entity:bottom()
	error("not overriden")
end


function Entity:set_order(order)
	self.order = order + self.created_at
end


local function iter(self, current)
	return current.right
end


function Entity:iter()
	return iter, self.__index.first
end


-- since we use flags to mark entities as unactive,
-- we need to wait the next frame until the entity get real destroyed.
-- There are cases where the entity is flagged as "kill" before it execution,
-- so in that case the entity will be destroyed at same frame. 
function Entity:destroy()
	self.is_alive = false

	-- update linked list
	if self.left then
		self.left.right = self.right
	else
		self.__index.first = self.right
	end

	if self.right then
		self.right.left = self.left
	else
		self.__index.last = self.left
	end
end


-- pub/sub system that we use to communicate between entities.
-- It's important to note that we only create the table when the first
-- subscriber is added, this way we save memory in lua.
function Entity:emit(event, ...)
	if self.subscribers then
		local subs = self.subscribers[event]

		if subs then
			for _, callback in ipairs(subs) do
				callback(self, ...)
			end
		end
	end
end


function Entity:on(event, callback)
	if not self.subscribers then
		self.subscribers = { }
	end

	if not self.subscribers[event] then
		self.subscribers[event] = { }
	end

	table.insert(self.subscribers[event], callback)
end


function Entity:update(dt)
end


function Entity:draw()
end


function Entity:destruct()
end

return Entity