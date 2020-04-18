-- debug output console showing
io.stdout:setvbuf("no")

-- just a Classic Globals for use =)
globals = require("globals")


--[[
 SceneManager using for :
 change file.lua actually use for
 love.load()
 love.draw,
 and love.update etc...
 ]]
Scene = require("SceneManager")
-- SceneManager:addScene(module, name, pSetActiveScene)
-- module "NomduFichierDelaScene".lua on ne mets pas l'extenesion .lua
-- name , using this name for change scene later
-- pSetActiveScene -- pour ajouter et mettre celle-ci directement..
SceneManager:addScene("SceneGame", "SceneGame", true)
--Now the first scene loading is "SCeneGame"
-- Hox to change Scene Later ? simply use this :
-- SceneManager:setScene(name)

--
love.window.setTitle("MahJong [Mask & CryptoLogiq] TeamqGk.fr")


function love.load()
  SceneManager.load()
end

function love.update(dt)
  SceneManager.update(dt)
end

function love.draw()
  SceneManager.draw()
end

-- et c'est tout !
