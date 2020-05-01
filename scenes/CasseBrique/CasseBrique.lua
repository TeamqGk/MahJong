local SceneCasseBrique = {}
--
local lg = love.graphics
--

local CCD = require("scenes/CasseBrique/CCD")

local padManager = {} -- the pad
local pad = {} -- the pad
local BallManager = {} -- the ball's
local Ball = {} -- the ball's
local BonusManager = {}  -- 10 bonus !
local Bonus = {}  -- 10 bonus !
local playerManager = {}
local player = {}

local mapManager = {} -- function for map
mapManager.currentLevel = 0
local map = {} -- table of current map generated (Infos etc...)

local lst_briques = {} -- The map generated breack's in table with all elements (list)

local color = {}
-- COLORS
color[1] = {1,1,1,1}
color[2] = {0,1,0,1}
color[3] = {0,0,1,1}
color[4] = {0.25,0,0.75,1}
color[5] = {1,1,0,1}
color[6] = {0,1,1,1}
color[7] = {1,0,1,1}
color[8] = {1,0,0,0.8}
color[9] = {1,0,0,0.9}
color[10] = {1,0,0,1}

--
local BackGround = ImgManager.new("scenes/CasseBrique/img/wall.jpg")
BackGround:scaleToScreen()
BackGround:setColor(1,1,1,0.25)

--
local MiniWaal = ImgManager.new("scenes/CasseBrique/img/mini_wall.png")
MiniWaal:scaleToWidth()
MiniWaal:setColor(0,1,1,0.75)

--
local BM = BouttonManager.newBM()
BM.show = false
local Boutton = {}


-- AudioManager :
local AM = AudioManager.newAM()

-- sounds
local sonExplo = AM:addSound("scenes/CasseBrique/sons/explo.wav", false, 1)
local sonHit = AM:addSound("scenes/CasseBrique/sons/hit.wav", false, 1)
local sonScoreUp = AM:addSound("scenes/CasseBrique/sons/score_up.wav", false, 1)
local sonHitWaals = AM:addSound("scenes/CasseBrique/sons/hitWaals.wav", false, 1)
local sonHitPad = AM:addSound("scenes/CasseBrique/sons/hitPad.wav", false, 1)
local sonLifeUp = AM:addSound("scenes/CasseBrique/sons/lifeup.wav", false, 1)
local sonLaunch = AM:addSound("scenes/CasseBrique/sons/launch.wav", false, 1)
local sonPowerUp = AM:addSound("scenes/CasseBrique/sons/powerup.wav", false, 1)
local sonShoot = AM:addSound("scenes/CasseBrique/sons/shoot.wav", false, 1)
local playlist = {}
playlist.time = 0
playlist.play = 1
playlist.speed = 60
playlist.played = false


-- musics
local music_loop = AM:addMusic("scenes/CasseBrique/sons/Casse_Brique_By_Hydrogene.mp3", true, 0.25, false)


function playerManager.Demarre()

  BonusManager.init()

  -- Player
  player.nbVie = 3
  player.score = 0
  player.bestScore = 0
  player.maxLevel = 0


  -- PAD
  pad.w = 150
  pad.h = 30
  pad.ox = pad.w * 0.5
  pad.oy = pad.h * 0.5
--
  pad.x = (screen.w * 0.5) - pad.ox
  pad.y = screen.h - (pad.h * 2)
--
  pad.distPointY = 10 -- why not mdr
  pad.pointX = pad.x + pad.ox
  pad.pointY = pad.y + pad.distPointY

  -- BALL
  BallManager.newBall(0, 0, 15, 400, true, 0, 0) --BallManager.newBall(pX, pY, pRayon, pSpeed, pColle, pVx, pVy)
  playerManager.resetBall()

  -- init level 1
  mapManager.setLevel(1)

  --
  padManager.setToMap(map.caseW ,map.caseH)
  Ball[1]:setToMap(map.caseW ,map.caseH)
  --  
end
--
function playerManager.nextBall()
  if #Ball == 0 then
    player.nbVie = player.nbVie - 1
    if player.nbVie >= 1 then
      playerManager.resetBall()
    end
  end
