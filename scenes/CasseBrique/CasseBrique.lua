local SceneCasseBrique = {}
--
local lg = love.graphics
--

local BestScore = require("scenes/CasseBrique/BestScore")
local CCD = require("scenes/CasseBrique/CCD")

local padManager = {} -- the pad
local pad = {} -- the pad
local BallManager = {} -- the ball's
local Ball = {} -- the ball's
local BonusManager = {}  -- 10 bonus !
local Bonus = {}  -- 10 bonus !
local lst_Bonus = {}  -- all's' bonus in level !
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
local Vie = ImgManager.new("scenes/CasseBrique/img/vie.png")
--Vie:scaleToWitdth()
--Vie:setColor(0,1,1,0,75)

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
local sonBonusLoose = AM:addSound("scenes/CasseBrique/sons/bonus_loose.wav", false, 1)
local playlist = {}
playlist.time = 0
playlist.play = 1
playlist.speed = 60
playlist.played = false


-- musics
local music_loop = AM:addMusic("scenes/CasseBrique/sons/Casse_Brique_By_Hydrogene.mp3", true, 0.25, false)


function playerManager.Demarre()

  SaveCasseBriqueManager.load()  

  BonusManager.init()

  -- Player
  player.nbVie = 3
  player.score = 0
  player.bonusMultiplicateur = 1
  player.level = 1


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
  BallManager.newBall(0, 0, 15, 600, true, 0, 0) --BallManager.newBall(pX, pY, pRayon, pSpeed, pColle, pVx, pVy)

  -- init level 1
  mapManager.setLevel(1)

  --
  Ball[1]:setToMap(map.caseW ,map.caseH)
  padManager.setToMap(map.caseW ,map.caseH)
  --  
  playerManager.resetBall()
end
--
function playerManager.nextBall()
  player.nbVie = player.nbVie - 1
  if player.nbVie >= 1 then
    if player.nbVie == 1 then
      Sounds.final_round:stop()
      Sounds.final_round:play()
    end
    playerManager.resetBall()
  else
    --
    mapManager.SaveScore()
    --
    BestScore.showMenu()
    --
    playerManager.Demarre()
    --
  end
end
--
function playerManager.resetBall()
  pad.x = (screen.w * 0.5) - pad.ox
  --
  if #Ball == 0 then
    BallManager.newBall(0, 0, 15, 600, true, 0, 0)
  end
  Ball[1].colle = true
  Ball[1].x = pad.x + pad.ox
  Ball[1].y = pad.y - Ball[1].rayon
  --
  padManager.setToMap(map.caseW ,map.caseH)
  Ball[1]:setToMap(map.caseW ,map.caseH)


  -- on reset les multiballs
  for i = #Ball, 1, -1 do
    local ball = Ball[i]
    if i == 1 then
      ball.power = math.floor(player.level * 0.5) + 1
    else
      table.remove(Ball, i)
    end
  end

  -- on enleve les bonus a l'ecran'
  for i = #lst_Bonus, 1, -1 do
    table.remove(lst_Bonus, i)
  end
  --
end
--
function playerManager.draw()
  for i = 1, player.nbVie do
    local x = Vie.w * (i - 1)
    local y = screen.h - Vie.h
    lg.draw(Vie.img, x, y, 0, 1, 1)
  end
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
  Boutton[2]:addText(Font, 22, "Press Escape")
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
  --
  Boutton[4] = BM.newBox ()
  Boutton[4]:addText(Font, 22, "Bricks : ")
  Boutton[4]:setPos(Boutton[3].x + Boutton[3].w + 10, 10)
  Boutton[4]:setVisible(true)
  Boutton[4]:setEffect(false)
  Boutton[4]:setAction(function() BestScore.showMenu() end)
  --
  Boutton[5] = BM.newBox ()
  Boutton[5]:addText(Font, 22, "X ")
  Boutton[5]:setPos(Boutton[4].x + Boutton[3].w + 10, 10)
  Boutton[5]:setVisible(true)
  Boutton[5]:setEffect(false)
  Boutton[5]:setAction(function() BestScore.showMenu() end)
  --
  Boutton[6] = BM.newBox ()
  Boutton[6]:addText(Font, 22, "Score : ")
  Boutton[6]:setPos(Boutton[5].x + Boutton[3].w + 10, 10)
  Boutton[6]:setVisible(true)
  Boutton[6]:setEffect(false)
  Boutton[6]:setAction(function() BestScore.showMenu() end)
  --
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
    lg.setColor(color[case.type])
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
    --
    mapManager.levelUp()-- LEVEL Up !!!
    --
  end
