-- debug
io.stdout:setvbuf("no")

Scene = require("Scene")

love.window.setTitle("TEST")


function love.load()
  Scene.load()
end

function love.update(dt)
  Scene.update(dt)
end

function love.draw()
  Scene.draw()
end