end
--
function playerManager.resetBall()
  pad.x = (screen.w * 0.5) - pad.ox
  --
  Ball[1].colle = true
  Ball[1].x = pad.x + pad.ox
  Ball[1].y = pad.y - Ball[1].rayon
end
--

function Boutton.init()
  BM:setDimensions(screen.w * 0.2, screen.h * 0.05)
  BM:setColor(0,1,0,0.15)
  BM:setColorText(0,0,0,0.75)
  BM:setColorMouseOver(0,0,1,0.15)
  --
  Boutton[1] = BM.newBox ()
  Boutton[1]:addText(Font, 22, "Menu")
  Boutton[1]:setPos(screen.w - (Boutton[1].w+10),10)
  Boutton[1]:setVisible(false)
  Boutton[1]:setAction(function() SceneManager:setScene("MenuIntro") ; love.mouse.setVisible(true) ; music_loop:stop() end)
  --
  Boutton[2] = BM.newBox ()
  Boutton[2]:addText(Font, 22, "Pause/Quit")
  Boutton[2]:setPos(10, 10)
  Boutton[2]:setVisible(true)
  Boutton[2]:setEffect(false)
  Boutton[2]:setAction(function() BM.switchShow() end)
  --
  Boutton[3] = BM.newBox ()
  Boutton[3]:addText(Font, 22, "Play")
  Boutton[3]:setPos(10, 10)
  Boutton[3]:setVisible(false)
  Boutton[3]:setEffect(false)
  Boutton[3]:setAction(function() BM.switchShow() end)
end
--


function mapManager.setLevel(pLevel)
  if pLevel > 10 then pLevel = 10 end
  map = {}
  --
  local StartX = 0
  local StartY = screen.h * 0.1
  --
  MiniWaal:setPos(0, StartY - MiniWaal.h)
  --
  local x = StartX
  local y = StartY
  map.x = StartX
  map.y = StartY
  --
  local pLig = pLevel
  local pCol = 7 + pLevel
  map.lig = pLig
  map.col = pCol
  --
  local w = screen.w - StartX*2
  local h = screen.h - StartY
  map.w = w
  map.h = h
  --
  map.nbBriques = pLig * pCol
  map.level = pLevel
  map.clear = false
  --
  local caseW = w / pCol
  local caseH = h / 15 -- hauteur fixe !
  map.caseW = caseW
  map.caseH = caseH
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
      case.type = case.vie
      --
      x = x + caseW
      --
      table.insert(lst_briques, case)
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

function mapManager.draw()
  for i = #lst_briques, 1, - 1 do
    local case = lst_briques[i]
    lg.setColor(color[case.vie])
    --
    lg.rectangle("fill",case.x,case.y,case.w,case.h,5)
    --
    lg.setColor(0,0,0,0.65)      
    --
    lg.circle("fill",case.ox,case.oy,case.rayon)
    lg.print(case.vie,case.ox-4,case.oy-8)
    --
    lg.setColor(1,1,1,1)      
  end
end
--

function mapManager.finish(dt)
  -- explose score xD
  if not map.clear then
    if #lst_briques <= 0 then
      playlist.total = map.nbBriques * 0.25
      for i = 1,  playlist.total do
        playlist[i] = sonScoreUp:clone()
      end
      playlist.queue = 0
      map.clear = true
      playerManager.resetBall()

    end
  end
  --
  if map.clear and not playlist.played then
    --
    --
    playlist.time = playlist.time + playlist.speed * dt
    if  playlist.time >= playlist.play then
      playlist.time = 0
      if mapManager.playSource() then
        for i = #playlist, 1, -1 do
          table.remove(playlist, i)
        end
        playlist.played = true
      end
    end
  end
  --
  if map.clear and playlist.played then
    -- TODO : level Down, go next !
    playlist.played = false
    map.clear = false
    mapManager.setLevel(map.level+1)
  end
  --
end
--

function mapManager.playSource()
  for i = 1,  #playlist do
    if playlist.queue < #playlist then
      if not playlist[i]:isPlaying() then
        playlist[i]:play()
        playlist.queue = playlist.queue + 1
        return false
      end
    end
  end
  return true
