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
-- 01 - we use OOP, but not in a religious way ¯\_(ツ)
-- 02 - global-readonly are fine, but only if fine...
-- 03 - everything is an entity, which is: displayable or logical being (or both)
-- 04 - naming conventions are simple: ClassType, instance_type, CONST_TYPE, function_type
-- 05 - all libraries are (and should be) single file


ENV_DEV = true

ORDER_SIMS = 1
ORDER_PLAYER = 2
ORDER_EMITTERS = 3
ORDER_DEBUG = 10

function love.conf(t)
    t.window.title = ""
    t.window.width = 960
    t.window.height = 540
    t.window.vsync = false
    t.window.resizable = true
end
