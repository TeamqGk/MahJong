local Scene = {}

local text = "Ceci est un test, Monsieur !"

local x = 10
local y = 10

function Scene.load()
end

function Scene.update(dt)
end

function Scene.draw()
love.graphics.print(text, x, y)--, r, sx, sy, ox, oy, kx, ky)
end


return Scene
