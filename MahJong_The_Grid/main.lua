-- debug
io.stdout:setvbuf("no")

love.window.setTitle("TEST")

local text = "Ceci est un test, Monsieur !"

local x = 10
local y = 10

function love.load()
end

function love.update(dt)
end

function love.draw()
  love.graphics.print(text, x, y)--, r, sx, sy, ox, oy, kx, ky)
end
