local SceneIntro = {}
---------------------------- START ----------------------------

local view25D = {}
local map = {}
local title = {}
local pressStart = {}
--
local lg = love.graphics


function pressStart:init()
  self.run = true
  self.font = Font
  self.size = math.floor(title.size * 0.5) --  800 * 600 == size a 100
  if self.size < 22 then self.size = 22 end
  self.string = "PRESS START"
  self.alpha = 0
  self.color = {0.502,0,0.502,self.alpha}
  self.print = love.graphics.newText(self.font[self.size],self.string)
  self.w, self.h = self.print:getDimensions()
  --
  self.ox = self.w * 0.5 
  self.oy = self.h * 0.5
  self.x = screen.ox
  self.y = screen.oy
  self.rotate = 0
  self.sx = 1
  self.sy = 1
  --
  self.exit = false
  --
  self.timer = {}
  self.timer.start = 0
  self.timer.finish = 60
  self.timer.speed = 10
  --
  self.timer.scale = 0
  self.timer.scaleSpeed = 2
end
--

function pressStart:update(dt)
  if SceneIntro.ready then

    -- zoom zoom zoom
    self.timer.scale = self.timer.scale + (self.timer.scaleSpeed * dt)
    if self.timer.scale >= 1 then
      self.timer.scale = 1
      self.timer.scaleSpeed = 0 - self.timer.scaleSpeed
    elseif self.timer.scale <= 0 then
      self.timer.scale = 0
      self.timer.scaleSpeed = 0 - self.timer.scaleSpeed
    end
    self.alpha = self.timer.scale
    self.color = {0.502,0,0.502,self.alpha}
    self.sx = 1 + self.alpha
    self.sy = 1 + self.alpha
    --


    -- timer to exit
    self.timer.start = self.timer.start + (self.timer.speed * dt)
    if self.timer.start >= self.timer.finish then
      self.exit = true
    end
    --
    if self.exit then
      SceneManager:setScene("MenuIntro")
    end
  end
end
--

function pressStart:draw()
  if SceneIntro.ready then
    lg.setColor(self.color)
    lg.draw(self.print, self.x, self.y, self.rotate, self.sx, self.sy, self.ox, self.oy)
--    lg.print(tostring(self.timer.start.." + "..self.timer.speed.." * dt".."sur"..self.timer.finish),10,10)
  end
end
--

function title:init()
  self.show = true
  self.font = Font_Title
  self.size = (screen.h / 600) * 100 --  800 * 600 == size a 100
  if self.size > #self.font then self.size = #self.font end
  self.sizeReel = self.size
  self.string = "THE GRID PROJECT".."\n\n".."PRESENTED BY".."\n\n".."CRYPTO LOGIQ".."\n".."MASK".."\n".."HYDROGENE"
  self.print = love.graphics.newText(self.font[self.size],self.string)
  self.w, self.h = self.print:getDimensions()
  --
  self.timer = {}
  self.timer.start = 0
  self.timer.finish = 1
  self.timer.speed = 1
  --
  self.color = {}
  self.alpha = 0
  self.color[1] = {0,1,0,self.alpha}
  self.color[2] = {1,1,1,self.alpha}
  self.color[3] = {1,1,1,self.alpha}
  self.string = {self.color[1],"THE GRID PROJECT","\n\n",self.color[2],"PRESENTED BY","\n\n",self.color[3],"CRYPTO LOGIQ","\n","MASK","\n","HYDROGENE"}
  self.print:setf(self.string, self.w,'center')
  --
  self.ox = self.w * 0.5 
  self.oy = self.h * 0.5
  self.x = screen.ox
  self.y = screen.oy
  self.rotate = 0
  self.sx = 1
  self.sy = 1
end
--