end
--

function mapManager.SaveScore()
  --
  local date = tostring(os.date())
  local pos = nil
  --
  local function scanScore()
    for i = 1, 10 do
      local search = SaveCasseBrique[i]
      if type(search.BestScore) == "string" then
        pos = i
        return true
      elseif player.score > search.BestScore then
        pos = i
        return true
      end
    end
    return false
  end
  --
  local function updateScore()
    for i = #SaveCasseBrique, pos, -1 do
      print("i : "..tostring(i))
      local down = SaveCasseBrique[i-1]
      local maj = SaveCasseBrique[i]
      --
      if i == pos then
        maj.BestScore = player.score
        maj.Date = date
        maj.Level = player.level
      else
        for k , v in pairs(down) do
          maj[k] = v
        end
      end
      --
    end
  end
  --

  -- Verification si on a fait mieux qu'un bestScore du score board ! si vrai alors on mets a jour :
  if scanScore() then
    updateScore()
    --
    Sounds.new_highscore:stop()
    Sounds.new_highscore:play()
  else
    Sounds.you_lose:stop()
    Sounds.you_lose:play()
  end
  --

  -- save to file :
  SaveCasseBriqueManager.save()
  --
end
--

function mapManager.levelUp()

  -- reset Bool :
  playlist.played = false
  map.clear = false

  -- Maj Level :
  player.level = player.level + 1

  -- Maj Score :
  player.score =   player.score * player.bonusMultiplicateur

  -- on change le niveau actuel
  mapManager.setLevel(player.level)
  Sounds.level_up:stop()
  Sounds.level_up:play()

  playerManager.resetBall()
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


function BonusManager:timerPadXL(dt)
  local t = BonusManager.timerPad
  if BonusManager.PadXL then
    if t.run then
      t.finish = t.finish + t.duree
    else
      t.run = true
      Sounds.go:stop()
      Sounds.go:play()
    end
    BonusManager.PadXL = false
  end
  --
  --
  if t.run then
    t.start = t.start + t.speed * dt
    if t.start >= t.finish then
      t.run = false
      t.finish = t.duree
      t.start = 0
      --
      Sounds.ready:stop()
      Sounds.ready:play()
      --
    end
  end
end
--

function BonusManager.init()
  BonusManager.timerPad = {}
  BonusManager.timerPad.run = false
  BonusManager.timerPad.start = 0
  BonusManager.timerPad.duree = 90
  BonusManager.timerPad.finish = BonusManager.timerPad.duree
  BonusManager.timerPad.speed = 60

  BonusManager.PadXL = false
  --

  local function new(pType,pString)
    local new = {}
    new.type = pType
    new.font = Font
    new.size = 16
    new.string = pString
    new.text = love.graphics.newText(new.font[new.size],new.string)
    new.w = new.text:getWidth()
    new.h = new.text:getHeight()
    new.ox = new.text:getWidth() * 0.5
    new.oy = new.text:getHeight() * 0.5
    return new
  end
  --
  Bonus[1] = new(1, "SPEED") -- speed
  Bonus[2] = new(2, "POWER") -- Power Up
  Bonus[3] = new(3, "Ball +1")
  Bonus[4] = new(4, "Ball +3")
  Bonus[5] = new(5, "VIE +1")
  Bonus[6] = new(6, "Pad XL")
  Bonus[7] = new(7, "+1 ?")
  Bonus[8] = new(8, "+2 ?")
  Bonus[9] = new(9, "+3 ?")
  Bonus[10] = new(10, "ALL")
