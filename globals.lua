local globals = {}



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