-- Copyright 2024 Banana Suit.
-- All rights over the code are reserved.
--
--
--      ███████╗██╗     ██╗      █████╗ ██████╗  █████╗
--      ██╔════╝██║     ██║     ██╔══██╗██╔══██╗██╔══██╗
--      █████╗  ██║     ██║     ██║  ██║██████╔╝███████║
--      ██╔══╝  ██║     ██║     ██║  ██║██╔══██╗██╔══██║
--      ███████╗███████╗███████╗╚█████╔╝██║  ██║██║  ██║
--      ╚══════╝╚══════╝╚══════╝ ╚════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
--         ____    ____  ____    ____  ____    ____ 
--        |    \  /    ||    \  /    ||    \  /    |
--        |  o  )|  o  ||  _  ||  o  ||  _  ||  o  |
--        |     ||     ||  |  ||     ||  |  ||     |
--        |  O  ||  _  ||  |  ||  _  ||  |  ||  _  |
--        |     ||  |  ||  |  ||  |  ||  |  ||  |  |
--        |_____||__|__||__|__||__|__||__|__||__|__|
--
--
-- This is our game's source code, before you start reading it, you need to understand some topics
-- 01 - we use OOP, but not in a religious way ¯\_(ツ)
-- 02 - global-readonly are fine, but only if fine...
-- 03 - everything is an entity, which is: displayable or logical being (or both)
-- 04 - naming conventions are simple: ClassType, instance_type, CONST_TYPE, function_type
-- 05 - all libraries are (and should be) single file


ENV_DEV = true

function love.conf(t)
    t.window.title = ""
    t.window.width = 1280
    t.window.height = 720
    t.window.vsync = false
    t.window.resizable = true
end