function title:update(dt)
  if map.run then

    -- timer effects
    self.timer.start = self.timer.start + (self.timer.speed * dt)
    if self.timer.start >= self.timer.finish then
      self.timer.start = self.timer.finish
      self.timer.speed = 0 - self.timer.speed
    elseif self.timer.start <= 0.25 then
      self.timer.start = 0.25
      self.timer.speed = 0 - self.timer.speed
    end
    --
    self.alpha = self.timer.start
    --
    self.color[1] = {0,1,0,self.alpha}
    self.color[2] = {1,1,1,self.alpha}
    self.color[3] = {1,1,1,self.alpha}
    self.string = {self.color[1],"The Grid Project","\n\n",self.color[2],"Presented By","\n\n",self.color[3],"Crypto Logiq","\n","MasK","\n","Hydrogene"}
    self.print:setf(self.string, self.w,'center')
    --
    if self.w > map.w - 10 or self.h > map.h - 10 then  
      self.sizeReel = self.sizeReel - dt * (100/3)
      self.size = math.floor(self.sizeReel)
      if self.sizeReel <= 1 then self.sizeReel = 1 end
      if self.size <= 1 then self.size = 1 end
      self.print:setFont(self.font[self.size])  
      --
      self.print:setf(self.string, self.w,'center')
      --
      self.w, self.h = self.print:getDimensions()
    else
      if not pressStart.run then
        pressStart:init()
      end
      SceneIntro.ready = true
    end
    self.ox = self.w * 0.5 
    self.oy = self.h * 0.5
    self.x = screen.ox
    self.y = screen.oy
    self.rotate = 0 --math.cos(self.alpha)

  end
end
--


function title:draw()
  if map.run then
    -- Title
    lg.setColor(1,1,1,self.alpha)
--  lg.print("THE GRID PROJECT",screen.ox, screen.oy)
    lg.draw(self.print, self.x, self.y, self.rotate, self.sx, self.sy, self.ox, self.oy)
  end
end
--

function map:init()
  self.run = false
  self.alpha = 0
  --
  self.x = 0
  self.y = 0
  self.w = screen.w
  self.h = screen.h
  --
  self.lig = 9
  self.col = 16
  --
end
--

function map:createPoints()
  local ul = view25D.wall.topLeft
  local ur = view25D.wall.topRight
  local dl = view25D.wall.downLeft
  local dr = view25D.wall.downRight
  --
  local x = ul.x
  local y = ul.y
  map.x = x
  map.y = y
  --
  local w = ur.x - ul.x
  local h = dl.y - ul.y
  map.w = w
  map.h = h
  --
  local caseW = w / map.col
  local caseH = h / map.lig
  map.caseW = caseW
  map.caseH = caseH
  --
  local up = true
  local left = true
  --
  for l = 1, map.lig do -- lignes
    local line = {}
    line.y1 = y
    line.y2 = y
    line.yMax = y
    line.vy = 0
    --
    line.speed = 500
    --
    if left then
      line.type = "leftToRight"
      line.x1 = ul.x
      line.x2 = line.x1
      --
      line.xMax = ur.x
      --
      line.distance = line.xMax - line.x1
      line.vx = 1
    else
      line.type = "rightToLeft"
      line.x1 = ur.x
      line.x2 = line.x1
      --
      line.xMax = ul.x
      --
      line.distance = line.xMax - line.x1
      line.vx = -1
    end
    --
    left = not left
    --
    table.insert(map, line)
    y = y + caseH
  end
  --
  for c = 1, map.col do
    local line = {}
    --
    line.speed = 150
    --
    line.x1 = x
    line.x2 = x
    line.xMax = x
    line.vx = 0
    --
    if up then
      line.type = "upToDown"
      line.y1 = ul.y
      line.y2 = line.y1
      --
      line.yMax = dl.y
      --
      line.distance = line.yMax - line.y1
      line.vy = 1
    else
      line.type = "downToUp"
      line.y1 = dl.y
      line.y2 = line.y1
      --
      line.yMax = ul.y
      --
      line.distance = line.yMax - line.y1
      line.vy = -1
    end
    --
    up = not up
    table.insert(map, line)
    --
    x = x + caseW
  end
end
--

function map:lineUpdate(dt)
  for i = #map, 1, -1 do
    local line = map[i]
    --
    if line.x2 <= line.xMax then
      line.x2 = line.x2 + (( line.vx * dt) * (line.distance/3))
    elseif line.x2 >= line.xMax then
      line.x2 = line.xMax
    end
    --
    if line.y2 <= line.yMax then
      line.y2 = line.y2 + (( line.vy * dt) * (line.distance/3))
    elseif line.x2 >= line.xMax then
      line.y2 = line.yMax
    end
    --
  end
end
--

function map:lineDraw()
  --
  local alpha = 0
  local max = 0.25
  if map.alpha >= max then
    alpha = max
  else
    alpha = map.alpha
  end
  --
  lg.setColor(0,1,0,alpha)
  --
  for i = #map, 1, -1 do
    local line = map[i]
    --
    lg.line(line.x1,line.y1,line.x2,line.y2)
  end
  lg.setColor(1,1,1,1)
