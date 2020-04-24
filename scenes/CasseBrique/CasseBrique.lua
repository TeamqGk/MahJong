local SceneCasseBrique = {}
--
local lg = love.graphics
--

local pad = {}
local ball = {}
local mapManager = {}
mapManager.currentLevel = 0
local map = {}
local color = {}
local BackGround = ImgManager.new("scenes/CasseBrique/img/wall.jpg")
BackGround:scaleToScreen()
BackGround:setColor(1,1,1,0.25)
--
local BM = BouttonManager.newBM()
BM.show = false
function BM.switchShow() BM.show = not BM.show end
local Boutton = {}

mouse.onCasseBrique = false


-- PAD
pad.w = 150
pad.h = 30
pad.ox = pad.w * 0.5
pad.oy = pad.h * 0.5
--
pad.x = (screen.w * 0.5) - pad.ox
pad.y = screen.h - pad.h*2
--
pad.distPointY = 15 -- why not mdr
pad.pointX = pad.x + pad.ox
pad.pointY = pad.y + pad.distPointY

-- BALL
ball.x = 0
ball.y = 0
ball.rayon = 15
--
ball.colle = true
--
ball.speed = 450
ball.vx = 0
ball.vy = 0

-- COLORS
color[1] = {1,1,1,1}
color[2] = {0,1,0,1}
color[3] = {0,0,1,1}
color[4] = {1,0,0,1}
color[5] = {1,1,0,1}
color[6] = {0,1,1,1}
color[7] = {1,0,1,1}
color[8] = {1,1,1,1}
color[9] = {1,1,1,1}
color[10] = {1,1,1,1}


function Boutton.init()
  BM:setDimensions(screen.w * 0.2, screen.h * 0.05)
  BM:setColor(0,1,0,0.15)
  BM:setColorText(0,0,0,0.75)
  BM:setColorMouseOver(0,0,1,0.15)
  --
  Boutton[1] = BM.newBox ()
  Boutton[1]:addText(Font[22], "Menu")
  Boutton[1]:setPos(screen.w - (Boutton[1].w+10),10)
  Boutton[1]:setVisible(false)
  Boutton[1]:setAction(function() SceneManager:setScene("MenuIntro") end)
  --
  Boutton[2] = BM.newBox ()
  Boutton[2]:addText(Font[22], "Pause/Quit")
  Boutton[2]:setPos(10, 10)
  Boutton[2]:setVisible(true)
  Boutton[2]:isEffect(false)
  Boutton[2]:setAction(function() BM.switchShow() end)
  --
  Boutton[3] = BM.newBox ()
  Boutton[3]:addText(Font[22], "Play")
  Boutton[3]:setPos(10, 10)
  Boutton[3]:setVisible(false)
  Boutton[3]:isEffect(false)
  Boutton[3]:setAction(function() BM.switchShow() end)
end
--


function mapManager.setLevel(pLevel)
  map = {}
  --
  local StartX = screen.w * 0.1
  local StartY = screen.h * 0.1
  --
  local x = StartX
  local y = StartY
  --
  local pLig = 3 + pLevel
  local pCol = 7 + pLevel
  --
  local w = screen.w - StartX*2
  local h = screen.h - StartY
  --
  local caseW = w / pCol
  local caseH = h / 15 -- hauteur fixe !
  --
  map.lig = pLig
  map.col = pCol
  map.level = pLevel
  --
  for l = 1, map.lig  do
    map[l] = {}
    for c = 1, map.col  do
      map[l][c] = {}
      local case = map[l][c]
      --
      case.x = x + 2
      case.y = y + 2
      case.w = caseW - 4
      case.h = caseH - 4
      case.ox = case.x + case.w * 0.5
      case.oy = case.y + case.h * 0.5
      case.rayon = (case.h - 4) * 0.5
      --
      case.vie = love.math.random(1, pLevel)
      --
      x = x + caseW
      --
    end
    --
    x = StartX
    y = y + caseH
    --
  end
  --
end
--

function mapManager.update(dt)
  for l = 1, map.lig  do
    for c = 1, map.col  do
      local case = map[l][c]
      -- HERE ?
    end
  end
end
--

function mapManager.draw()
  for l = 1, map.lig  do
    for c = 1, map.col  do
      local case = map[l][c]
      lg.setColor(color[case.vie])
      --
      lg.rectangle("fill",case.x,case.y,case.w,case.h,15)
      --
      lg.setColor(0,0,0,0.65)      
      --
      lg.circle("fill",case.ox,case.oy,case.rayon)
      lg.print(case.vie,case.ox-4,case.oy-8)
      --
      lg.setColor(1,1,1,1)      
    end
  end
end
--

