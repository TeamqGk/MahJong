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

local resetMahjongs = ImgManager.new("scenes/MahJong/img/resetLevel.png")
resetMahjongs:scaleToScreen()


local ChangeLevel = require("scenes/MahJong/ChangeLevel")

local Loosetimer = {}
function Loosetimer.init()
  Loosetimer.load = true
  Loosetimer.start = 0
  Loosetimer.finish = 30
  Loosetimer.speed = 60
  Loosetimer.ready = false
end
--

function Boutton.init()
  BM:setDimensions(screen.w * 0.15, screen.h * 0.05)
  BM:setColor(0,1,0,0.15)
  BM:setColorText(0,0,0,0.75)
  BM:setColorMouseOver(0,0,1,0.15)
  --
  Boutton[1] = BM.newBox ()
  Boutton[1]:addText(Font, 22, "Timer")
  Boutton[1]:setPos(10, 10)
  Boutton[1]:setEffect(false)
  Boutton[1]:setAction(function() SceneMahJong.pause = not SceneMahJong.pause; music_loop:pause() end)
  --
  Boutton[2] = BM.newBox ()
  Boutton[2]:addText(Font, 22, "Reset Level")
  Boutton[2]:setPos(Boutton[1].x + Boutton[1].w + 10, 10)
  Boutton[2]:setEffect(false)
  Boutton[2]:setAction(function() SceneMahJong.resetWait = true ; Boutton[3]:setVisible(true) ; Boutton[4]:setVisible(true) end)
  --
  Boutton[3] = BM.newBox ()
  Boutton[3]:addText(Font, 22, "Oui")
  Boutton[3]:setPos(screen.w * 0.5 - (Boutton[3].w+10), screen.oy)
  Boutton[3]:setVisible(false)
  Boutton[3]:setAction(function() SceneMahJong.resetWait = false ; SceneMahJong.pause = false ; Boutton[3]:setVisible(false) ; Boutton[4]:setVisible(false) ; GridManager.resetLevel(Grid.level) end)
  --
  Boutton[4] = BM.newBox ()
  Boutton[4]:addText(Font, 22, "Non")
  Boutton[4]:setPos(screen.w * 0.5 + 10, screen.oy)
  Boutton[4]:setVisible(false)
  Boutton[4]:setAction(function() SceneMahJong.resetWait = false ; Boutton[3]:setVisible(false) ; Boutton[4]:setVisible(false)  end)
  --  
  --
  Boutton[5] = BM.newBox ()
  Boutton[5]:addText(Font, 22, "Level : 0")
  Boutton[5]:setPos(Boutton[2].x + Boutton[2].w + 10,10)
  Boutton[5]:setEffect(false)
--  Boutton[5]:setAction(function() end)
  --
  Boutton[6] = BM.newBox ()
  Boutton[6]:addText(Font, 22, "Options")
  Boutton[6]:setPos(Boutton[5].x + Boutton[2].w + 10,10)
  Boutton[6]:setEffect(false)
  Boutton[6]:setAction(function() SceneMahJong.pause = not SceneMahJong.pause; ChangeLevel.show = not ChangeLevel.show; ChangeLevel.current = SaveMahJong.currentLevel  end)
  --
  Boutton[7] = BM.newBox ()
  Boutton[7]:addText(Font, 22, "Move : ")
  Boutton[7]:setPos(Boutton[6].x + Boutton[2].w + 10,10)
  Boutton[7]:setEffect(false)
--  Boutton[6]:setAction(function() end)
  --
  Boutton[8] = BM.newBox ()
  Boutton[8]:addText(Font, 22, "Menu")
  Boutton[8]:setPos(screen.w - (Boutton[1].w+10),10)
  Boutton[8]:setAction(function() SceneManager:setScene("MenuIntro"); music_loop:pause() end)
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
      if case.isActive and case.isMove then
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
        GridManager.testMoveMahjong()
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

