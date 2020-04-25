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
--


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

function globals.math.circleRect(Circle_x, Circle_y, Circle_radius,              Rectangle_x, Rectangle_y, Rectangle_w, Rectangle_h)

  -- temporary variables to set edges for testing
  local testX = Circle_x
  local testY = Circle_y

  -- which edge is closest?
  -- horizontal (x)
  if (Circle_x < Rectangle_x) then-- test left edge
    testX = Rectangle_x    
  elseif (Circle_x > Rectangle_x + Rectangle_w) then-- right edge
    testX = Rectangle_x + Rectangle_w
  end 
  -- Vertical (Y)
  if (Circle_y < Rectangle_y) then -- top edge
    testY = Rectangle_y    
  elseif (Circle_y > Rectangle_y + Rectangle_h) then -- bottom edge
    testY = Rectangle_y + Rectangle_h  
  end 

-- get distance from closest edges
  local distX = Circle_x - testX
  local distY = Circle_y - testY
  local distance = math.sqrt( (distX*distX) + (distY*distY) ) -- Pythagore

-- if the distance is less than the radius, collision!
  if (distance <= Circle_radius) then
    return {true, testX, testY}
  else
    return false
  end
end
--




return globals -- return table to require (main)