function  ball.update(dt)
  if ball.colle then 
    ball.x = pad.x + pad.ox  
  elseif not ball.colle then
    --------- START ---------
    ball.x = ball.x + ( (ball.vx * ball.speed) * dt )
    ball.y = ball.y + ( (ball.vy * ball.speed) * dt )
    --------- END ---------
    if ball.x + ball.rayon >= screen.w then-- >= droite (w)
      ball.vx = 0 - ball.vx
      ball.x = screen.w - ball.rayon
    elseif ball.x - ball.rayon <= 0 then -- <= gauche (0)
      ball.vx = 0 - ball.vx
      ball.x = 0 + ball.rayon
    end
    --
    if ball.y - ball.rayon <= 0 then -- <= haut (0)
      ball.y = 0 + ball.rayon
      ball.vy = 0 - ball.vy
    end
    --

    -- REBOND
    if ball.x >= pad.x and ball.x <= pad.x + pad.w then -- Contact possible !! en largeur
      ball.colorX = true
      if ball.y + ball.rayon >= pad.y then -- rebond ! (Hauteur)
        ball.y  = pad.y - ( 1 + ball.rayon )-- MDR Je suis con xD ce soir oO
        --
        --ball.vy = 0 - ball.vy
        local rad = globals.math.angle(pad.pointX, pad.pointY,       ball.x, ball.y)
        ball.vx = math.cos(rad)
        ball.vy = math.sin(rad)
        --      oO        --
        ball.colorY = true
      elseif ball.y + ball.rayon >= pad.y - 50 then
        ball.colorY = false
      end
    else
      ball.colorX = false
      ball.colorY = false
    end
    --
    if ball.y + ball.rayon >= screen.h then-- >= bas (w)  == PERDU !
      Demarre()
    end
  end
end
--

function pad.update(dt)
  pad.x = love.mouse.getX() - pad.ox
  pad.pointX = pad.x + pad.ox
  pad.pointY = pad.y + pad.distPointY -- why not mdr
  --
  if pad.x <= 0 then
    pad.x = 1
  elseif pad.x + pad.w >= screen.w then
    pad.x = screen.w - (pad.w+1)
  end
end
--

function pad.draw()
  --
  lg.setColor(1,1,1,1)
  lg.rectangle("fill", pad.x, pad.y, pad.w, pad.h, 10)
  lg.setColor(1,1,1,1)
  --
end
--
function ball.draw()
  lg.setColor(1,1,1,1)
  --
  lg.circle("fill", ball.x, ball.y, ball.rayon)
  --
  lg.setColor(1,0,0,1)
  --
  lg.circle("fill", ball.x, ball.y, 2)
  --
  lg.setColor(1,1,1,1)
  if debug then
    if ball.colorY or ball.colorX then
      if ball.colorY then
        lg.setColor(1,0,0,1) -- prio 1
      elseif  ball.colorX then
        lg.setColor(0,0,1,0.5) -- prio  2
      end
      lg.circle("fill", ball.x, ball.y, ball.rayon)
    end
  end
  lg.setColor(1,1,1,1)
end
--

function Demarre()
  --
  pad.x = (screen.w * 0.5) - pad.ox
  --
  ball.colle = true
  ball.x = pad.x + pad.ox
  ball.y = pad.y - ball.rayon
  --
  mapManager.setLevel(5)
end
--
function nextBall()--
  pad.x = (screen.w * 0.5) - pad.ox
  --
  ball.colle = true
  ball.x = pad.x + pad.ox
  ball.y = pad.y - ball.rayon
end
--

function BM.showUpdate()
  if BM.show then -- Show Menu Intro
    Boutton[1]:setVisible(true) -- MenuIntro
    Boutton[2]:setVisible(false) -- pause/quit
    Boutton[3]:setVisible(true) -- play
    love.mouse.setGrabbed(false)
  else -- In Game progress !
    love.mouse.setGrabbed(true)
    Boutton[1]:setVisible(false) -- MenuIntro
    Boutton[2]:setVisible(true) -- pause/quit
    Boutton[3]:setVisible(false) -- play
  end
end
--

function SceneCasseBrique.load()
  Boutton.init()
  --
  Demarre()
end
--


function SceneCasseBrique.update(dt)
  BM:update(dt)
  BM.showUpdate()
  if not BM.show then
    --
    pad.update(dt)
    --
    ball.update(dt)
  end
end
--

function SceneCasseBrique.draw()
  BackGround:draw()
  --
  pad.draw()
  ball.draw()
  mapManager.draw()
  --
  BM:draw()
  if BM.show then

  else
  end
end
--

function SceneCasseBrique.keypressed(key)
  if key == "escape" then
    BM.show = not BM.show
  end
end
--

function SceneCasseBrique.mousepressed(x,y,button)
  if mouse.onGrid then
    if button == 1 then
      if ball.colle then
        ball.colle = false
        --
        local vx = love.math.random(-pad.ox, pad.ox) -- aleatoire varie a droite droite ou a gauche...
        local rad = globals.math.angle(pad.pointX + vx, pad.pointY,       ball.x, ball.y) -- MDR
        ball.vx = math.cos(rad)
        ball.vy = math.sin(rad)
        -- oO
      end
    end
  end
  --
  if button == 1 then -- left clic
    if BM.current.ready then
      if BM.current.isVisible then
        BM.current.action()-- example if bouton is Play then action is : SceneManager:setScene("MahJong")
      end
    end
  end
end
--


return SceneCasseBrique