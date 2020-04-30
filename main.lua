-- debug output console showing
io.stdout:setvbuf("no")
-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then  require("lldebugger").start() end -- debug for Visual Code
-- ###############################################################################################################

local release = false
debug = true

-- Set Screen Mode
if release then
  local width, height = love.window.getDesktopDimensions()
  love.window.setMode(width, height)
end
--

-- just a Classic Globals for use =)
--socket = require("socket")
globals = require("modules/globals") -- lua file
lume = require("modules/lume") -- lib of many's help functions's (and this nice is serialize and deserialize)
require("modules/libSaveTableToFile") -- lib file


-- Require modules here if is Global needed
SceneManager = require("modules/SceneManager") -- lua file
BouttonManager = require ("modules/BouttonManager") -- lua file
SaveManager = require("modules/SaveManager") -- lua file
AudioManager = require("modules/audioManager") -- lua file
QuadManager = require("modules/QuadManager") -- lua file
ImgManager = require("modules/ImgManager") -- lua file
-- for Mahjong
LevelsManager = require("scenes/MahJong/modules/LevelsManager") -- lua file
GridManager = require("scenes/MahJong/modules/GridManager") -- lua file
SaveMahJongManager = require("scenes/MahJong/modules/SaveMahJongManager") -- lua file



-- List alls scenes require here
SceneLogoIntro = require("scenes/SceneIntro")
SceneMenuIntro = require("scenes/MenuIntro")
--
SceneSelectGame = require("scenes/SelectGame")
SceneOptions = require("scenes/SceneOptions")
SceneCredits = require("scenes/SceneCredits")
--
SceneMahJong = require("scenes/MahJong/MahJong")
SceneCasseBrique = require("scenes/CasseBrique/CasseBrique")
Scene25D = require("scenes/25D_beta/25D")
-- etc.


local controls = {} -- controls for windows (fullscreen, quit prompt, etc)
controls.lctrl = false


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
-- le menu d'intro
SceneManager:addScene(SceneLogoIntro, "SceneIntro")
SceneManager:addScene(SceneMenuIntro, "MenuIntro")
-- le menu de selections des jeux
SceneManager:addScene(SceneSelectGame, "SelectGame")
SceneManager:addScene(SceneOptions, "Options")
SceneManager:addScene(SceneCredits, "Credits")
-- les jeux
SceneManager:addScene(SceneMahJong, "MahJong")
SceneManager:addScene(SceneCasseBrique, "CasseBrique")
SceneManager:addScene(Scene25D, "Scene25D")

--[[
Now the first scene loading is "SceneGame"
Hox to change Scene Later ? simply use this :
SceneManager:setScene(name)]]--
--

-- Set the first scene need to load
SceneManager:setScene("SceneIntro")



--------------------------------------------------
local AMmain = AudioManager.newAM()
Sounds = {}
Sounds.volume = 0.5
--
Sounds.one = AMmain:addSound("sounds/one.ogg", false, Sounds.volume)
Sounds.two = AMmain:addSound("sounds/two.ogg", false, Sounds.volume)
Sounds.three = AMmain:addSound("sounds/three.ogg", false, Sounds.volume)
Sounds.congratulations = AMmain:addSound("sounds/congratulations.ogg", false, Sounds.volume)
Sounds.final_round = AMmain:addSound("sounds/final_round.ogg", false, Sounds.volume)
Sounds.game_over = AMmain:addSound("sounds/game_over.ogg", false, Sounds.volume)
Sounds.go = AMmain:addSound("sounds/go.ogg", false, Sounds.volume)
Sounds.level = AMmain:addSound("sounds/level.ogg", false, Sounds.volume)
Sounds.level_up = AMmain:addSound("sounds/level_up.ogg", false, Sounds.volume)
Sounds.new_highscore = AMmain:addSound("sounds/new_highscore.ogg", false, Sounds.volume)
Sounds.power_up = AMmain:addSound("sounds/power_up.ogg", false, Sounds.volume)
Sounds.ready = AMmain:addSound("sounds/ready.ogg", false, Sounds.volume)
Sounds.you_lose = AMmain:addSound("sounds/you_lose.ogg", false, Sounds.volume)
Sounds.you_win = AMmain:addSound("sounds/you_win.ogg", false, Sounds.volume)
--
Sounds.LogoIntro = AMmain:addMusic("sounds/LogoIntro.mp3", false, 1, true) -- addMusic(pFile, pLoop, pVolume, pPlay)
Sounds.Digital_Number_FX = AMmain:addMusic("sounds/Digital_Number_FX.mp3", false, 1, false) -- addMusic(pFile, pLoop, pVolume, pPlay)
--------------------------------------------------



function love.load()
  SceneManager:load()
end
--
function love.update(dt)
  AMmain:update(dt)
  --
  mouse:update(dt)
  screen:update(dt)
  --
  SceneManager:update(dt)
end
--
function love.draw()
  SceneManager:draw() -- SceneGame:draw()
end
--

function love.keypressed(key, scancode)
  if key == "lctrl" then
    controls.lctrl = true
  end
  if controls.lctrl then
    if key == "f12" then
      love.event.quit()
    elseif key == "d" then
      debug = not debug
    end
  end
  SceneManager:keypressed(key, scancode)
end
--

function love.keyreleased(key, scancode)
  SceneManager:keyreleased(key, scancode)
  if key == "lctrl" then
    controls.lctrl = false
  end
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