end
--

function map:update(dt)
  if map.run then
    if map.alpha < 1 then map.alpha = map.alpha + dt * (4/3) else map.alpha = 1 end
    if not map.ready then map:createPoints(); map.ready = true end
    --
    map:lineUpdate(dt)
    --
  end
  if not view25D.timer.run then
    if view25D.wall.alpha > 0 then
      view25D.wall.alpha = view25D.wall.alpha - dt * (4/6)
    else
      view25D.wall.alpha = 0
      map.run = true
    end
  end
end
--

function map:draw()
  if map.run then
    -- grid
    map:lineDraw()
    if map.ready then
      lg.setColor(0,1,0,map.alpha)
      lg.rectangle("line", self.x, self.y, self.w, self.h)
      lg.setColor(1,1,1,1)
    end

  end
end
--

function view25D:init()
  -- position et angle sur la map
  self.x = 0
  self.y = 0
  self.h = 32
  self.w = self.h * 0.25
  self.angle = 270

  -- mouvement du view25D ? pas pour tt de suite lol
  self.speed = 0
  self.accel = 150

  -- je sais pas si j'en aurais besoin tt de suite lol'
  self.timer = {}
  self.timer.run = false
  self.timer.temps = 0
  self.timer.finish = 6 -- 6 secondes pour faire l'anim'

  -- simulation de distance
  self.vision = {}
  --
  self.vision.distanceMin = screen.oy * 0.15
  self.vision.distanceMax = screen.oy * 0.9
  self.vision.distance = self.vision.distanceMax
  --
  self.vision.fov = 60 -- def 60 max 110 conseillé
  self.vision.left = self.angle - (self.vision.fov * 0.5)
  self.vision.right = self.angle + (self.vision.fov * 0.5)
  --
  self.vision.h = screen.h - (self.vision.distance * 2)
  self.vision.w = screen.w - (self.vision.distance * 2)

  -- haut
  self.vision.x1 = 0 + self.vision.distance
  self.vision.y1 = 0 + self.vision.distance
  self.vision.x2 = self.vision.x1 + self.vision.w
  self.vision.y2 = self.vision.y1 + self.vision.h

  -- vision corner
  self.corner = {}
  self.corner.topLeft = {x = 0,             y = self.vision.distance * 0.4 }
  self.corner.topRight = {x = screen.w,     y = self.vision.distance * 0.4 }
  self.corner.downLeft = {x = 0,            y = screen.h - self.vision.distance * 0.2 }
  self.corner.downRight = {x = screen.w,    y = screen.h - self.vision.distance * 0.2 }

  -- cam corner vision
  self.cam = {}
  self.cam.topLeft = {x = 0,            y = 0 }
  self.cam.topRight = {x = screen.w,    y = 0 }
  self.cam.downLeft = {x = 0,           y = screen.h }
  self.cam.downRight = {x = screen.w,   y = screen.h }

  -- wall corner
  self.wall = {}
  self.wall.alpha = 1
  self.wall.topLeft = {x = self.vision.x1,     y = self.vision.y1 }
  self.wall.topRight = {x = self.vision.x2,    y = self.vision.y1 }
  self.wall.downLeft = {x = self.vision.x1,    y = self.vision.y2 }
  self.wall.downRight = {x = self.vision.x2,   y = self.vision.y2 }
end
--

--
function view25D:polygonDraw(...)
  local t = {...}
  local vertices = {}
  for k, v in pairs(t) do
    if type(v) == "table" then
      local x, y
      for k, v in pairs(v) do
        if k == "x" then
          x = v
        else
          y = v
        end
      end
      table.insert(vertices, x)
      table.insert(vertices, y)
    end
  end
  --
  lg.polygon("fill", vertices )
  lg.setColor(0,0,0,1)
  lg.polygon("line", vertices )
  lg.setColor(1,1,1,1)
end
--

