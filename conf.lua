-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

WIDTH = 640
HEIGHT = 360
SCALE = 1

function love.conf(t)
	t.window.title = "sweeat heart"
	t.window.width = WIDTH
	t.window.height = HEIGHT
	t.window.resizable = true
	t.window.vsync = false
end

function sign(x)
	return x == 0 and 0 or (x > 0 and 1 or -1)
end

function random_dir()
	return math.random() < 0.5 and -1 or 1
end

function rand_bool()
	return math.random() < 0.5
end

function rand_float(lower, greater)
    return lower + math.random()  * (greater - lower);
end
