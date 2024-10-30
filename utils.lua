-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

function num_to_color(i, a, m)
    local v = 1610612741

    v = (v * i) % 0xFFFFFF
    v = (v * 0x10001) % 0xFFFFFF
    v = (v * 0x10001) % 0xFFFFFF
    v = v % 0xFFFFFF

    local r = (math.floor(v / 0x10000) % 0x100) / 255
    local g = (math.floor(v / 0x100) % 0x100) / 255
    local b = (v % 0x100) / 255

    return r * m, g * m, b * m, (a or 1)
end


function rgba(r, g, b, a)
    return r/255, g/255, b/255, a or 1
end


function approach(v1, v2, t)
    return v1 < v2 and math.min(v1 + t, v2) or math.max(v1 - t, v2)
end


function normalize(v, min, max)
    return (v - min) / (max - min)
end


function rand_float(min, max)
    return min + math.random() * (max - min)
end


function rand_bool()
    return math.random() < 0.5
end


function chance(amount)
    return math.random() < (amount / 100)
end


function lerpf(a, b, t)
    return a + (b - a) * t
end


function txt_outline(text, x, y, ...)
    love.graphics.printf(text, x - 1, y - 1, ...)
    love.graphics.printf(text, x + 1, y - 1, ...)
    love.graphics.printf(text, x - 1, y + 1, ...)
    love.graphics.printf(text, x + 1, y + 1, ...)
    love.graphics.printf(text, x, y - 1, ...)
    love.graphics.printf(text, x, y + 1, ...)
    love.graphics.printf(text, x - 1, y, ...)
    love.graphics.printf(text, x + 1, y, ...)
end


function txt_outline_bw(text, x, y, ...)
    love.graphics.setColor(rgba(52, 38, 52))
    txt_outline(text, x, y, ...)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(text, x, y, ...)
end


function hash2d(x, y)
    return x + y * 1e7
end


function vector_dst(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1

    return math.sqrt(dx * dx + dy * dy)
end


function vector_unit(x, y)
    local d = vector_dst(0, 0, x, y)

    if d == 0 then
        return 0, 0
    end

    return x / d, y / d
end


function roundf(v)
    return math.floor(v + 0.5)
end


function time_now()
    return love.timer.getTime()
end


function is_time_up(past, rate)
    return (time_now() - past) >= rate
end


function rand_dir()
    return rand_bool() and 1 or -1
end