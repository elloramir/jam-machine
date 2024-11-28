-- Copyright 2024 Banana Suit.
-- All rights over the code are reserved.


local game = require("engine.game")
local lume = require("libs.lume")
local Sprite = require("entities.sprite")


-- this class could be 100% separated from the sprite one,
-- but since we haven't multiple inheritance, we need to do it.
local Actor = Sprite:extend()


function Actor:new(x, y)
    Actor.super.new(self, x, y)

    self:set_tag("actor")

    self.speed_x = 0
    self.speed_y = 0
    self.restitution = 0
    self.normal_x = 0
    self.normal_y = 0
end

function Actor:enable_sort_y()
    self.should_sort_y = true
end


function Actor:set_shape(w, h, ox, oy, is_solid)
    self.width = w
    self.height = h
    self.offset_x = math.floor((ox or 0.5) * w)
    self.offset_y = math.floor((oy or 0.5) * h)
    self.is_solid = is_solid == nil and true or is_solid

    if self.has_shape then
        -- just update what we already have
        self:update_body()
    else
        -- create a body reference on world if not created yeat
        self.has_shape = true
        game.world:add(self, self:shape())
    end
end


function Actor:set_position(x, y)
    if x ~= self.x or y ~= self.y then
        self.x, self.y = x, y
        self:update_body()
        if self.should_sort_y then
            self:set_order(self:bottom())
        end
    end
end


function Actor:destruct()
    game.world:remove(self)
    self.has_shape = false
end


function Actor:contains_point(x, y)
    if not self.has_shape then
        return false
    end

    local x1, y1, x2, y2 = self:points()

    return x >= x1 and x <= x2 and y >= y1 and y <= y2
end


function Actor:points()
    return self.x, self.y, self.x + self.width, self.y + self.height
end


function Actor:corner()
    return self.x, self.y
end


function Actor:shape()
    return self.x, self.y, self.width, self.height
end


function Actor:center()
    return self.x + self.width/2, self.y + self.height/2
end


function Actor.filter(other, self, callback)
    -- we can also have a callback for immediate
    -- "check_overlaps" calls instead of the message system.
    if callback then
        callback(other)
    end

    -- they need to store the contact mutually, because
    -- since at least one of them updates the body, we could
    -- propagate the events to the other one too.
    self:update_contact(other)
    other:update_contact(self)
end


function Actor:overlaps(x, y, w, h)
    local x1, y1, x2, y2 = self:points()
    local x3, y3, x4, y4 = x, y, x + w, y + h

    return x1 < x4 and x2 > x3 and y1 < y4 and y2 > y3
end


function Actor:is_moving()
    return self.speed_x ~= 0 or self.speed_y ~= 0
end


function Actor:move(dt)
    if self:is_moving() then
        self.normal_x = 0
        self.normal_y = 0

        self.x = self.x + self.speed_x * dt
        self.y = self.y + self.speed_y * dt

        self:update_body()
    end
end


function Actor:update_body()
    if self.has_shape then
        game.world:update(self, self:shape())
        -- we need to notify the world we've changed position
        self:check_overlaps()
    end
end


-- @note: this has a potential memory leak when the list
-- never get updated and the actors inside has been destroyed.
function Actor:check_overlaps(callback)
    game.world:each(self, self.filter, self, callback)

    if self.body_contacts then
        -- lets now update who has exited
        for actor, is_overlaping in pairs(self.body_contacts) do
            if is_overlaping then
                -- mark it as false to know if it will gets "refreshed"
                self.body_contacts[actor] = false

                -- @todo: this should be here?
                if self.is_solid and actor.is_solid then
                    self:resolve_mtv(actor)
                end
            else
                -- we should remove it from both lists, because
                -- the "check_overlaps" could not being called from "other".
                self.body_contacts[actor] = nil
                actor.body_contacts[self] = nil

                self:emit("body_exit", actor)
                actor:emit("body_exit", self)
            end
        end
    end
end


function Actor:update_contact(other)
    if not self.body_contacts then
        self.body_contacts = { }
    end

    -- if is the first time we touch this actor
    if self.body_contacts[other] == nil then
        self:emit("body_enter", other)
    end

    -- the second and beyond should only "refresh" the contact
    self.body_contacts[other] = true
end


function Actor:is_grounded()
    return self.normal_y == -1
end


-- smallest vector that can be applied to
-- separate two overlapping rectangles
function Actor:resolve_mtv(other)
    local x1, y1, w1, h1 = self:shape()
    local x2, y2, w2, h2 = other:shape()

    local dx = x1 + w1/2 - x2 - w2/2
    local dy = y1 + h1/2 - y2 - h2/2

    local ox = w1/2 + w2/2 - math.abs(dx)
    local oy = h1/2 + h2/2 - math.abs(dy)

    if ox < oy then
        if dx > 0 then
            self.x = self.x + ox
        else
            self.x = self.x - ox
        end

        self.speed_x = self.speed_x * -self.restitution
        self.normal_x = dx > 0 and 1 or -1
    else
        if dy > 0 then
            self.y = self.y + oy
        else
            self.y = self.y - oy
        end

        self.speed_y = self.speed_y * -self.restitution
        self.normal_y = dy > 0 and 1 or -1
    end
end


function Actor:debug()
    if self.has_shape then
        love.graphics.setLineWidth(1)
        love.graphics.setColor(num_to_color(self.created_at, 0.8))
        love.graphics.rectangle("fill", self:shape())
    end
end


function Actor:cull(x, y, w, h)
    if self.image then
        return Actor.super.cull(self, x, y, w, h)
    end

    return self:overlaps(x, y, w, h)
end


function Actor:__tostring()
    return "Actor"
end


return Actor