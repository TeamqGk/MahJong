local SceneGame = {}
----------------------------- START -----------------------------------------
-- Declare Global Tables of Game
Levels = {}
Grid = {}
Img = {}
MahJong = {}
local BM = BouttonManager.newBM()
local Boutton = {}
--
local SaveGame = {}
--

function Boutton.init()
  BM:setDimensions(screen.w * 0.2, screen.h * 0.05)
  BM:setColor(0,1,0,0.15)
  BM:setColorText(0,0,0,0.75)
  BM:setColorMouseOver(0,0,1,0.15)
  --
  Boutton[1] = BM.newBox ()
  Boutton[1]:addText(Font[22], "Menu")
  Boutton[1]:setAction(function() SceneManager:setScene("MenuIntro") end)
  --
end
--

-- Images
Img.MahJong = ImgManager.new("scenes/MahJong/img/mahjong_pieces_modif_1.png")-- pFile
--[[ return :
img.img
img.w
img.h
]]--

-- Quads Images
Img.MahJong.quad = QuadManager.new(Img.MahJong,3,16)--ImageTable, Plig, pCol
-- quad 1 to 37 Mahjong
-- and quads 38 & 39 Effects styles...
-- sets parametres of MahJong (look image of quads for help)
MahJong.total = 37
MahJong.vide = 38
MahJong.videmini = 39




function SceneGame.load() -- love.load()
  screen.update(dt)
  --
  Boutton.init()
  --
  LevelsManager.autoload()
  --
  GridManager.setGrid(1)
end
--

function SceneGame.update(dt)
  BM:update(dt)
end
--

function SceneGame.draw()-- love.draw()
--  love.graphics.scale(screen.sx, screen.sy)
  GridManager.draw()
  BM:draw()
--  Boutton[1]:draw()
end
--

function SceneGame:keypressed(key, scancode)
  if debug then print(key) end
  --
  if debug then
    if key == "kp+" or key == "kp-" then
      local level = Grid.level
      if key == "kp+" then
        level = level + 1
      elseif key == "kp-" then
        level = level - 1
      end
      --
      if level > #Levels then level = 1 elseif level < 1 then level = #Levels end
      --
      GridManager.setGrid(level)
    end
    if key == "delete" then -- suppr
      GridManager.resetLevel(Grid.level)
    end
  end
  if key == "escape" then
    SceneManager:setScene("MenuIntro")
  end
end
--


---------------------------- END -----------------------------------------
return SceneGame
