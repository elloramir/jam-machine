-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local assets = require("assets")
local game = require("game")
local lume = require("libs.lume")
local view = require("view")
local Entity = require("entity")


local Terminal = Entity:extend()


local speed = 20
local colors = {
    ["info"] = {0.3, 1, 0.2},
    ["warn"] = {1, 1, 0.3},
    ["error"] = {1, 0.2, 0.3},
}


function Terminal:new()
    Terminal.super.new(self)
    
    self:mark_as_permanent()
    self:mark_as_ui()
    self:set_order(ORDER_UI)
    self:set_visible(false)

    self.is_open = false
    self.input_content = ""
    self.height = 150
    self.offset_y = self.height
    self.log = {}

    self.commands = {}

    self.commands["clear"] = function(self)
        self.log = {}
    end

    self.commands["help"] = function(self)
        for command in pairs(self.commands) do
            self:log_message(command, "info")
        end
        self:log_message("Available commands:", "warn")
    end

    self.commands["motion"] = function(self, value)
        game.motion = tonumber(value) or 1
    end
end


function Terminal:update(dt)
    -- make terminal immune to game motion
    dt = 1/game.motion * dt

    if self.is_open then
        self.offset_y = lume.lerp(self.offset_y, 0, speed*dt)
        self:set_visible(true)
    elseif self.is_visible then
        self.offset_y = lerpf(self.offset_y, self.height, speed*dt)
        if self.offset_y > self.height - 1 then
            self:set_visible(false)
        end
    end
end


function love.textinput(key)
    print(Terminal:first())
    Terminal:first():textinput(key)
end


function love.keypressed(key)
    print(Terminal:first())
    Terminal:first():keypressed(key)
end


function Terminal:keypressed(key)
    if self.is_visible then
        -- erase last character
        if key == "backspace" then
            -- clear all when ctrl is pressed
            if love.keyboard.isDown("lctrl") then
                self.input_content = ""
            else
                self.input_content = self.input_content:sub(1, -2)
            end
        elseif key == "return" and #self.input_content > 0 then
            self:execute_command(self.input_content)
            self.input_content = ""
        end
    end

    -- toggle terminal visibility
    if key == "f1" then
        self.is_open = not self.is_open
    end
end


function Terminal:textinput(key)
    if self.is_visible then
        self.input_content = self.input_content .. key
    end
end


function Terminal:log_message(message, type)
    local color = colors[type] or colors.info
    local text = string.format("[%s] %s", type, message)

    table.insert(self.log, { color, text })
end


function Terminal:execute_command(input)
    local tokens = lume.split(input, " ")
    local head = tokens[1]
    local args = {unpack(tokens, 2)}
    local command = self.commands[head]

    if command then
        command(self, unpack(args))
    else
        self:log_message("Unknown command: " .. input, "error")
    end
end


function Terminal:draw()
    local w, h = view.size("ui")
    local th = self.height -- terminal height
    local y = h - th + self.offset_y

    -- terminal background
    love.graphics.setColor(0, 0.5, 0.5, 0.5)
    love.graphics.rectangle("fill", 0, y, w, th)
    love.graphics.setFont(assets.get("fonts/debug"))

    -- last log messages
    for i = 1, 8 do
        local log = self.log[#self.log - i + 1]
        local y = y + 15 * i - 10

        if log then
            love.graphics.setColor(log[1])
            love.graphics.print(log[2], 5, y)
        end
    end

    -- input cursor
    do
        local cursor = "> " .. self.input_content

        if time_now() % 1 < 0.5 then
            cursor = cursor .. "_"
        end

        -- background
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 0, y + th - 20, w, 20)

        love.graphics.setColor(1, 1, 1)
        love.graphics.print(cursor, 5, y + th - 17)
    end
end


return Terminal