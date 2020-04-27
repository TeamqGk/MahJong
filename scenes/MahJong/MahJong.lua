local SceneMahJong = {}
----------------------------- START -----------------------------------------
-- Declare Global Tables of Game
Levels = {}
Grid = {}
Img = {}
MahJong = {}
--
local BM = BouttonManager.newBM()
local Boutton = {}
--
local AM = AudioManager.newAM()
local sound_mahjongFind = AM:addSound("scenes/MahJong/sound/mahjong_find.wav", false, 0.4)
local sound_mahjongNotFind = AM:addSound("scenes/MahJong/sound/mahjong_notfind.wav", false, 0.4)

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
--

function mouse.selectInit()
  mouse.select = {}
  for i = 1, 2 do
    mouse.select[i] = {l=0, c=0, e=0, select = false, mahjong = 0}
  end
end
--

function mouse.selectMahjong()
  local l = mouse.l
  local c = mouse.c
  local e = 0
  local s = mouse.select

  -- annulation si col et lig sont identiques
  for i=1, 2 do
    if s[i].l == l and s[i].c == c then
      local cancel = s[i]
      Grid[cancel.e][cancel.l][cancel.c].select = false
      --
      cancel.select = false
      cancel.l = 0
      cancel.c = 0
      cancel.e = 0
      cancel.mahjong = 0
      return false -- on arrete la fucntion si on viens d'enlever une selection
    end
  end
  --

  -- on test la case :
  for i = Grid.etages, 1, -1 do
    if e == 0 then
      local case = Grid[i][l][c]
      if case.isActive then
        e = i
      end
    end
  end
  if e == 0 then return end  -- pas de mahjong ici !
  --

  -- on a l'etage , la ligne et la colonne, il nous faut mémoriser cette selection :
  local add = false
  for i = 1, 2 do
    if add == false then
      local addMe = s[i]
      if addMe.select == false then
        local case = Grid[e][l][c]
        --
        addMe.select = true
        addMe.l = l
        addMe.c = c
        addMe.e = e
        addMe.mahjong = case.mahjong
        --
        case.select = true
        --
        add = true
        if debug then print("ajout de la selection ".."[e:"..e.."]".."[l:"..l.."]".."[c:"..c.."]".." dans mouse.select["..i.."]") end
      end
    end
  end
  --

  -- nous avons deux selections on test donc si ils sont identiques :
  if s[1].select and s[2].select then
    if s[1].mahjong >= 1 and s[2].mahjong >= 1 then
      if s[1].mahjong == s[2].mahjong then -- Youhou !
        local case_1 = Grid[s[1].e][s[1].l][s[1].c]
        local case_2 = Grid[s[2].e][s[2].l][s[2].c]
        --
        case_1.isActive = false
        case_1.select = false
        --
        case_2.isActive = false
        case_2.select = false
        --
        local cancel_1 = s[1]
        local cancel_2 = s[2]
        --
        cancel_1.l = 0
        cancel_1.c = 0
        cancel_1.e = 0
        cancel_1.mahjong = 0
        cancel_1.select = false
        --
        cancel_2.l = 0
        cancel_2.c = 0
        cancel_2.e = 0
        cancel_2.mahjong = 0
        cancel_2.select = false
        --
        Grid.mahjongTotal = Grid.mahjongTotal - 2
        --
        sound_mahjongFind:stop()
        sound_mahjongFind:play()
        --
        if debug then print("un Double de Mahjong a été trouvé, il reste "..Grid.mahjongTotal.." mahjong(s) en jeu") end
        --
        return true
      end
    end
  end

  -- si on arrive ici c'est que la selection est fausse :
  if s[1].select and s[2].select then
    -- dans tous les cas si on a deux selections on les déselectionne
    local case_1 = Grid[s[1].e][s[1].l][s[1].c]
    local case_2 = Grid[s[2].e][s[2].l][s[2].c]
    --
    case_1.isActive = true
    case_1.select = false
    --
    case_2.isActive = true
    case_2.select = false
    --
    local cancel_1 = s[1]
    local cancel_2 = s[2]
    --
    cancel_1.l = 0
    cancel_1.c = 0
    cancel_1.e = 0
    cancel_1.mahjong = 0
    cancel_1.select = false
    --
    cancel_2.l = 0
    cancel_2.c = 0
    cancel_2.e = 0
    cancel_2.mahjong = 0
    cancel_2.select = false
    --
    sound_mahjongNotFind:stop()
    sound_mahjongNotFind:play()
    --
  end
  return false
end
--

function SceneMahJong.testVictory()
  if Grid.mahjongTotal == 0 and Grid.impaire == false or Grid.mahjongTotal == 1 and Grid.impaire == true then
    if debug then print("NIVEAU SUIVANT : "..(Grid.level + 1).."/"..#Levels) end
    mouse.selectInit()
    GridManager.setGrid(Grid.level + 1)
  end
end
--

function SceneMahJong.load() -- love.load()
  mouse.selectInit()
  --
  screen.update(dt)
  --
  Boutton.init()
  --
  LevelsManager.autoload()
  --
  GridManager.setGrid(3)
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
  if not mouse.onGrid then
    if button == 1 then -- left clic
      if BM.current.ready then
        BM.current.action()-- example if bouton is Play then action is : SceneManager:setScene("MahJong")
      end
    end
  end
  if mouse.onGrid then
    if button == 1 then -- left clic
      if mouse.selectMahjong() then
        SceneMahJong.testVictory()
      end
    end
  end
end
--


---------------------------- END -----------------------------------------
return SceneMahJong
