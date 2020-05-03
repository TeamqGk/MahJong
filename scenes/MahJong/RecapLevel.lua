local RecapLevel = {}
--
local lg = love.graphics
--
local RecapLevelBM = BouttonManager.newBM()
local Boutton = {}
--
local AM = AudioManager.newAM()
local sound_clic = AM:addSound("scenes/MahJong/sound/clic.wav", false, 0.4)
--
local fenetre = {}
local fenetreText = {}
--

local SuccesImg = ImgManager.new("scenes/MahJong/pics/level_succes.png")


function Boutton.init()
  RecapLevelBM:setDimensions(screen.w * 0.15, screen.h * 0.05)
  RecapLevelBM:setColor(0,1,0,0.15)
  RecapLevelBM:setColorText(0,0,0,0.75)
  RecapLevelBM:setColorMouseOver(0,0,1,0.15)
  --
  Boutton[1] = RecapLevelBM.newBox ()
  Boutton[1]:addText(Font, 22, tostring("Recap Level : "..RecapLevel.current))
  Boutton[1]:setEffect(false)
  Boutton[1]:setPos(fenetre.w * 0.5 , fenetre.y + 10)
  Boutton[1]:setAction(function() sound_clic:stop(); sound_clic:play(); RecapLevel.limit(-1) end)

  --
  Boutton[4] = RecapLevelBM.newBox ()
  Boutton[4]:addText(Font, 22, "Ok")
  Boutton[4]:setPos(fenetre.w * 0.5 , fenetre.h - (Boutton[1].h + 10) )
  Boutton[4]:setAction(function()  sound_clic:stop(); sound_clic:play(); RecapLevel.show = false ; RecapLevel.Succes = false ; SceneMahJong.pause = false end)
  --


end
--

function RecapLevel.limit(pSelect)
  --
  RecapLevel.current = RecapLevel.current + (pSelect)
  --
  local max = SaveMahJong.levelMax
  --
  if RecapLevel.current  > max then
    RecapLevel.current = max
  end
  if RecapLevel.current  < 1 then
    RecapLevel.current = 1
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
  if SaveMahJong.level[RecapLevel.current] then
    local level = SaveMahJong.level[RecapLevel.current]
    text = fenetreText.record.string..level.bestTimeText
  else
    text = fenetreText.record.string.."bug !"
  end
  fenetreText.record.print:set(text)
end
--


function RecapLevel.showRecap()
  lg.setColor(1,1,1,1)
  if SaveMahJong.level[RecapLevel.current] then
    local level = SaveMahJong.level[RecapLevel.current]
    lg.draw(fenetreText.record.print, fenetreText.x, fenetreText.y)
  end
  lg.setColor(1,1,1,1)
end
--

function RecapLevel.load()
  RecapLevel.show = false
  RecapLevel.current = SaveMahJong.currentLevel
  --
  fenetre.w = screen.w * 0.8
  fenetre.h = screen.h * 0.8
  fenetre.x = screen.w*0.1
  fenetre.y = screen.h*0.1
  --
  fenetreText.x = fenetre.x + (fenetre.w*0.1)
  fenetreText.y = fenetre.y + (fenetre.h*0.1)

  --
  RecapLevel.Succes = false -- bool for showing Succes img if level is done :)
  SuccesImg:setSizes(fenetre.w, fenetre.h)
  SuccesImg:setPos(fenetre.x, fenetre.y)
  --
  Boutton.init()
  --
  fenetreText.init()
  --
end
--

function RecapLevel.update(dt)
  RecapLevelBM:update(dt)
  --
  Boutton[1]:setText(tostring("Recap Level : "..RecapLevel.current))
  --
  fenetreText.update(dt)
end
--

function RecapLevel.draw()
  if RecapLevel.show then
    love.graphics.setColor(0.25,0.25,0.25,1)
    love.graphics.rectangle("fill",fenetre.x,fenetre.y,fenetre.w,fenetre.h,10)
    --
    lg.setColor(1,1,1,1)
    if RecapLevel.Succes then
      SuccesImg:draw()
    end
    RecapLevelBM:draw()
    RecapLevel.showRecap()
  end
end
--

function RecapLevel.mousepressed(x, y, button, isTouch)
  if button == 1 then -- left clic
    if RecapLevelBM.current.ready then
      RecapLevelBM.current.action()-- example if bouton is Play then action is : SceneManager:setScene("MahJong")
    end
  end
end
--



return RecapLevel