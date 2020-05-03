local ChangeLevel = {}
--
--
local ChangeLevelBM = BouttonManager.newBM()
local Boutton = {}
--
local AM = AudioManager.newAM()
local sound_clic = AM:addSound("scenes/MahJong/sound/clic.wav", false, 0.4)
--
local fenetre = {}
local fenetreText = {}
--

local lg = love.graphics

function Boutton.init()
  ChangeLevelBM:setDimensions(screen.w * 0.15, screen.h * 0.05)
  ChangeLevelBM:setColor(0,1,0,0.15)
  ChangeLevelBM:setColorText(0,0,0,0.75)
  ChangeLevelBM:setColorMouseOver(0,0,1,0.15)
  --
  Boutton[1] = ChangeLevelBM.newBox ()
  Boutton[1]:addText(Font, 22, "-")
  Boutton[1]:setPos(fenetre.x + 10, fenetre.y + 10)
  Boutton[1]:setEffect(false)
  Boutton[1]:setAction(function() sound_clic:stop(); sound_clic:play(); ChangeLevel.limit(-1) end)
  --
  Boutton[2] = ChangeLevelBM.newBox ()
  Boutton[2]:addText(Font, 22, tostring("Level : "..ChangeLevel.current))
  Boutton[2]:setEffect(false)
  Boutton[2]:setPos(Boutton[1].x + Boutton[1].w + 10, fenetre.y + 10)
  --
  Boutton[3] = ChangeLevelBM.newBox ()
  Boutton[3]:addText(Font, 22, "+")
  Boutton[3]:setEffect(false)
  Boutton[3]:setPos(Boutton[2].x + Boutton[2].w + 10, fenetre.y + 10)
  Boutton[3]:setAction(function()  sound_clic:stop(); sound_clic:play(); ChangeLevel.limit(1) end)
  --
  Boutton[4] = ChangeLevelBM.newBox ()
  Boutton[4]:addText(Font, 22, "Aller a ce Niveau")
  Boutton[4]:setPos(Boutton[3].x + Boutton[3].w + 10, fenetre.y + 10)
  Boutton[4]:setAction(function()  sound_clic:stop(); sound_clic:play(); if ChangeLevel.current ~= SaveMahJong.currentLevel then  GridManager.setGrid(ChangeLevel.current, true) end ; ChangeLevel.show = false ; SceneMahJong.pause = false ; SaveMahJong.currentLevel = ChangeLevel.current ; mouse.selectInit()end)
  --  
end
--

function ChangeLevel.limit(pSelect)
  --
  ChangeLevel.current = ChangeLevel.current + (pSelect)
  --
  local max = SaveMahJong.levelMax
  --
  if ChangeLevel.current  > max then
    ChangeLevel.current = max
  end
  if ChangeLevel.current  < 1 then
    ChangeLevel.current = 1
  end
  --
end
--

function fenetreText.init()
  fenetreText.record =  {}
  fenetreText.record.string = "Temps Record à ce niveau"
  fenetreText.record.font = Font
  fenetreText.record.size = 22
  fenetreText.record.string = "Votre Meilleur Score !".."\n".."Temps Record à ce niveau : "
  fenetreText.record.print = love.graphics.newText(Font[22], fenetreText.record.string)
end
--

function fenetreText.update(dt)
  local text = ""
  if SaveMahJong.level[ChangeLevel.current] then
    local level = SaveMahJong.level[ChangeLevel.current]
    text = fenetreText.record.string..level.bestTimeText
  else
    text = fenetreText.record.string.."bug !"
  end
  fenetreText.record.print:set(text)
end
--


function ChangeLevel.showRecord()
  lg.setColor(1,1,1,1)
  if SaveMahJong.level[ChangeLevel.current] then
    local level = SaveMahJong.level[ChangeLevel.current]
    lg.draw(fenetreText.record.print, fenetreText.x, fenetreText.y)
  end
  lg.setColor(1,1,1,1)
end
--

function ChangeLevel.load()
  ChangeLevel.show = false
  ChangeLevel.current = SaveMahJong.currentLevel
  --
  fenetre.w = screen.w * 0.8
  fenetre.h = screen.h * 0.8
  fenetre.x = screen.w*0.1
  fenetre.y = screen.h*0.1
  --
  fenetreText.x = fenetre.x + (fenetre.w*0.1)
  fenetreText.y = fenetre.y + (fenetre.h*0.1)

  --
  Boutton.init()
  --
  fenetreText.init()
  --
end
--

function ChangeLevel.update(dt)
  ChangeLevelBM:update(dt)
  --
  Boutton[2]:setText(tostring("Level : "..ChangeLevel.current))
  --
  fenetreText.update(dt)
end
--

function ChangeLevel.draw()
  if ChangeLevel.show then
    love.graphics.setColor(0.25,0.25,0.25,1)
    love.graphics.rectangle("fill",fenetre.x,fenetre.y,fenetre.w,fenetre.h,10)
    --
    lg.setColor(1,1,1,1)
    ChangeLevelBM:draw()
    ChangeLevel.showRecord()
  end
end
--

function ChangeLevel.mousepressed(x, y, button, isTouch)
  if button == 1 then -- left clic
    if ChangeLevelBM.current.ready then
      ChangeLevelBM.current.action()-- example if bouton is Play then action is : SceneManager:setScene("MahJong")
    end
  end
end
--



return ChangeLevel