end
--

function BonusManager.init() -- TODO: Bonus Init a faire
  for i =1, 10 do
    Bonus[i] = {}
  end
end
--

function BallManager.newBall(pX, pY, pRayon, pSpeed, pColle, pVx,pVy)
  local b = {}
  b.x = pX
  b.y = pY
  b.rayon = pRayon
--
  b.colle = pColle
--
  b.speed = pSpeed
  b.vx = pVx
  b.vy = pVy
  --
  function b:setToMap(pCaseW ,pCaseH)
    self.rayon = (pCaseH * 0.5) * 0.5
  end
--
  function b:collideBriques()
    --TEST Collision Ball self witch Brick's :
    for i = #lst_briques, 1, - 1 do
      local case = lst_briques[i]
      local collide = globals.math.circleRect(self.x, self.y, self.rayon,              case.x, case.y, case.w, case.h)
      --
      print("test sur brique["..i.."]")
      for k , v in pairs(collide) do
        print(k.." : "..tostring(v))
      end
      --
      if collide.collision then -- si y a eu collision..
        --
        if collide.x == case.x then -- gauche
          self.x = case.x - self.rayon
          self.vx = 0 - self.vx
        end
        if collide.x == case.x + case.w then -- droite
          self.x = (case.x + case.w) + self.rayon
          self.vx = 0 - self.vx
        end
        if collide.y == case.y + case.h then -- bas
          self.y = (case.y + case.h) + self.rayon
          self.vy = 0 - self.vy
        end
        if collide.y == case.y then -- haut
          self.y = case.y - self.rayon
          self.vy = 0 - self.vy
        end
        --

        -- decrementation de la vie
        case.vie = case.vie - 1
        if case.vie == 0 then
          -- TODO: Take Bonus Here !
          table.remove(lst_briques, i)
          sonExplo:play()
        else
          sonHit:play()
        end
        --
        return true
        --
      end
      --
    end
    return false
  end
--

  function b:collideWaals()
    -- Collide Walls :
    local hit = false
    --
    if self.x + self.rayon >= screen.w then-- >= droite (w)
      self.vx = 0 - self.vx
      self.x = screen.w - self.rayon
      hit = true
    elseif self.x - self.rayon <= 0 then -- <= gauche (0)
      self.vx = 0 - self.vx
      self.x = 0 + self.rayon
      hit = true
    end
    --
    if self.y - self.rayon <= map.y then -- <= haut (0)
      self.y = map.y + self.rayon
      self.vy = 0 - self.vy
      hit = true
    end

    if hit then return true end
    return false
  end
--

  function b:collidePad()
    -- REBOND PAD
    if self.x + self.rayon >= pad.x and self.x - self.rayon <= pad.x + pad.w then -- Contact possible !! en largeur
      if self.y + self.rayon >= pad.y and self.y <= pad.y then -- rebond ! (Hauteur)
        self.y  = pad.y - ( 1 + self.rayon )-- MDR Je suis con xD ce soir oO
        --
        -- old school : self.vy = 0 - self.vy... but witch angle this is it :
        local rad = globals.math.angle(pad.pointX, pad.pointY,       self.x, self.y)
        self.vx = math.cos(rad)
        self.vy = math.sin(rad)
        --      oO        --
        return true
      end
    else
    end
    return false
  end
--

  function  b:update(dt)
    if self.colle then 
      self.x = pad.x + pad.ox  
    elseif not self.colle then

      -- Move : TODO: CCD here !
      self.x = self.x + ( (self.vx * self.speed) * dt )
      self.y = self.y + ( (self.vy * self.speed) * dt )


      --TEST Collision witch Breack's :
      self:collideBriques()

      if self:collideWaals() then sonHitWaals:stop() ; sonHitWaals:play() end

      if self:collidePad() then sonHitPad:stop() ; sonHitPad:play() end


      -- Ball Loose :
      if self.y - self.rayon * 3 >= screen.h then-- >= bas (w)  == PERDU !
        playerManager.nextBall()
      end
    end
  end