function SceneMahJong.testVictory(dt)
  if Grid.mahjongTotal == 0 and Grid.impaire == false or Grid.mahjongTotal == 1 and Grid.impaire == true then

    -- WIN !
    mouse.selectInit() -- reset
    --
    SceneMahJong.saveVictory() -- save and update
    --
    GridManager.setGrid(SaveMahJong.currentLevel) -- load next Grid
    --
  elseif Grid.Move == 0 then -- Loose =(
    --
    Loosetimer.init()
    --
  end
end
--

function SceneMahJong.saveVictory()
  timer.run = false
  --
  local current = SaveMahJong.level[SaveMahJong.currentLevel]
  current.currentTime = timer.diff
  if current.currentTime < current.bestTime or  current.bestTimeText == "level not clear" then
    if current.bestTimeText == "level not clear"  then
      if Grid.soundClear then
        if Sounds[Grid.soundClear] then
          Sounds[Grid.soundClear]:stop()
          Sounds[Grid.soundClear]:play()
        end
      else
        Sounds.congratulations:stop() ; Sounds.congratulations:play()
      end
    else
      Sounds.new_highscore:stop();Sounds.new_highscore:play()
    end
    --
    current.bestTime = current.currentTime 
    current.bestTimeText = timer.text
  else
    if Grid.soundClear then
      if Sounds[Grid.soundClear] then
        Sounds[Grid.soundClear]:stop()
        Sounds[Grid.soundClear]:play()
      end
    else
      Sounds.congratulations:stop() ; Sounds.congratulations:play()
    end
  end
  timer.reset()
  --
  SaveMahJong.currentLevel = SaveMahJong.currentLevel + 1
  if SaveMahJong.currentLevel > #Levels then
    SaveMahJong.currentLevel = #Levels
  end
  if SaveMahJong.levelMax < SaveMahJong.currentLevel then SaveMahJong.levelMax = SaveMahJong.currentLevel end
  SaveManager.saveGame("SaveMahJong", SaveMahJong)
  if debug then
    print(" la table SaveMahJong.save contient :")
    for k, v in pairs(SaveMahJong) do
      print(k.." : "..tostring(v))
    end
  end
end
--

function SceneMahJong.timer(dt)
  Boutton[1]:setText(timer.text )
  if Grid.Move == 0 then
    if not Loosetimer.load then Loosetimer.init() end
    if not Loosetimer.ready then
      Loosetimer.start = Loosetimer.start + Loosetimer.speed * dt
      if Loosetimer.start >= Loosetimer.finish then
        Loosetimer.ready = true
        --
        Sounds.you_lose:stop();Sounds.you_lose:play()
        --
        SceneMahJong.resetWait = true
        Boutton[3]:setVisible(true)
        Boutton[4]:setVisible(true)
        --
      end
    end
  end
end
--


function SceneMahJong.backgroundWaitDraw()
  Img.BG:draw()
  love.graphics.setColor(0,0,0,0.90)
  love.graphics.rectangle("fill",0,0,screen.w,screen.h)
  love.graphics.setColor(1,1,1,1)
end
--

function SceneMahJong.load() -- love.load()
  love.graphics.setBackgroundColor(0.412,0.412,0.412,1)
--
  LevelsManager.autoload()
  --
  SceneMahJong.resetWait = false
  SceneMahJong.pause = false
  --
  SaveMahJongManager.load()
  --
  mouse.selectInit()
  --
  Boutton.init()
  --
  GridManager.setGrid(SaveMahJong.currentLevel)
  --
  ChangeLevel.load()
end
--

function SceneMahJong.update(dt)
  if Sounds.GPR_Beat_Katana:isPlaying() then Sounds.GPR_Beat_Katana:stop() end
  --
  if not SceneMahJong.resetWait and not SceneMahJong.pause then
    if not music_loop:isPlaying() then
      music_loop:play()
    end
--  end
    AM:update(dt)
    SceneMahJong.mouseUpdate(dt)
    timer.update(dt)
  end
  SceneMahJong.timer(dt)
  --
  Boutton[5]:setText("Level : "..SaveMahJong.currentLevel)
  Boutton[7]:setText("Move : "..Grid.Move)
  --
  BM:update(dt)
  --
  ChangeLevel.update(dt)
end
--

function SceneMahJong.draw()-- love.draw()
  if not SceneMahJong.resetWait and not SceneMahJong.pause then
    GridManager.draw()
    SceneMahJong.mouseDraw()
  elseif SceneMahJong.resetWait then
    SceneMahJong.backgroundWaitDraw()
    resetMahjongs:draw()
  elseif SceneMahJong.pause then
    SceneMahJong.backgroundWaitDraw()
    love.graphics.print("PAUSE", screen.ox, screen.oy)
  end
  if ChangeLevel.show then
    SceneMahJong.backgroundWaitDraw()
    ChangeLevel.draw()
  end
  --
  BM:draw()
end
--

function SceneMahJong:keypressed(key, scancode)
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
      GridManager.setGrid(level)

    end
  end
  if key == "delete" then -- suppr
    GridManager.resetLevel(Grid.level)
  end
  if key == "f1" then
    for i = 1, #Levels do
    SaveMahJong.currentLevel = i
    SceneMahJong.saveVictory()
    end
    GridManager.setGrid(1)
  end
  --
  if key == "escape" then
    if SceneMahJong.pause or SceneMahJong.resetWait or ChangeLevel.show then
      SceneMahJong.pause = false
      ChangeLevel.show = false
      SceneMahJong.resetWait = false
      Boutton[3]:setVisible(false)
      Boutton[4]:setVisible(false)
      music_loop:play()
    else
      SceneManager:setScene("MenuIntro")
      music_loop:stop()
    end
  end
end
--

function SceneMahJong.mousepressed(x, y, button, isTouch)
  --
  if not mouse.onGrid then
    if button == 1 then -- left clic
      if BM.current.ready then
        BM.current.action()-- example if bouton is Play then action is : SceneManager:setScene("MahJong")
      end
    end
  end
  --
  if mouse.onGrid then
    if button == 1 then -- left clic
      if mouse.selectMahjong() then
        SceneMahJong.testVictory()
      end
    end
  end
  --
  if ChangeLevel.show then
    ChangeLevel.mousepressed(x, y, button, isTouch)
  end
end
--


---------------------------- END -----------------------------------------
return SceneMahJong
