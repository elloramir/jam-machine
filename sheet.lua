-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local Object = require("classic")
local Sheet = Object:extend()

function Sheet:new(filename, fw, fh)
	self.img = love.graphics.newImage(filename)
	self.width = fw or self.img:getWidth()
	self.height = fh or self.img:getHeight()

	assert(self.img:getWidth()%self.width == 0)
	assert(self.img:getHeight()%self.height == 0)

	self.quads = {}
	for y=0, self.img:getHeight()-self.height, self.height do
		for x=0, self.img:getWidth()-self.width, self.width  do
			table.insert(self.quads,
				love.graphics.newQuad(x, y, self.width, self.height, self.img))
		end
	end
end

function Sheet:draw_index(index, ...)
	assert(index>0)
	local fixed_index = (index-1)%#self.quads+1
	love.graphics.draw(self.img, self.quads[fixed_index], ...)
end

return Sheet