--

  function b:draw()
    lg.setColor(1,1,1,1)
    --
    lg.circle("fill", self.x, self.y, self.rayon)
    --
    lg.setColor(1,0,0,0.25)
    --
    lg.circle("fill", self.x, self.y, 2)
    --
    lg.setColor(1,1,1,1)
  end
--

  table.insert(Ball, b)
end
--

function BallManager.update(dt)
  for i = #Ball, 1, -1 do
    local ball = Ball[i]
    ball:update(dt)
  end
end
--

function BallManager.draw()
  for i = #Ball, 1, -1 do
    local ball = Ball[i]
    ball:draw()
  end
end
--


function padManager.setToMap(pCaseW ,pCaseH)
  pad.w = pCaseW * 1.5
  pad.h = pCaseH * 0.6
  pad.y = screen.h - ( pad.h  + 2 )
  --
  pad.ox = pad.w * 0.5
  pad.oy = pad.h * 0.5
end
--

function padManager.update(dt)
  --
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

function padManager.draw()
  local bordsArrondi = 5

  -- pad Complet
  lg.setColor(0,1,1,0.75)
  lg.rectangle("fill", pad.x, pad.y, pad.w, pad.h, bordsArrondi)

  -- pad Contour
  lg.setColor(0,0,0,0.75)  
  lg.rectangle("line", pad.x, pad.y, pad.w, pad.h, bordsArrondi)

  -- reset Color
  lg.setColor(1,1,1,1)
end
--



local function mouseIsVisible()
  if mouse.y <= map.y then
    mouse.onCasseBrique = false
  else
    mouse.onCasseBrique = true
  end
  --
  if BM.show then -- Show Menu Intro
    love.mouse.setGrabbed(false)
    love.mouse.setVisible(true)
  else -- In Game progress !
    if mouse.onCasseBrique then
      love.mouse.setVisible(false)
      love.mouse.setGrabbed(true)
    else
      love.mouse.setVisible(true)
    end
  end
end
--

function BM.switchShow() BM.show = not BM.show end

function BM.showUpdate()
  if BM.show then -- Show Menu Intro
    Boutton[1]:setVisible(true) -- MenuIntro
    Boutton[2]:setVisible(false) -- pause/quit
    Boutton[3]:setVisible(true) -- play
  else -- In Game progress !
    Boutton[1]:setVisible(false) -- MenuIntro
    Boutton[2]:setVisible(true) -- pause/quit
    Boutton[3]:setVisible(false) -- play
  end
end
--

function SceneCasseBrique.load()
  Boutton.init()
  --
  playerManager.Demarre()
end
--

function SceneCasseBrique.update(dt)
  if Sounds.GPR_Beat_Katana:isPlaying() then Sounds.GPR_Beat_Katana:stop() end
  --
  AM:update(dt)
  mouseIsVisible()
  --
  BM:update(dt)
  BM.showUpdate()
  --
  if not BM.show then
    if not music_loop:isPlaying() then
      music_loop:play()
    end
    --
    padManager.update(dt)
    BallManager.update(dt)

    mapManager.finish(dt)
  end
end
--

function SceneCasseBrique.draw()
  BackGround:draw()
  --
  padManager.draw()
  BallManager.draw()
  mapManager.draw()
  --
  BM:draw()
  --
  MiniWaal:draw()
end
--

function SceneCasseBrique.keypressed(key)
  if key == "escape" then
    BM.show = not BM.show
  end

  if debug then
    if key == "delete" then
      for i = #lst_briques , 1 , - 1 do
        table.remove(lst_briques, i)
      end
    end
  end
end
--

function SceneCasseBrique.mousepressed(x,y,button)
  if not BM.show then
    for i=#Ball, 1, -1 do
      local ball = Ball[i]
      if ball.colle then
        if button == 1 then
          sonLaunch:play()
          --
          ball.colle = false
          --
          local MinMax = pad.ox * 0.5
          local vx = love.math.random(-MinMax, MinMax) -- aleatoire varie a droite droite ou a gauche...
          local rad = globals.math.angle(pad.pointX + vx, pad.pointY,       ball.x, ball.y) -- MDR
          ball.vx = math.cos(rad)
          ball.vy = math.sin(rad)
          -- oO
          return true
        end
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