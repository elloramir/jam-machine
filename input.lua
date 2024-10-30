-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local baton = require("libs.baton")


return baton.new {
    controls = {
        debug  = { "key:tab" },
        quit   = { "key:escape" },

        left   = {"key:left", "key:a", "axis:leftx-", "button:dpleft"},
        right  = {"key:right", "key:d", "axis:leftx+", "button:dpright"},

        jump  = {"key:j", "button:a", "key:space"},
 
        fire = {"mouse:1"},
    },
}