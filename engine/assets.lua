-- Copyright 2024 Banana Suit.
-- All rights over the code are reserved.


local json = require("libs.json")
local lume = require("libs.lume")
local Sheet = require("engine.sheet")
local Sound = require("engine.sound")


local assets = {}


-- @note: i don't know if we want it to be accessible from outside,
-- but in general it doest not matter.
assets.loaded = {}
assets.folder = "assets"


local function recurse_load(path, callback)
    local items = love.filesystem.getDirectoryItems(path)

    for _, item in ipairs(items) do
        local item_path = path.."/"..item
        local info = love.filesystem.getInfo(item_path)

        if info.type == "file" then
            callback(item_path)
        elseif info.type == "directory" then
            recurse_load(item_path, callback)
        end
    end
end


function assets.init()
    assets.loaded["love_font"] = love.graphics.newFont(12)

    recurse_load(assets.folder, function(file)
        local ext = file:match(".+%.(.+)$")
        local name = file:sub(#assets.folder + 2, #file - #ext - 1)

        if ext == "png" then
            -- extract infos from image name.
            -- format is: "name_wxh.png"
            local w, h = name:match("_(%d+)x(%d+)")
            
            w = tonumber(w)
            h = tonumber(h)

            if w or h then
                name = name:gsub("_%d+x%d+", "")
            end
            
            assets.loaded[name] = Sheet(file, w, h)
        elseif ("tmj,json,tsj,tj"):find(ext) then
            local content = love.filesystem.read(file)
            local decoded = json.decode(content)

            assets.loaded[name] = decoded
        elseif ("ogg,mp3,wav"):find(ext) then 
            assets.loaded[name] = Sound(file)
        elseif ext == "ttf" then
            -- format is: "name_size.ttf"
            local size = name:match("_(%d+)$")

            size = tonumber(size) or 12
            name = name:gsub("_%d+$", "")

            assets.loaded[name] = love.graphics.newFont(file, size)
        elseif ext == "glsl" then
            assets.loaded[name] = love.graphics.newShader(file)
        end
    end)

    lume.trace(string.format("Loaded %d assets", lume.count(assets.loaded)))
end


function assets.get(name)
    return assets.loaded[name]
end


return assets