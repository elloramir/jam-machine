-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local Object = require("libs.classic")


local Emitter = Object:extend()


-- pub/sub system that we use to communicate between objects.
-- It's important to note that we only create the table when the first
-- subscriber is added, this way we save memory in lua.
function Emitter:emit(event, ...)
    if self.subscribers then
        local subs = self.subscribers[event]

        if subs then
            for k, callback in ipairs(subs) do
                -- unsubscribe if return true
                if callback(...) then
                    subs[k] = nil
                end
            end
        end
    end
end


function Emitter:on(event, callback)
    if not self.subscribers then
        self.subscribers = { }
    end

    if not self.subscribers[event] then
        self.subscribers[event] = { }
    end

    table.insert(self.subscribers[event], callback)
end


return Emitter