end
--

function BonusManager.newBonus(pX,pY,pCase)
  local lucky = (pCase.type * 10) - 100
  local rand = love.math.random(1, 100)
  --
  if rand >= lucky then
    --
    local new = {}
    --
    local bonus = Bonus[pCase.type]
    for k, v in pairs(bonus) do
      new[k] = v
    end
    --
    new.x = pX
    new.y = pY
    --
    new.speed = 100
    new.vx = 0
    new.vy = 1
    new.rayon = pCase.rayon * 1.10
    --
    new.color = color[pCase.type]
    new.colorBonus = color[love.math.random(1,10)]
    --
    new.timer = {}
    new.timer.start = 0
    new.timer.finish = 10
    new.timer.speed = 60
    new.timer.ready = false
    --
    function new:sizeText()
      if self.w > (self.rayon * 2) - 4 then
        if self.size > 1 then
          self.size = self.size - 1
          self.text:setFont(self.font[self.size])
          self.text:set(self.string)
          self.w = self.text:getWidth()
          self.h = self.text:getHeight()
          self.ox = self.w * 0.5
          self.oy = self.h * 0.5
        end
      end
    end
    --
    function new:collidePad()
      -- Collision avec le PAD
      if self.x + self.rayon >= pad.x and self.x - self.rayon <= pad.x + pad.w then -- Contact possible !! en largeur
        if self.y + self.rayon >= pad.y and self.y <= pad.y then -- rebond ! (Hauteur)
          player.bonusMultiplicateur = player.bonusMultiplicateur + 1
          return true
        else
          return false
        end
      end
    end
    --
    function new:deleteBonus(pType,pID)
      if pType == "PowerUp" then
        for i = #Ball, 1, -1 do
          local b = Ball[i]
          --
          for i = #b, 1, -1 do
            if b[i] == pID then
              b.power = b.power - 1
              table.remove(b, i)
            end
          end
        end
      end
    end
    --
    function new:BonusSpeedBall()
      for i = #Ball, 1, -1 do
        local b = Ball[i]
        b.speed = b.speed + 100
      end
    end
    --
    function new:BonusPowerUp()
      local id = love.timer.getTime()
      --
      for i = #Ball, 1, -1 do
        local b = Ball[i]
        b:addTimer("PowerUp", id)
        b.power = b.power + 1
        table.insert(b, id) -- Ball[i][#index] = id
      end
    end
    --
    function new:BonusLifeUp()
      sonLifeUp:stop()
      sonLifeUp:play()
      player.nbVie = player.nbVie + 1
    end
    --
    function new:BonusNewBall(pNumber)
      if not pNumber then pNumber = 1 end
      for i = 1, pNumber do
        local MinMax = pad.ox * 0.5
        local vx = math.cos(love.math.random(-MinMax, MinMax))
        local ball = Ball[1]
        local vy = ball.vy
        if ball.vy > 0 then
          vy = 0 - vy
        end
        BallManager.newBall(ball.x, ball.y, ball.rayon, ball.speed, false, vx , vy)
      end
    end
    --
    function new:timerUpdate(dt)
      if not self.timer.ready then
        self.timer.start = self.timer.start + self.timer.speed * dt
        if self.timer.start >= self.timer.finish then
          self.timer.ready = true
          self.timer.start = 0
        end
      end
    end
    function new:update(dt)
      self:sizeText()
      --
      self:timerUpdate(dt)
      --
      self.y = self.y + (self.speed * self.type * dt)
      if self.y + (self.rayon * 0.5) > pad.y then
        for i = #lst_Bonus, 1, -1 do
          local search = lst_Bonus[i]
          if search == self then
            sonBonusLoose:stop()
            sonBonusLoose:play()
            table.remove(lst_Bonus, i)
            return false
          end
        end
      end
      --
      if self:collidePad() then
        Sounds.power_up:stop()
        Sounds.power_up:play()
        self:addBonus(self.type)
      end
    end
    --
    function new:draw()
      --
      if self.type <= 6 then
        lg.setColor(0,0,0,1)
      elseif self.type <= 9 then
        lg.setColor(0,1,0,1)
      else
        lg.setColor(1,0,0,1)
      end
      lg.circle("fill",self.x,self.y,self.rayon)
      lg.setColor(self.color)      
      lg.circle("line",self.x,self.y,self.rayon)
      lg.circle("line",self.x,self.y,self.rayon-1)

      -- Bonus
      if self.timer.ready then
        self.colorBonus = color[love.math.random(1,10)]
        self.timer.ready = false
      end
      --
      for i = 1 , 3 do
        lg.setColor(self.colorBonus)
        lg.circle("line",self.x,self.y,self.rayon+i)
      end
      --
      lg.draw(self.text, self.x, self.y ,0,1,1, self.w*0.5, self.h*0.5)
      --
      lg.setColor(1,1,1,1) -- reset Color
      --
    end
    --
    --
    function new:addBonus(pType)
      if pType == 7 then -- 1 alea
        local rand = love.math.random(1,6)
        self:addBonus(rand)
      elseif pType == 8 then -- 2 alea
        for i = 1, 2 do
          local rand = love.math.random(1,6)
          self:addBonus(rand)
        end
      elseif pType == 9 then -- 3 alea
        for i = 1, 3 do
          local rand = love.math.random(1,6)
          self:addBonus(rand)
        end
      elseif pType == 10 then  -- alls
        for i = 1, 6 do
          self:addBonus(i)
        end
      elseif  pType == 1 then
        self:BonusSpeedBall()
      elseif pType == 2 then
        self:BonusPowerUp()
      elseif pType == 3 then
        self:BonusNewBall(1)
      elseif pType == 4 then
        self:BonusNewBall(3)
      elseif pType == 5 then
        self:BonusLifeUp()
      elseif pType == 6 then
        BonusManager.PadXL = true
      end
      --
      for i = #lst_Bonus, 1, -1 do
        local search = lst_Bonus[i]
        if search == self then
          table.remove(lst_Bonus, i)
          return true
        end
      end
    end -- end addBonus()
    --
    --##############################################
    table.insert(lst_Bonus, new) -- Ajoute le Bonus
    --##############################################
  end -- end lucky
end
--

function BonusManager.update(dt)
  for i = #lst_Bonus, 1, -1 do
    local bonus = lst_Bonus[i]
    bonus:update(dt)
  end
end
--

function BonusManager.draw()
  for i = #lst_Bonus, 1, -1 do
    local bonus = lst_Bonus[i]
    bonus:draw()
  end
end
--

function BallManager.newBall(pX, pY, pRayon, pSpeed, pColle, pVx, pVy)
  local b = {}
  b.x = pX
  b.y = pY
  b.rayon = pRayon
  b.old = {}
  b.old.x = pX
  b.old.y = pY
--
  b.colle = pColle
--
  b.speed = pSpeed
  b.vx = pVx
  b.vy = pVy
  --
  b.power = 1
  --
  b.timer = {}
  b.timer.start = 0
  b.timer.finish = 10
  b.timer.speed = 60
  b.timer.ready = false
  --
  collideEffect = false
  --
  function b:setToMap(pCaseW ,pCaseH)
    self.rayon = (pCaseH * 0.5) * 0.5
  end
--
  function b:addTimer(pType, pID)
    local t = {}
    t.type= pType
    --
    if pID then
      t.id = pID
    end
    --
    t.start = 0
    t.finish = 30
    t.speed = 60
    --
    t.isActive = true
    --
    table.insert(self.timer, t)
  end
  --
  function b:timerUpdate(dt)
    for i = #self.timer, 1 , -1 do
      local t = self.timer[i]
      t.start = t.start + t.speed * dt
      if t.start >= t.finish then
        t.isActive = false
      end
      if not t.isActive then
        self:deleteBonus(t.id)
      end
      table.remove(self.timer, i)
    end
    --
    if not self.timer.ready then
      self.timer.start = self.timer.start + self.timer.speed * dt
      if self.timer.start >= self.timer.finish then
        self.timer.ready = true
        self.timer.start = 0
      end
    end
  end
  --
  function b:collideBriques(dt)
    --TEST Collision Ball self witch Brick's :
    for i = #lst_briques, 1, - 1 do
      local case = lst_briques[i]
      local collide = CCD.Ball_vs_Rect(self, case, dt) -- return (collision = true/false, x, y, oldX, oldY)
      if collide.collision then
        --
        if collide.oldY >= case.y and collide.oldY <= case.y + case.h then -- DROITE OU GAUCHE
          if collide.x == case.x then -- gauche
            self.x = case.x - (self.rayon)
            self.vx = 0 - self.vx
          elseif collide.x == case.x + case.w then -- droite
            self.x = (case.x + case.w) + (self.rayon)
            self.vx = 0 - self.vx
          end
        else -- BAS OU HAUT
          self.x = collide.x
          self.vx = self.vx or math.cos(love.math.random(-1, 1))
        end
        --
        --
        --
        if collide.oldX >= case.x and collide.oldX <= case.x + case.w then -- BAS OU HAUT
          if collide.y == case.y + case.h then -- bas
            self.y = (case.y + case.h) + self.rayon
            self.vy = 0 - self.vy
          elseif collide.y == case.y then -- haut
            self.y = case.y - self.rayon
            self.vy = 0 - self.vy
          end
        else -- DROITE OU GAUCHE
          self.y = collide.y
        end
        --

        -- decrementation de la vie
        case.vie = case.vie - self.power
        if case.vie <= 0 then
          player.score = player.score + case.type -- Update Score
          BonusManager.newBonus(case.ox,case.oy,case)
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

  function b:collidePad(dt) -- REBOND PAD
    local collide = CCD.Ball_vs_Rect(self, pad, dt) -- return (collision = true/false, x, y, oldX, oldY)
    if collide.collision then
      self.x = collide.x
      self.y = collide.y - ( 1 + self.rayon ) 
      --
      -- old school : self.vy = 0 - self.vy... but witch angle this is it :
      local rad = globals.math.angle(pad.pointX, pad.pointY,       self.x, self.y)
      self.vx = math.cos(rad)
      self.vy = math.sin(rad)
      return true
    else
      return false
    end
  end
--
  function b:updateColor(dt)
--
    if self.collideEffect then
      local t = self.timer
      t.start = t.start + t.speed * dt
      if t.start >= t.finish then-- durée du timer
        t.ready = true
        return false
      end
      --
      return true
    end
--
  end
--
  function  b:update(dt)
    if self.colle then 
      self.x = pad.x + pad.ox  
    elseif not self.colle then
      -- vx bug ?
      self.vx = self.vx or math.cos(love.math.random(-1, 1))
      -- Move
      self.old.x = self.x
      self.old.y = self.y
      self.x = self.x + ( (self.vx * self.speed) * dt )
      self.y = self.y + ( (self.vy * self.speed) * dt )

      self:timerUpdate(dt) -- Bonus Timer effective !

      --TEST Collision witch Breack's :
      if self:collideBriques(dt) then 
        self.old.x = self.x
        self.old.y = self.y
        self.collideEffect = true
      end
      if self.collideEffect then
        self.collideEffect = self:updateColor(dt)
      end

      if self:collideWaals() then
        self.old.x = self.x
        self.old.y = self.y
        sonHitWaals:stop()
        sonHitWaals:play()
      end

      if self:collidePad(dt) then
        self.old.x = self.x
        self.old.y = self.y
        sonHitPad:stop()
        sonHitPad:play()
      end


      -- Ball Loose :
      if BonusManager.timerPad.run then
        if self.y + self.rayon >= pad.y then -- Bonus PAD XL == Rebond sur tt el bas de l'ecran !
          self.y = pad.y - self.rayon
          self.vy = 0 - self.vy 
        end
      elseif self.y - self.rayon * 3 >= screen.h then-- >= bas (w)  == PERDU !
        for i = #Ball, 1, -1 do
          if Ball[i] == self then
            table.remove(Ball, i)
            if #Ball == 0 then
              playerManager.nextBall()
            end
            return false
          end
        end
      end
    end
  end
--

  function b:draw()
    lg.setColor(1,1,1,1)
    --
    lg.circle("fill", self.x, self.y, self.rayon)
    --
    if self.collideEffect == true then
      for i = 1, 3 do
        lg.setColor(color[love.math.random(1,10)])
        lg.circle("line",self.x, self.y, self.rayon + 1 + i, 360)
      end
    end
    --
    for i = 1, self.power do
      if i == 1 then
        lg.setColor(1,0,0,0.25)
      else
        lg.setColor(color[love.math.random(1,10)])
      end
      lg.circle("fill", self.x, self.y, 1 + i)
    end
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
  lg.setColor(1,1,1,1)-- reset
  if BonusManager.timerPad.run then
    local y = pad.y + pad.oy
    for i =1 , 5 do
      lg.setColor(color[love.math.random(1,10)])
      local y1 = y + love.math.random(pad.oy,-pad.oy)
      local y2 = y + love.math.random(pad.oy,-pad.oy)
      lg.line(-1,y1,screen.w+1,y2)
    end
  end
  lg.setColor(1,1,1,1)-- reset

  --
  local bordsArrondi = 5
  -- pad Complet
  lg.setColor(0,1,1,0.75)
  lg.rectangle("fill", pad.x, pad.y, pad.w, pad.h, bordsArrondi)

  -- pad Contour
  lg.setColor(0,0,0,0.75)  
  lg.rectangle("line", pad.x, pad.y, pad.w, pad.h, bordsArrondi)

  lg.setColor(1,0,0,0.25)
  lg.circle("fill",pad.x + pad.ox,pad.y + pad.oy, 3)

  -- reset Color
  lg.setColor(1,1,1,1)
end
--



local function mouseIsVisible()
  if BM.show then -- Show Menu Intro
    love.mouse.setGrabbed(false)
    love.mouse.setVisible(true)
  else -- In Game progress !
    love.mouse.setVisible(false)
    love.mouse.setGrabbed(true)
    love.mouse.setY(map.y)
  end
end
--

function BM.switchShow() BM.show = not BM.show end

function BM.showMenu()
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
  BM.showMenu()
  --
  BestScore:update(dt)
  Boutton[4]:setText("Bricks : "..player.score)
  Boutton[5]:setText("Bonus X "..player.bonusMultiplicateur)
  Boutton[6]:setText("Score : "..(player.score * player.bonusMultiplicateur))
  --
  if not BM.show then
    if not music_loop:isPlaying() then
      music_loop:play()
    end
    --    
    padManager.update(dt)
    BallManager.update(dt)
    BonusManager.update(dt)
    mapManager.finish(dt)
    BonusManager:timerPadXL(dt)

  end
end
--

function SceneCasseBrique.draw()
  --
  BackGround:draw()
  MiniWaal:draw()
  --
  padManager.draw()
  mapManager.draw()
  BonusManager.draw()
  BallManager.draw()
  playerManager.draw()
  --
  BestScore:draw()
  --
  BM:draw()
end
--

function SceneCasseBrique.keypressed(key)
  if key == "escape" then
    love.mouse.setX(pad.x)
    BM.show = not BM.show
    BestScore.show = false
  end

  if debug then
    if key == "delete" then
      for i = #lst_briques , 1 , - 1 do
        table.remove(lst_briques, i)
      end
    elseif key == "space" then
      for i = 1, #Ball do
        local b = Ball[i]
        b.power = 10
        Sounds.power_up:play()
      end
    elseif key == "p" then
      BonusManager.PadXL = true
    elseif key == "s" then
      for i = 1, #Ball do
        local b = Ball[i]
        b.speed = 1000
        Sounds.power_up:play()
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