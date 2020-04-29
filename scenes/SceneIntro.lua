local SceneIntro = {}
---------------------------- START ----------------------------

local hero = {}
local map = {}
--

local pPrint = false

function map:init()
  self.x = 0
  self.y = 0
  self.w = screen.w
  self.x = screen.h
  --
  self.lig = 9
  self.col = 16


  for l = 1, self.lig do
    for c = 1, self.col do
      -- ?!
    end
  end
end
--

function hero:init()
  -- position et angle sur la map
  self.x = 0
  self.y = 0
  self.angle = 270

  -- mouvement du hero ? pas pour tt de suite lol
  self.speed = 0
  self.accel = 60

  -- je sais pas is j'ne aurais besoin tt de suite lol'
  self.timer = {}
  self.timer.run = false
  self.timer.temps = 0
  self.timer.finish = 6 -- 6 secondes pour faire l'anim'

  -- simulation de distance
  self.vision = {}
  self.vision.left = 0
  self.vision.right = 90
  self.vision.distance = 400
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
  self.wall.topLeft = {x = self.vision.x1,     y = self.vision.y1 }
  self.wall.topRight = {x = self.vision.x2,    y = self.vision.y1 }
  self.wall.downLeft = {x = self.vision.x1,    y = self.vision.y2 }
  self.wall.downRight = {x = self.vision.x2,   y = self.vision.y2 }
end
--

function copyToTable(t)
  local v = {}
  for k, v in pairs(t) do

  end
  return v
end
--

--
function hero:polygonDraw(...)
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
  if not pPrint then
    print("la table vertices contient : ")
    for k, v in pairs(vertices) do
      print(k.." : "..tostring(v))
    end
    pPrint = true
  end
  --
  love.graphics.polygon("fill", vertices )
  love.graphics.setColor(0,0,0,1)
  love.graphics.polygon("line", vertices )
  love.graphics.setColor(1,1,1,1)
end
--

function hero:update(dt)
end
--

function hero:camDraw()
  -- reset
  love.graphics.setColor(1,1,1,1)

  --bg unique pour l'instant' (normalement non visible,n si visible c'est un violet flashy bien degueux !')
  love.graphics.setColor(0.5,0.25,0.5,1)
  love.graphics.rectangle("fill", 0, 0, screen.w, screen.h )


  -- plafond (bleue nuit)
  love.graphics.setColor(0.416,0.353,0.804,1)
  hero:polygonDraw(self.corner.topLeft, self.cam.topLeft, self.cam.topRight, self.corner.topRight, self.wall.topRight, self.wall.topLeft)



  -- mur (jaune)
  love.graphics.setColor(1,0.843,0,1)
  hero:polygonDraw(self.wall.topLeft, self.wall.topRight, self.wall.downRight, self.wall.downLeft)

  -- sol (gris)
  love.graphics.setColor(0.412,0.412,0.412,1)
  hero:polygonDraw(self.corner.downLeft, self.cam.downLeft, self.cam.downRight, self.corner.downRight, self.wall.downRight, self.wall.downLeft)

  -- côtés (jaune orange)
  -- left
  love.graphics.setColor(0.804,0.522,0.247,1)
  hero:polygonDraw(self.corner.topLeft, self.wall.topLeft, self.wall.downLeft, self.corner.downLeft)
  -- right
  love.graphics.setColor(0.804,0.522,0.247,1)
  hero:polygonDraw(self.corner.topRight, self.wall.topRight, self.wall.downRight, self.corner.downRight)


-- reset
  love.graphics.setColor(1,1,1,1)
end
--












function SceneIntro.load() -- love.load()
  hero:init()
  map:init()
end
--

function SceneIntro.update(dt) -- love.updadte(dt)
end
--

function SceneIntro.draw()-- love.draw()-- love.draw()
  hero:camDraw()
end
--

function SceneIntro.keypressed(key, scancode, isrepeat) -- love.keypressesed()
  if key == "escape" then
    SceneManager:setScene("MenuIntro")
  end
end
-- etc...

---------------------------- END -----------------------------------------
return SceneIntro