function view25D:update(dt)
  -- simulation de distance
  if self.vision.distance >= self.vision.distanceMin then
    self.timer.run = true
  end

  if self.timer.run then
    self.speed =  self.speed + self.accel * dt
    if self.speed >= self.accel then
      self.speed = self.accel
    end
    --
    self.vision.distance = self.vision.distance - self.speed * dt
    if self.vision.distance <= self.vision.distanceMin then
      self.vision.distance = self.vision.distanceMin
      self.timer.run = false
    end
  end
  --
  self.vision.fov = 60 -- def 60 max 110 conseillé
  self.vision.left = self.angle - (self.vision.fov * 0.5)
  self.vision.right = self.angle + (self.vision.fov * 0.5)
  --
  self.vision.h = screen.h - (self.vision.distance * 2)
  self.vision.w = screen.w - (self.vision.distance * 2)

  -- haut
  self.vision.x1 = 0 + self.vision.distance
  self.vision.y1 = 0 + self.vision.distance
  self.vision.x2 = self.vision.x1 + self.vision.w
  self.vision.y2 = self.vision.y1 + self.vision.h

  -- vision corner
  self.corner.topLeft = {x = 0,             y = self.vision.distance * 0.4 }
  self.corner.topRight = {x = screen.w,     y = self.vision.distance * 0.4 }
  self.corner.downLeft = {x = 0,            y = screen.h - self.vision.distance * 0.2 }
  self.corner.downRight = {x = screen.w,    y = screen.h - self.vision.distance * 0.2 }

  -- cam corner vision
  self.cam.topLeft = {x = 0,            y = 0 }
  self.cam.topRight = {x = screen.w,    y = 0 }
  self.cam.downLeft = {x = 0,           y = screen.h }
  self.cam.downRight = {x = screen.w,   y = screen.h }

  -- wall corner
  self.wall.topLeft = {x = self.vision.x1,     y = self.vision.y1 }
  self.wall.topRight = {x = self.vision.x2,    y = self.vision.y1 }
  self.wall.downLeft = {x = self.vision.x1,    y = self.vision.y2 }
  self.wall.downRight = {x = self.vision.x2,   y = self.vision.y2 }
end
--

function view25D:camDraw()
  -- reset
  lg.setColor(1,1,1,1)


  -- plafond (bleue nuit)
  lg.setColor(0.416,0.353,0.804,1)
  view25D:polygonDraw(self.corner.topLeft, self.cam.topLeft, self.cam.topRight, self.corner.topRight, self.wall.topRight, self.wall.topLeft)



  -- mur (jaune)
  lg.setColor(1,0.843,0,self.wall.alpha)
  view25D:polygonDraw(self.wall.topLeft, self.wall.topRight, self.wall.downRight, self.wall.downLeft)

  -- sol (gris)
  lg.setColor(0.412,0.412,0.412,1)
  view25D:polygonDraw(self.corner.downLeft, self.cam.downLeft, self.cam.downRight, self.corner.downRight, self.wall.downRight, self.wall.downLeft)

  -- côtés (jaune orange)
  -- left
  lg.setColor(0.804,0.522,0.247,1)
  view25D:polygonDraw(self.corner.topLeft, self.wall.topLeft, self.wall.downLeft, self.corner.downLeft)
  -- right
  lg.setColor(0.804,0.522,0.247,1)
  view25D:polygonDraw(self.corner.topRight, self.wall.topRight, self.wall.downRight, self.corner.downRight)


-- reset
  lg.setColor(1,1,1,1)
end
--

function SceneIntro.load() -- love.load()
  --
  view25D:init()
  map:init()
  title:init()
  --
end
--

function SceneIntro.update(dt) -- love.updadte(dt)
  --
  if not Sounds.LogoIntro:isPlaying() and not Sounds.Digital_Number_FX:isPlaying() then 
    Sounds.Digital_Number_FX:play()
  end
  --
  view25D:update(dt)
  map:update(dt)
  title:update(dt)
  pressStart:update(dt)
end
--

function SceneIntro.draw()-- love.draw()-- love.draw()
  love.graphics.setBackgroundColor(0.439,0.502,0.565,1)
  --
  view25D:camDraw()
  map:draw()
  title:draw()
  pressStart:draw()
end
--


function SceneIntro.keypressed(key, scancode, isrepeat) -- love.keypressesed()
  if SceneIntro.ready or key == "escape" then
    if key then
      SceneManager:setScene("MenuIntro")
    end
  end
end
--


function SceneIntro.mousepressed(x,y,button)-- love.keypressesed()
  if SceneIntro.ready then
    if button then
      SceneManager:setScene("MenuIntro")
    end
  end
end
--


-- etc...

---------------------------- END -----------------------------------------
return SceneIntro