-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.
--
--      ███████╗██╗     ██╗      █████╗ ██████╗  █████╗
--      ██╔════╝██║     ██║     ██╔══██╗██╔══██╗██╔══██╗
--      █████╗  ██║     ██║     ██║  ██║██████╔╝███████║
--      ██╔══╝  ██║     ██║     ██║  ██║██╔══██╗██╔══██║
--      ███████╗███████╗███████╗╚█████╔╝██║  ██║██║  ██║
--      ╚══════╝╚══════╝╚══════╝ ╚════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
--
-- This is our game's source code, before you start reading it, you need to understand some topics
-- 01 - OOP sucks, but it's the only (decent) way to structure a game with Lua
--      (or any other dynamic typed language)
-- 02 - use OOP don't let OOP use you, in other words, don't be a grug developer
-- 03 - global-readonly are fine, but only if necessary... use common sense
-- 04 - everything in this game is a generic entity, that is, a table with an order and virtual methods.
--      Loop through it can be rough in a language like Lua. Be kind to the number of things on the screen...
-- 05 - we can work with multiple resolutions using canvas switches, but there is considerable effort for gpu
-- 06 - naming conventions are simple: ClassType, instance_type, CONST_TYPE, function_type
-- 07 - we only use the RXI libs (and hump sometimes)
-- 08 - this is a retro art style game, media is loaded once at game start...

WIDTH = 640
HEIGHT = 360
SCALE = 1

TILE_SIZE = 16

function love.conf(t)
	t.window.title = "sweeat heart"
	t.window.width = WIDTH
	t.window.height = HEIGHT
	t.window.vsync = false
	t.window.resizable = true
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
