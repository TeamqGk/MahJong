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



return globals -- return table to require (main)
