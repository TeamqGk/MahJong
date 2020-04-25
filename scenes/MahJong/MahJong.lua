local SceneMahJong = {}
----------------------------- START -----------------------------------------
-- Declare Global Tables of Game
Levels = {}
Grid = {}
Img = {}
MahJong = {}
local BM = BouttonManager.newBM()
local Boutton = {}
--
local AM = AudioManager.newAM()

local music_loop = AM:addMusic("scenes/MahJong/music/Mahjong_Theme_By_Hydrogene.mp3", true, 0.25, false)
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
  Boutton[1]:setPos(screen.w - (Boutton[1].w+10),10)
  Boutton[1]:setAction(function() SceneManager:setScene("MenuIntro"); music_loop:pause() end)
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


function SceneMahJong.mouseDraw()
  if debug then
    if mouse.onGrid then -- mouse.onGrid == true
      love.graphics.setColor(0,0,0,1)
      text = "L : "..mouse.l.."\n".."C : "..mouse.c
      love.graphics.print(text,mouse.x + 20,mouse.y - 20)
      love.graphics.setColor(1,1,1,1)
    end
  end
end

--

function SceneMahJong.mouseUpdate(dt)
  if mouse.x > Grid.x + 1 and mouse.x < Grid.x + Grid.w - 1 and mouse.y > Grid.y + 1 and mouse.y <= Grid.y + Grid.h - 1 then
    local col = math.floor((mouse.x - Grid.x) / Grid.caseW ) + 1
    local lig = math.floor((mouse.y - Grid.y) / Grid.caseH ) + 1
    mouse.c = col
    mouse.l = lig
    mouse.onGrid = true
    -- Grid.x = offsetX
    -- Grid.y = offsetY
    -- Grid.w = Grid.colonnes * Img.MahJong.quad.w
    -- Grid.h = Grid.lignes * Img.MahJong.quad.h
    -- Grid.caseW = Grid.w / Grid.colonnes
    -- Grid.caseH = Grid.h / Grid.lignes
  else
    mouse.onGrid = false
  end
  -- >
end

function SceneMahJong.load() -- love.load()
  screen.update(dt)
  --
  Boutton.init()
  --
  LevelsManager.autoload()
  --
  GridManager.setGrid(1)
end
--

function SceneMahJong.update(dt)
--  if music_loop then
  if not music_loop:isPlaying() then
    music_loop:play()
  end
--  end
  AM:update(dt)
  BM:update(dt)
  SceneMahJong.mouseUpdate(dt)
end
--

function SceneMahJong.draw()-- love.draw()
  GridManager.draw()
  SceneMahJong.mouseDraw()
  --
  BM:draw()
end
--

function SceneMahJong:keypressed(key, scancode)
  if debug then print(key) end
  --
  if debug then
    if key == "kp+" or key == "kp-" or key == "up" or key == "down" then
      local level = Grid.level
      if key == "kp+" or key == "up"  then
        level = level + 1
      elseif key == "kp-" or key == "down" then
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

function SceneMahJong.mousepressed(x, y, button, isTouch)
  if button == 1 then -- left clic
    if BM.current.ready then
      BM.current.action()-- example if bouton is Play then action is : SceneManager:setScene("MahJong")
    end
  end
end
--


---------------------------- END -----------------------------------------
return SceneMahJong
