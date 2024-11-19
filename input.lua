-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local baton = require("libs.baton")


return baton.new {
    controls = {
        debug  = { "key:tab" },
        quit   = { "key:escape" },

        left   = {"key:left", "key:a", "axis:leftx-", "button:dpleft"},
        right  = {"key:right", "key:d", "axis:leftx+", "button:dpright"},
        up     = {"key:up", "key:w", "axis:lefty-", "button:dpup"},
        down   = {"key:down", "key:s", "axis:lefty+", "button:dpdown"},

        shoot = {"mouse:1", "button:rightshoulder" },
        ui_action = { "button:a", "key:j", "key:return" },

        -- for joystick
        aim_left  = {"axis:rightx-"},
        aim_right = {"axis:rightx+"},
        aim_up    = {"axis:righty-"},
        aim_down  = {"axis:righty+"},
    },

    pairs = {
        move = {"left", "right", "up", "down"},
        aim  = {"aim_left", "aim_right", "aim_up", "aim_down"},
    },

    joystick = love.joystick.getJoysticks()[1],

    config = {
        deadzone = 0.1,
        joystick = true,
    },
}