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
-- 04 - everything in this game is a generic entity, that is, a table with an order and virtual methods
-- 05 - naming conventions are simple: ClassType, instance_type, CONST_TYPE, function_type
-- 06 - we only use the single file libraries
-- 07 - all media is loaded once at game start

function love.conf(t)
	t.window.title = ""
	t.window.width = 960
	t.window.height = 540
	t.window.vsync = false
	t.window.resizable = true
end
