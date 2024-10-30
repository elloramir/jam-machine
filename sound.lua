-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local tick = require("libs.tick")
local flux = require("libs.flux")
local Object = require("libs.classic")


local Sampler = Object:extend()
local Sound = Object:extend()


Sound.base_volume = 0.1
Sound.max_audio_stack = 10
Sound.tweens = flux.group()
Sound.timers = tick.group()


function Sampler:new(filename)
    self.raw = love.audio.newSource(filename, "static")
end


function Sampler:set_volume(volume)
    self.raw:setVolume(volume * Sound.base_volume)
end


function Sampler:set_state(state)
    if state then
        self.raw:play()
    else
        self.raw:stop()
    end
end


function Sampler:is_playing()
    return self.raw:isPlaying()
end


function Sampler:fade_in(duration, callback) 
    Sound.tweens:to(self, duration, {volume = self.raw:getVolume()}):oncomplete(callback)
end


function Sampler:fade_out(duration, callback)
    Sound.tweens:to(self, duration, {volume = 0}):oncomplete(callback)
end


-- sound has a collection of samplers, so we can play the
-- same sound multiple times without waiting for the previous
-- one to finish.
function Sound:new(filename)
    self.filename = filename
    self.bus = {}
end


function Sound.set_volume(volume)
    Sound.base_volume = volume
end


function Sound:play(volume)
    local sampler

    for _, smp_on_bus in ipairs(self.bus) do
        if not smp_on_bus:is_playing() then
            sampler = smp_on_bus
        end
    end

    if not sampler and #self.bus < Sound.max_audio_stack then
        sampler = Sampler(self.filename)
        table.insert(self.bus, sampler)
    end

    if not sampler then
        return
    end

    sampler:set_volume(volume)
    sampler:set_state(true)

    return sampler
end


return Sound