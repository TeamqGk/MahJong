-- debug output console showing
io.stdout:setvbuf("no")

release = false
dev = true
debug = true

-- Set Screen Mode
if release then
local width, height = love.window.getDesktopDimensions( display )
love.window.setMode(width, height)
love.window.maximize()
end

-- just a Classic Globals for use =)
globals = require("modules/globals")


-- Require modules here if is Global needed
SceneManager = require("modules/SceneManager")
LevelsManager = require("modules/LevelsManager")
SaveManager = require("modules/SaveManager")
QuadManager = require("modules/QuadManager") -- lua file
ImgManager = require("modules/ImgManager") -- lua file
GridManager = require("modules/GridManager") -- lua file





-- List alls scenes here
SceneGame = require("scenes/SceneGame")
SceneLogo = require("scenes/SceneLogo")
MaSceneVierge = require("scenes/SceneVierge")
-- etc.



--[[
SceneManager using for :
change file.lua actually use for
love.load()
love.draw,
and love.update etc...
]]
--[[
SceneManager:addScene(module, name, pSetActiveScene)
module "NomduFichierDelaScene".lua on ne mets pas l'extenesion .lua
name , using this name for change scene later
pSetActiveScene -- pour ajouter et mettre celle-ci directement..]]--
SceneManager:addScene(SceneGame, "SceneGame")
SceneManager:addScene(SceneLogo, "SceneLogo")
SceneManager:addScene(MaSceneVierge, "MaSceneTest")
--[[
Now the first scene loading is "SceneGame"
Hox to change Scene Later ? simply use this :
SceneManager:setScene(name)]]--
--

-- Set the first scene need to load
SceneManager:setScene("SceneLogo")


--
love.window.setTitle("MahJong [Mask & CryptoLogiq] TeamqGk.fr")

function love.load()
  SceneManager:load()
end

function love.update(dt)
  mouse.update(dt)
  screen.update(dt)
  SceneManager:update(dt)
end

function love.draw()
  SceneManager:draw() -- SceneGame:draw()
end


function love.keypressed(key, scancode)
  SceneManager:keypressed(key, scancode)
end
--

function love.keyreleased(key, scancode)
  SceneManager:keyreleased(key, scancode)
end
--

function love.mousepressed(x, y, button, isTouch)
  SceneManager:mousepressed(x, y, button, isTouch)
end
--

function love.mousereleased(x, y, button, isTouch)
  SceneManager:mousereleased(x, y, button, isTouch)
end
--

-- et c'est tout !
