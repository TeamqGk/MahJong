local globals = {}


-- Police par defaut
Font = {}
for i=1, 100 do
  Font[i] = love.graphics.newFont(i)
end



-- Vars Globals
mouse = love.mouse
mouse.x, mouse.y = love.mouse.getPosition()
mouse.w, mouse.h = 1, 1
mouse.ox, mouse.oh = 0.5, 0.5
--
mouse.l = nil
mouse.c = nil
mouse.onGrid = false
--
function mouse.update(dt)
  mouse.x, mouse.y = love.mouse.getPosition()
end

screen = {}
screen.x, screen.y = 0, 0
screen.w_def, screen.h_def = love.graphics.getDimensions()
screen.w, screen.h = screen.w_def, screen.h_def
screen.ox, screen.oy = screen.w * 0.5, screen.h * 0.5
screen.sx, screen.sy = 1, 1

function screen.update(dt)
  local w,h = love.graphics.getDimensions()
  if w ~= screen.w_def or h ~= screen.h_def then -- changement de resolution !
    screen.w, screen.h = love.graphics.getDimensions()
    screen.ox, screen.oy = screen.w * 0.5, screen.h * 0.5
    screen.sx = w / screen.w_def
    screen.sx = h / screen.h_def
  end
end









-- MATH Formules
globals.math = {}

function globals.math.newRandom()
  love.math.setRandomSeed(love.timer.getTime()) -- set Random Seed !
end
--

-- Returns the angle between two points.
function globals.math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end

-- Returns the distance between two points.
function globals.math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

-- Collision detection function; type AABB
-- Returns true if two boxes overlap, false if they don't;
-- x1,y1 are the top-left coords of the first box, while w1,h1 are its width and height;
-- x2,y2,w2 & h2 are the same, but for the second box.
function globals.math.AABB(x1,y1,w1,h1, x2,y2,w2,h2)  return x1 < x2+w2 and  x2 < x1+w1 and  y1 < y2+h2 and  y2 < y1+h1 end
--
function globals.math.AABB_Object(pObjectA, pObjectB) -- assume object havent x, y, w, h
  return globals.math.AABB(pObjectA.x,pObjectA.y,pObjectA.w,pObjectA.h,   pObjectB.x,pObjectB.y,pObjectB.w,pObjectB.h)
end
--

-- Collision detection function; type AABB Adapted for Simulate Rect on a Circle... Not the best but simple.
function globals.math.AABB_circleRect(x1,y1,r1, x2,y2,w2,h2)
  local circle_x1 = x1 - r1
  local circle_y1 = y1 - r1
  local circle_w1 = x1 + r1
  local circle_h1 = y1 + r1
  return circle_x1 < x2+w2 and  x2 < circle_x1+circle_w1 and  y1 < y2+h2 and  y2 < circle_y1+circle_h1 end
  --

  function globals.math.AABB_circleRect_Object(pCircle, pRect) -- -- assume object Circle in first and have x, y, rayon and second is Rect with x,y,w,h
    globals.math.AABB_circleRect(pCircle.x,pCircle.y,pCircle.rayon,    pRect.x,pRect.y,pRect.w,pRect.h)
  end
  --




  return globals -- return table to require (main)
